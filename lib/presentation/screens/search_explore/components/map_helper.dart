import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as UI;

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_components/marker_widget.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

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
        onMarkerTap: (cluster, listingMarkers) async {

            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(true));
            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
            /// update current selected listing

            Future.delayed(const Duration(milliseconds: 350), () async {
              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(false));
              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedListingIdChanged(UniqueId.fromUniqueString(cluster.childMarkerId ?? cluster.markerId)));
            });


            /// animate to selected listing in [PageController]
            Future.delayed(const Duration(milliseconds: 500), () async {
              if (!(kIsWeb)) {
                if (pageController.positions.isNotEmpty) {
                  final int itemPage = context.read<ListingsSearchRequirementsBloc>().state.listings.toList().indexWhere((element) => element.listingServiceId.getOrCrash() == (cluster.childMarkerId ?? cluster.markerId));
                  pageController.jumpToPage(itemPage);
                  // pageController.animateToPage(
                  //       itemPage, duration: const Duration(milliseconds: 600),
                  //       curve: Curves.easeInOut);
                }
              }
            });

            if (kIsWeb) {
              if (pageController.positions.isNotEmpty) {
                final int itemPage = context.read<ListingsSearchRequirementsBloc>().state.listings.toList().indexWhere((element) => element.listingServiceId.getOrCrash() == (cluster.childMarkerId ?? cluster.markerId));
                pageController.jumpToPage(itemPage);
              }
              if (scrollController.positions.isNotEmpty) {
                final int itemPage = context.read<ListingsSearchRequirementsBloc>().state.listings.toList().indexWhere((element) => element.listingServiceId.getOrCrash() == (cluster.childMarkerId ?? cluster.markerId));
                scrollController.jumpTo(itemPage * 550);
              }
            }

            // markers[cluster.markerId]?.isSelected = !(markers[cluster.markerId]!.isSelected)!;
            await _updateMarkers(context, model, updatedZoom, manager, markers);

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
      String? numberOfClusters,
      String topClusterFee,
      String? clusterImage,
      Color clusterColor,
      Color textColor,
      ) async {
    final double size = (kIsWeb) ? 65 : 150;



    final UI.PictureRecorder pictureRecorder = UI.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainterNOC = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: numberOfClusters,
            style: TextStyle(
              fontSize: (kIsWeb) ? 12 : 25,
              // fontWeight: FontWeight.bold,
              color: textColor,
            )
        )
    )..layout();
    final TextPainter textPainterClusterFee = TextPainter(
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
    final whiteTextBoxFee = Offset.zero & Size(textPainterClusterFee.width + padding, textPainterClusterFee.height + padding);
    final whiteTextBoxClusterCount = Offset((size / 2) - padding, 120) & Size(textPainterNOC.width + padding, textPainterNOC.height + padding);

    canvas.drawRRect(RRect.fromRectAndRadius(whiteTextBoxFee, Radius.circular(60)), paint);
    if (numberOfClusters != null) canvas.drawRRect(RRect.fromRectAndRadius(whiteTextBoxClusterCount, Radius.circular(60)), paint);


    textPainterClusterFee.layout();
    textPainterClusterFee.paint(
      canvas,
      const Offset(padding / 2, padding / 2),
    );

    if (numberOfClusters != null) textPainterNOC.layout();
    if (numberOfClusters != null) {
      textPainterNOC.paint(
      canvas,
      Offset((size / 2) - (padding / 2), 120 + (padding / 2)),
    );
    }

    final centerOffset = ((textPainterClusterFee.width + padding) - size)/2;
    final rectangle = (kIsWeb) ? Rect.fromLTWH(centerOffset, 50, size, size) : Rect.fromLTWH(centerOffset, 85, size, size);
    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(rectangle, Radius.circular(size)));
    canvas.clipPath(clipPath);

    if (clusterImage != null) {
      final File markerImageFile = await DefaultCacheManager().getSingleFile(clusterImage ?? '');
      final Uint8List imageUint8List = await markerImageFile.readAsBytes();
      final UI.Codec codec = await UI.instantiateImageCodec(imageUint8List);
      final UI.FrameInfo imageFI = await codec.getNextFrame();

      paintImage(canvas: canvas, rect: rectangle, image: imageFI.image, fit: BoxFit.cover, );

    } else {
      final houseIcon = await _loadUiImage('assets/map_icons/noun-house-5004704.png');
      final Paint innerCirclePaint = Paint()..color = Colors.black;
      const double radius = (kIsWeb) ? 65 : 400 / 2;
      canvas.drawCircle(Offset(radius + 40, radius + 40), radius, innerCirclePaint);
      paintImage(canvas: canvas, rect: rectangle, image: houseIcon, fit: BoxFit.cover);
    }



    final image = await pictureRecorder.endRecording().toImage(
      (textPainterClusterFee.width <= size ? (size + padding) : textPainterClusterFee.width + padding).toInt(),
      (textPainterClusterFee.height + padding + size + padding + 30).toInt(),
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
        /// Cluster radius in pixels.
      radius: 150,
      /// Adjust the extent by powers of 2 (e.g. 512. 1024, ... max 8192) to get the
      /// desired distance between markers where they start to cluster.
      extent: (kIsWeb) ? 512 : 512,
      /// The size of the KD-tree leaf node, which affects performance.
      nodeSize: (kIsWeb) ? 34 : 74,
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
      {required Function(MapMarker, HashMap<String, MapMarker>?) onMarkerTap}
      ) {

    if (clusterManager == null) return Future.value([]);


    return Future.wait(clusterManager.clusters(
      /// values that control cluster threshold
      [-180, -85, 180, 85],
      currentZoom.toInt(),
    ).map((mapMarker) async {

      late MapMarker? clusterMarker = listingMarkers?[mapMarker.childMarkerId];


      mapMarker.onMarkerTap = () {
        return onMarkerTap(mapMarker, listingMarkers);
      };


      if (mapMarker.isCluster!) {

        print(clusterManager.points(mapMarker.clusterId?.toInt() ?? 1).length);


        mapMarker.icon = await _getClusterMarker(
            clusterManager.points(mapMarker.clusterId?.toInt() ?? 0).length != 0 ? '+ ${clusterManager.points(mapMarker.clusterId?.toInt() ?? 1).length}' : null,
            clusterMarker?.markerTitle ?? '',
            clusterMarker?.markerImageUrl,
            (mapMarker.isSelected ?? false) ? clusterTextColor : clusterColor,
            (mapMarker.isSelected ?? false) ? clusterColor : clusterTextColor,
          );
          // mapMarker.markerTitle = null;

      } else {


        mapMarker.icon = await _getClusterMarker(
          null,
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

