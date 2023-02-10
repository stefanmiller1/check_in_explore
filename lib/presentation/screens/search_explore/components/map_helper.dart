import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as UI;

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapHelper {

  static late GoogleMapController mapController;
  static late UniqueId? selectedMarkerId = null;
  static Fluster<MapMarker>? clusterManager;
  static late double currentZoom = 5;
  static final HashMap<String, MapMarker> markers = HashMap<String, MapMarker>();

  // static bool areMarkersLoading = true;
  // static final Set<Marker> markers = {};

  static Future<BitmapDescriptor> getMarkerImageFromUrl(
      String url, {
        int? targetWidth,
      }) async {
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);

    Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    if (targetWidth != null) {
      markerImageBytes = await _resizeImageBytes(
        markerImageBytes,
        targetWidth,
      );
    }

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  /// Draw a [clusterColor] circle with the [clusterSize] text inside that is [width] wide.
  ///
  /// Then it will convert the canvas to an image and generate the [BitmapDescriptor]
  /// to be used on the cluster marker icons.
  static Future<BitmapDescriptor> _getClusterMarker(
      String topClusterFee,
      Color clusterColor,
      Color textColor,
      ) async {
    final UI.PictureRecorder pictureRecorder = UI.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: topClusterFee,
        style: TextStyle(
          fontSize: 36,
          // fontWeight: FontWeight.bold,
          color: textColor,
        )
      )
    )..layout();

    const double padding = 40;
    final rect = Offset.zero & Size(textPainter.width + padding, textPainter.height + padding);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(60)), paint);


    textPainter.layout();
    textPainter.paint(
      canvas,
      const Offset(padding / 2, padding / 2),
    );


    final image = await pictureRecorder.endRecording().toImage(
      (textPainter.width + padding).toInt(),
      (textPainter.height + padding).toInt(),
    );
    final data = await image.toByteData(format: UI.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
  

  static Future<UI.Image> _loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
  
  
  static Future<BitmapDescriptor> getGeneralMarkerIcon(DashboardModel model) async {

    final UI.PictureRecorder pictureRecorder = UI.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final houseIcon = await _loadUiImage('assets/map_icons/noun-house-5004704.png');
    final Paint paint = Paint()..color = Colors.black.withOpacity(0.15);
    final Paint innerCirclePaint = Paint()..color = Colors.black;

    final double radius = 400 / 2;

    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawCircle(Offset(radius, radius), radius * 0.4, innerCirclePaint);
    paintImage(canvas: canvas, rect: UI.Rect.fromLTWH(radius - 150 / 2, radius - 150 / 2, 150, 150), image: houseIcon);

    final image = await pictureRecorder.endRecording().toImage(radius.toInt() * 2, radius.toInt() * 2);
    final data = await image.toByteData(format: UI.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());

  }

  static Future<Uint8List> _resizeImageBytes(
      Uint8List imageBytes,
      int targetWidth,
      ) async {
    final UI.Codec imageCodec = await UI.instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
    );

    final UI.FrameInfo frameInfo = await imageCodec.getNextFrame();

    final data = await frameInfo.image.toByteData(format: UI.ImageByteFormat.png);

    return data!.buffer.asUint8List();
  }

  static Future<Fluster<MapMarker>> initClusterManager(
      List<MapMarker> markers,
      int minZoom,
      int maxZoom,
      ) async {
    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (
          BaseCluster? cluster,
          double? lng,
          double? lat,
          ) {

        return MapMarker(
          markerId: cluster?.childMarkerId ?? cluster!.id.toString(),
          position: LatLng(lat!, lng!),
          isCluster: true,
          clusterId: cluster?.id,
          pointsSize: cluster?.pointsSize,
          markerTitle: null,
          onMarkerTap: null,
          childMarkerId: cluster?.childMarkerId,
        );
      }
    );
  }

  static Future<List<Marker>> getClusterMarkers(
      BuildContext context,
      HashMap<String, MapMarker>? listingMarkers,
      Fluster<MapMarker>? clusterManager,
      String? selectedMarker,
      double currentZoom,
      Color clusterColor,
      Color clusterTextColor,
      {required Function(MapMarker) onMarkerTap}
      ) {

    if (clusterManager == null) return Future.value([]);


    return Future.wait(clusterManager.clusters(
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {

      late MapMarker? clusterMarker = listingMarkers?[mapMarker.childMarkerId];
      mapMarker.onMarkerTap = () {
        return onMarkerTap(mapMarker);
      };

      if (mapMarker.isCluster!) {

          mapMarker.markerTitle = clusterMarker?.toMarker().infoWindow.title ?? '';
          mapMarker.icon = await _getClusterMarker(
            clusterMarker?.toMarker().infoWindow.title ?? '',
            (selectedMarker == mapMarker.childMarkerId) ? clusterTextColor : clusterColor,
            (selectedMarker == mapMarker.childMarkerId) ? clusterColor :  clusterTextColor,
          );

      } else {

        mapMarker.icon = await _getClusterMarker(
          mapMarker.markerTitle ?? '',
          (selectedMarker == mapMarker.childMarkerId) ? clusterTextColor : clusterColor,
          (selectedMarker == mapMarker.childMarkerId) ? clusterColor :  clusterTextColor,
        );
      }
      return mapMarker.toMarker();
    }).toList());
  }


  static Future<Position> determineCurrentPosition(BuildContext context, DashboardModel model) async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final snackBar = SnackBar(
          backgroundColor: model.paletteColor,
          content: Text('Access to your Location is not allowed', style: TextStyle(color: model.accentColor))
      );
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (permission == LocationPermission.deniedForever) {
      final snackBar = SnackBar(
          backgroundColor: model.paletteColor,
          content: Text('Location permissions are permanently denied, we cannot request permissions.', style: TextStyle(color: model.accentColor))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static Future<double?>? determineDistanceAway(LatLng distanceTo) async {
    LocationPermission permission;
    Position currentPosition;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, distanceTo.latitude, distanceTo.longitude);
  }



  static Future<void> updateMarkers(BuildContext context, DashboardModel? model, double? updatedZoom, {required Function(MapMarker) markerTap}) async {
    if (MapHelper.clusterManager == null || updatedZoom == MapHelper.currentZoom) return;

    if (updatedZoom != null) {
      MapHelper.currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      context,
      MapHelper.markers,
      MapHelper.clusterManager,
      (MapHelper.selectedMarkerId != null) ? MapHelper.selectedMarkerId?.getOrCrash() : null,
      MapHelper.currentZoom,
      model?.webBackgroundColor ?? Colors.white,
      model?.paletteColor ?? Colors.black,
      onMarkerTap: (cluster) async {
        markerTap(cluster);
      });

    context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.markersDidChange(updatedMarkers.toSet()));

  }

}

