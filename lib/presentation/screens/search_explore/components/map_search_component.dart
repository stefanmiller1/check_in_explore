import 'dart:async';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'helper.dart';

class MapSearchContainer extends StatefulWidget {

  final DashboardModel model;
  final Function(String?) selectedListing;


  const MapSearchContainer(
      {super.key,
      required this.model,
      required this.selectedListing});

  @override
  State<MapSearchContainer> createState() => _MapSearchContainerState();
}

class _MapSearchContainerState extends State<MapSearchContainer> {

  late int _minZoom = 0;
  late int _maxZoom = 19;
  late String _mapStyle = '';

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString('assets/style/map_style.txt').then((string) {
        _mapStyle = string;
      });
    });
  }

  void _onMapCreated(BuildContext context, GoogleMapController controller, List<ListingManagerForm> listings) {
    MapHelper.mapController = controller;

    setState(() {
      _initMarkers(context, listings);
      widget.selectedListing(null);
    });
  }

  void _initMarkers(BuildContext context, List<ListingManagerForm> listings) async {

    for (ListingManagerForm forms in listings.where((element) =>
        element.listingProfileService.listingLocationSetting.longLat.isNotEmpty)
      ..toList()) {
      MapHelper.markers.putIfAbsent(
          forms.listingServiceId.getOrCrash(),
          () => MapMarker(
              childMarkerId: forms.listingServiceId.getOrCrash(),
              markerId: forms.listingServiceId.getOrCrash(),
              position: LatLng(
                  double.parse(forms
                      .listingProfileService.listingLocationSetting.longLat
                      .split(',')[0]),
                  double.parse(forms
                      .listingProfileService.listingLocationSetting.longLat
                      .split(',')[1])),
              markerTitle: completeTotalPriceWithOutCurrency((forms.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), forms.listingProfileService.backgroundInfoServices.currency),
              icon: BitmapDescriptor.defaultMarker));
    }

    MapHelper.clusterManager = await MapHelper.initClusterManager(
      MapHelper.markers.values.toList(),
      _minZoom,
      _maxZoom,
    );

    await MapHelper.updateMarkers(
        context,
        widget.model,
        null, markerTap: (e) {
          setState(() {
        });
    });

  }


  void _didStartMovingMap(BuildContext context) async {
    setState(() {
      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(true));
      widget.selectedListing(null);
    });

    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(false));
        widget.selectedListing(null);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
        builder: (context, state) {
      return state.maybeMap(
          loadAllPublicListingItemsSuccess: (e) => retrievedListings(context, e.items),
          loadAllPublicListingItemsFailure: (e) => cannotFindAnyListings(),
          orElse: () => cannotFindAnyListings());
    });
  }


  Widget retrievedListings(BuildContext context, List<ListingManagerForm> listings) {

    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
            mapToolbarEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(43.7, -79.2),
              zoom: MapHelper.currentZoom,
            ),
            mapType: MapType.normal,
            markers: context.read<ListingsSearchRequirementsBloc>().state.markers,
            onCameraMoveStarted: () => _didStartMovingMap(context),
            onMapCreated: (controller) => _onMapCreated(context, controller, listings),
            onCameraMove: (CameraPosition position) {
              setState(() {

              MapHelper.updateMarkers(
                context,
                widget.model,
                position.zoom,
                markerTap: (marker) {
                  setState(() {
                    if (marker.childMarkerId != null) {
                      MapHelper.selectedMarkerId = UniqueId.fromUniqueString(marker.childMarkerId!);
                      context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedListingIdChanged(UniqueId.fromUniqueString(marker.childMarkerId!)));
                    } else {
                      MapHelper.selectedMarkerId = null;
                      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
                  }
                });
              });
            });
          }
        ),
        Positioned(
          top: 15,
          child: Opacity(
              opacity: context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading ? 1 : 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: widget.model.mobileBackgroundColor,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 6.5),
                    child: Text(
                      '•••',
                      style: TextStyle(
                          color: widget.model.paletteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ),
        ),

        Positioned(
          right: 15,
          top: 15,
          child: InkWell(
            onTap: () async {
              Position position = await MapHelper.determineCurrentPosition(context, widget.model);

              setState(() {
                MapHelper.mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                            zoom: 14,
                            target: LatLng(position.latitude, position.longitude)
                    )
                  )
                );
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: widget.model.mobileBackgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.location_on, semanticLabel: 'Current Location', color: widget.model.paletteColor),
              ),
            ),
          ),
        )
      ],
    );
  }



}
