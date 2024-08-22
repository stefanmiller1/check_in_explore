import 'dart:async';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MapSearchContainer extends StatefulWidget {

  final DashboardModel model;
  final Function(ListingManagerForm) didSelectListingPreview;
  final Function(String?) selectedListing;


  const MapSearchContainer(
      {super.key,
      required this.model,
      required this.selectedListing,
      required this.didSelectListingPreview});

  @override
  State<MapSearchContainer> createState() => _MapSearchContainerState();
}

class _MapSearchContainerState extends State<MapSearchContainer> {

  late String _mapStyle = '';

  @override
  void initState() {
    super.initState();
    MapHelper.pageController = PageController(viewportFraction: (kIsWeb) ? 0.75 : 1);
    MapHelper.listingStream = FirebaseMapFacade.instance.mapListings(latitude: MapHelper.lat, longitude: MapHelper.lng, selectedRadius: MapHelper.currentZoom);
    checkForCurrentLocation();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString('assets/style/map_style.txt').then((string) {
        _mapStyle = string;
      });
    });
  }

  void checkForCurrentLocation() async {
    // Position position = await MapHelper.determineCurrentPosition(context, widget.model);
    // if (MapHelper.lat == 43.6532 && MapHelper.lat == -79.3832) {
    //   MapHelper.lat = position.latitude;
    //   MapHelper.lng = position.longitude;
    // }

    final listing = await MapHelper.listingStream.first;
    MapHelper.initMarkers(context, mounted, widget.model, listing);

  }


  @override
  void dispose() {

    MapHelper.pageController.dispose();
    super.dispose();
  }

  void _onMapCreated(BuildContext context, GoogleMapController controller) {
    MapHelper.mapController = controller;
  }


  void _didStartMovingMap(BuildContext context) async {

    // setState(() {
    //   context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(true));
    //   widget.selectedListing(null);
    // });

    Future.delayed(const Duration(seconds: 2), () async {
    //   setState(() {
        MapHelper.showMapReload = true;
    //     context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(false));
    //     widget.selectedListing(null);
      });
    // });
  }

  void _didSelectRefresh(BuildContext context) async {
    MapHelper.showMapReload = false;
    MapHelper.listingStream = FirebaseMapFacade.instance.mapListings(latitude: MapHelper.lat, longitude: MapHelper.lng, selectedRadius: MapHelper.currentZoom);
    // MapHelper.currentZoom = 15;

    final listing = await MapHelper.listingStream.first;
    setState(() {
      MapHelper.initMarkers(context, mounted, widget.model, listing);
    });
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ListingManagerForm>>(
        stream: MapHelper.listingStream,
        builder: (context, snapshot) {
          return retrievedListings(context, snapshot.data ?? [], snapshot.connectionState == ConnectionState.waiting);
      },
    );
  }


  Widget retrievedListings(BuildContext context, List<ListingManagerForm> listings, bool isLoading) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: GoogleMap(
              mapToolbarEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(MapHelper.lat, MapHelper.lng),
                zoom: MapHelper.currentZoom,
              ),
              mapType: MapType.normal,
              markers: MapHelper.markerSet,
              onCameraMoveStarted: () => _didStartMovingMap(context),
              onMapCreated: (controller) => _onMapCreated(context, controller),
              onCameraMove: (CameraPosition position) {
                setState(() {

                  MapHelper.showMapReload = true;
                  MapHelper.lat = position.target.latitude;
                  MapHelper.lng = position.target.longitude;

                  if (kIsWeb) {
                    if (MapHelper.currentZoom >= position.zoom + 1.5 || MapHelper.currentZoom <= position.zoom - 1.5 || MapHelper.currentZoom == position.zoom) return;

                    MapHelper.initMarkers(context, mounted, widget.model, context.read<ListingsSearchRequirementsBloc>().state.listings.toList());
                    MapHelper.currentZoom = position.zoom;
                  }

                  if (!(kIsWeb)) {
                    if (MapHelper.currentZoom >= position.zoom + 0.6 || MapHelper.currentZoom <= position.zoom - 0.6)  {

                    MapHelper.initMarkers(context, mounted, widget.model, context.read<ListingsSearchRequirementsBloc>().state.listings.toList());
                    MapHelper.currentZoom = position.zoom;
                   }
                 }
              });
            }
          ),
        ),
        Positioned(
          top: (kIsWeb) ? 75 : 15,
          child: Opacity(
              opacity: context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading ? 1 : 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: widget.model.mobileBackgroundColor,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Chip(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: widget.model.mobileBackgroundColor,
                      label: Text(
                        '•••',
                        style: TextStyle(
                            color: widget.model.paletteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ),
            )
          ),
        ),

        Positioned(
          right: 15,
          top: 15,
          child: PointerInterceptor(
            child: InkWell(
              onTap: () async {
                Position position = await MapHelper.determineCurrentPosition(context, widget.model);
                MapHelper.listingStream = FirebaseMapFacade.instance.mapListings(latitude: position.latitude, longitude: position.longitude, selectedRadius: 14);
                final listing = await MapHelper.listingStream.first;
                MapHelper.initMarkers(context, mounted, widget.model, listing);

                setState(() {
                  MapHelper.mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                          CameraPosition(
                              zoom: 14,
                              target: LatLng(position.latitude - 0.005, position.longitude)
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
          ),
        ),
        if (!(Responsive.isDesktop(context))) getListingPagingController(
          context,
          widget.model,
          context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading,
          (kIsWeb) ? 20 : 150 + (MediaQuery.of(context).size.height * 0.21),
          context.read<ListingsSearchRequirementsBloc>().state.listings.toList(),
          context.read<ListingsSearchRequirementsBloc>().state.selectedListingId,
          didChangePage: (page) {
            final ListingManagerForm listing = context.read<ListingsSearchRequirementsBloc>().state.listings.toList()[page];

            /// update camera position - zoom in and center on marker

              MapHelper.mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(
                        zoom: MapHelper.currentZoom,
                        target: LatLng(listing.listingProfileService.listingLocationSetting.locationPosition!.latitude, listing.listingProfileService.listingLocationSetting.locationPosition!.longitude)
                    )
                )
            );

            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedListingIdChanged(listing.listingServiceId));
          },
          didSelectListing: (listing) {

            widget.didSelectListingPreview(listing);
            //   if (kIsWeb) {
            //     widget.didSelectListingPreview(listing);
            //   } else {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (_) {
            //           return FacilityPreviewScreen(
            //             listing: listing,
            //             listingId: listing.listingServiceId,
            //             model: widget.model,
            //             isAutoImplyLeading: false,
            //             selectedReservationsSlots: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
            //             didSelectBack: () {},
            //             didSelectReservation: (listing, res) {
            //
            //           },
            //         );
            //       }
            //   ));
            // }
          }
        ),

        if (MapHelper.showMapReload) Positioned(
          top: 15,
          left: 15,
          child: PointerInterceptor(
            child: Responsive.isMobile(context) ? InkWell(
              onTap: () async {
                _didSelectRefresh(context);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: widget.model.mobileBackgroundColor,
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.refresh_rounded, color: widget.model.paletteColor)
                ),
              ),
            ) : Container(
              height: 40,
              decoration: BoxDecoration(
                  color: widget.model.mobileBackgroundColor,
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Center(child: FilterChip(
                    onSelected: (e) async {
                      _didSelectRefresh(context);
                    },
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.transparent,
                    label: Text('Refresh', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)), avatar: Icon(Icons.refresh_rounded, color: widget.model.paletteColor)),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
