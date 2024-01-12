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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:check_in_facade/check_in_facade.dart';

class MapHelper {


  static late GoogleMapController mapController;

  /// [PageController]
  static late PageController pageController;

  /// [ScrollController] for web only side panel scroll view
  static late ScrollController scrollController;

  /// Set of displayed markers and cluster markers on the map
  static final Set<Marker> markerSet = Set();

  /// Current map zoom. Initial zoom will be 15, street level
  static late double currentZoom = 10;

  /// Map reLoading flag
  static bool showMapReload = false;

  /// [Fluster] instance used to manage the clusters
  static Fluster<MapMarker>? _clusterManager;

  /// [HashMap] of displayed [MapMarker]s and cluster markers on the map
  static HashMap<String, MapMarker> _markers = HashMap<String, MapMarker>();

  /// [Stream] for handling all listings
  static late Stream<List<ListingManagerForm>> listingStream;


  static late int _minZoom = 0;
  static late int _maxZoom = 19;
  static late double lng = -79.3832;
  static late double lat = 43.6532;

  static void initMarkers(BuildContext context, DashboardModel model, List<ListingManagerForm> listings) async {

    markerSet.clear();
    _markers.clear();
    _clusterManager = null;
    context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.listingsChange([]));
    context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.listingsChange(listings));
    context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(true));
    for (ListingManagerForm forms in listings) {
      String? listingImage;

      for (SpaceOption space in forms.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)) {
        if (space.quantity.where((element) => element.photoUri != null).isNotEmpty) {
          listingImage = space.quantity.firstWhere((element) => element.photoUri != null).photoUri;
        }
      }

      _markers.putIfAbsent(
          forms.listingServiceId.getOrCrash(),
              () => MapMarker(
              isSelected: context.read<ListingsSearchRequirementsBloc>().state.selectedListingId?.getOrCrash() == forms.listingServiceId.getOrCrash(),
              childMarkerId: forms.listingServiceId.getOrCrash(),
              markerId: forms.listingServiceId.getOrCrash(),
              onMarkerTap: () {

              },
              position: LatLng(
                  forms.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0,
                  forms.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0
              ),
              markerImageUrl: listingImage,
              markerTitle: completeTotalPriceWithOutCurrency((forms.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), forms.listingProfileService.backgroundInfoServices.currency),
              icon: BitmapDescriptor.defaultMarker
          )
      );
    }

    try {

    _clusterManager = await initClusterManager(
      _markers.values.toList(),
      _minZoom,
      _maxZoom,
    );


    Future.delayed(const Duration(seconds: 1), () async {
      await _updateMarkers(context, model, currentZoom, _clusterManager, _markers);
      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(false));
      });
      } catch (e) {
    }

  }


  static Future<void> _updateMarkers(
      BuildContext context,
      DashboardModel model, double?
      updatedZoom,
      Fluster<MapMarker>? manager,
      HashMap<String, MapMarker> markers) async {
    if (manager == null) return;

    if (updatedZoom != null) {
      currentZoom = updatedZoom;
    }


    final updatedMarkers = await getClusterMarkers(
        context,
        markers,
        manager,
        currentZoom,
        model.webBackgroundColor,
        model.paletteColor,
        onMarkerTap: (cluster) async {

            /// update camera position - zoom in and center on marker
            if (cluster.longitude != null && cluster.latitude != null) {
              // mapController.animateCamera(
              //     CameraUpdate.newCameraPosition(
              //         CameraPosition(
              //             zoom: MapHelper.currentZoom,
              //             target: kIsWeb ? LatLng(cluster.latitude!, cluster.longitude!) : LatLng(cluster.latitude! - 0.07, cluster.longitude!)
              //         )
              //     )
              // );
            }

            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
            /// update current selected listing
            if (context.read<ListingsSearchRequirementsBloc>().state.selectedListingId?.getOrCrash() == cluster.markerId) {
              // context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
            } else {
              Future.delayed(const Duration(seconds: 1), () async {
              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedListingIdChanged(UniqueId.fromUniqueString(cluster.markerId)));
              });
            }

            /// animate to selected listing in [PageController]
            Future.delayed(const Duration(seconds: 2), () async {
              if (!(kIsWeb)) {
                if (pageController.positions.isNotEmpty) {
                  final int itemPage = context.read<ListingsSearchRequirementsBloc>().state.listings.toList().indexWhere((element) => element.listingServiceId.getOrCrash() == cluster.markerId);
                  pageController.animateToPage(
                        itemPage, duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut);
                }
              }
            });

            if (kIsWeb) {
              if (pageController.positions.isNotEmpty) {
                final int itemPage = context.read<ListingsSearchRequirementsBloc>().state.listings.toList().indexWhere((element) => element.listingServiceId.getOrCrash() == cluster.markerId);
                pageController.jumpToPage(itemPage);
              }
              if (scrollController.positions.isNotEmpty) {
                final int itemPage = context.read<ListingsSearchRequirementsBloc>().state.listings.toList().indexWhere((element) => element.listingServiceId.getOrCrash() == cluster.markerId);
                scrollController.jumpTo(itemPage * 550);
              }
            }

            markers[cluster.markerId]?.isSelected = !(markers[cluster.markerId]!.isSelected)!;
            await _updateMarkers(context, model, updatedZoom, manager, markers);

          // final selectedMarkerItem = marker.firstWhere((element) => element.markerId.value == cluster.markerId);
            // marker.remove(selectedMarkerItem);
            //
            // late Marker selectedCluster = selectedMarkerItem;
            // print(selectedMarkerItem);
            //
            //
            // selectedCluster.icon = await _getClusterMarker(
            //     cluster.markerTitle ?? '',
            //     cluster.markerImageUrl,
            //     (context.read<ListingsSearchRequirementsBloc>().state.selectedListingId?.getOrCrash() == cluster.childMarkerId) ? model.webBackgroundColor : model.paletteColor,
            //     (context.read<ListingsSearchRequirementsBloc>().state.selectedListingId?.getOrCrash() == cluster.childMarkerId) ? model.paletteColor :  model.webBackgroundColor,
            //   );
            //
            // marker.add(selectedCluster);
            //
            // context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.markersDidChange(marker));

        });

    markerSet..clear()
      ..addAll(updatedMarkers);

    context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.markersDidChange(markerSet));

  }


  /// Draw a [clusterColor] circle with the [clusterSize] text inside that is [width] wide.
  ///
  /// Then it will convert the canvas to an image and generate the [BitmapDescriptor]
  /// to be used on the cluster marker icons.
  static Future<BitmapDescriptor> _getClusterMarker(
      String topClusterFee,
      String? clusterImage,
      Color clusterColor,
      Color textColor,
      ) async {
    final double size = (kIsWeb) ? 65 : 150;



    final UI.PictureRecorder pictureRecorder = UI.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: topClusterFee,
        style: TextStyle(
          fontSize: (kIsWeb) ? 16 : 36,
          // fontWeight: FontWeight.bold,
          color: textColor,
        )
      )
    )..layout();


    const double padding = (kIsWeb) ? 20 : 40;
    final whiteTextBox = Offset.zero & Size(textPainter.width + padding, textPainter.height + padding);

    canvas.drawRRect(RRect.fromRectAndRadius(whiteTextBox, Radius.circular(60)), paint);

    textPainter.layout();
    textPainter.paint(
      canvas,
      const Offset(padding / 2, padding / 2),
    );

    final centerOffset = ((textPainter.width + padding) - size)/2;
    final rectangle = (kIsWeb) ? Rect.fromLTWH(centerOffset, 50, size, size) : Rect.fromLTWH(centerOffset, 85, size, size);
    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        rectangle,
        Radius.circular(size)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        rectangle,
        Radius.circular(size)));

    canvas.clipPath(clipPath);

    if (clusterImage != null) {
      final File markerImageFile = await DefaultCacheManager().getSingleFile(clusterImage ?? '');
      final Uint8List imageUint8List = await markerImageFile.readAsBytes();
      final UI.Codec codec = await UI.instantiateImageCodec(imageUint8List);
      final UI.FrameInfo imageFI = await codec.getNextFrame();
      paintImage(canvas: canvas, rect: rectangle, image: imageFI.image, fit: BoxFit.cover);
    } else {
      final houseIcon = await _loadUiImage('assets/map_icons/noun-house-5004704.png');
      final Paint innerCirclePaint = Paint()..color = Colors.black;
      const double radius = (kIsWeb) ? 75 : 400 / 2;
      canvas.drawCircle(Offset(radius, radius), radius, innerCirclePaint);
      paintImage(canvas: canvas, rect: rectangle, image: houseIcon, fit: BoxFit.cover);
    }


    final image = await pictureRecorder.endRecording().toImage(
      (textPainter.width + padding + size).toInt(),
      (textPainter.height + padding + size + padding).toInt(),
    );

    final data = await image.toByteData(format: UI.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<Uint8List?> loadNetworkImage(path) async {
    final completed = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completed.complete(info)));
    final imageInfo = await completed.future;
    final byteData = await imageInfo.image.toByteData(format: UI.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
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

    const double radius = (kIsWeb) ? 75 : 400 / 2;
    const double imageSize = (kIsWeb) ? 50 : 150;

    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawCircle(Offset(radius, radius), radius * 0.4, innerCirclePaint);
    paintImage(canvas: canvas, rect: const UI.Rect.fromLTWH(radius - imageSize / 2, radius - imageSize / 2, imageSize, imageSize), image: houseIcon);

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
      minZoom: _minZoom,
      maxZoom: _maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 74,
      points: markers,
      createCluster: (
          BaseCluster? cluster,
          double? lng,
          double? lat,
          ) {

        return MapMarker(
          markerId: cluster!.id.toString(),
          position: LatLng(lat!, lng!),
          isCluster: cluster.isCluster,
          isSelected: false,
          clusterId: cluster.id,
          pointsSize: cluster.pointsSize,
          markerTitle: null,
          onMarkerTap: null,
          childMarkerId: cluster.childMarkerId,
        );
      }
    );
  }

  static Future<List<Marker>> getClusterMarkers(
      BuildContext context,
      HashMap<String, MapMarker>? listingMarkers,
      Fluster<MapMarker>? clusterManager,
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
          mapMarker.icon = await _getClusterMarker(
            clusterMarker?.markerTitle ?? '',
            clusterMarker?.markerImageUrl,
            (mapMarker.isSelected ?? false) ? clusterTextColor : clusterColor,
            (mapMarker.isSelected ?? false) ? clusterColor : clusterTextColor,
          );
          // mapMarker.markerTitle = null;

      } else {

          mapMarker.icon = await _getClusterMarker(
          mapMarker.markerTitle ?? clusterMarker?.markerTitle ?? '',
          clusterMarker?.markerImageUrl,
          (mapMarker.isSelected ?? false) ? clusterTextColor : clusterColor,
          (mapMarker.isSelected ?? false) ? clusterColor : clusterTextColor,
        );
        // mapMarker.markerTitle = null;
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
       return Future.error('permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      final snackBar = SnackBar(
          backgroundColor: model.paletteColor,
          content: Text('Location permissions are permanently denied, we cannot request permissions.', style: TextStyle(color: model.accentColor))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.error('permission denied forever');
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


}

