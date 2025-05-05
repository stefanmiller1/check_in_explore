import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ListingSearchResult extends StatefulWidget {

  final bool isOpen;
  final DashboardModel model;
  late PageController controller;
  final PanelController panelController;
  final Function() didUpdate;
  ListingSearchResult({super.key, required this.isOpen, required this.model, required this.didUpdate, required this.controller, required this.panelController});

  @override
  State<ListingSearchResult> createState() => _ListingSearchResultState();
}

class _ListingSearchResultState extends State<ListingSearchResult> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          widget.isOpen ? Expanded(child: listingResult(context, context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading, context.read<ListingsSearchRequirementsBloc>().state.listings.toList()
          )) : Expanded(child: closedState(context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading, context.read<ListingsSearchRequirementsBloc>().state.listings.toList())),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget closedStateError() {
    return Container();
  }

  Widget closedState(bool isLoading, List<ListingManagerForm> listings) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (context.read<ListingsSearchRequirementsBloc>().state.listings.isNotEmpty) widget.panelController.open();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: widget.model.mobileBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
            ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 120,
                height: 5,
                decoration: BoxDecoration(
                  color: widget.model.disabledTextColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
              const SizedBox(height: 17),
              isLoading ? Shimmer.fromColors(
                enabled: isLoading,
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    color: widget.model.accentColor.withOpacity(0.15),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ) : Text('${listings.length} Listings Found', style: TextStyle(fontSize: 17, color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
            ],
          )
        ),
      ),
    );
  }

  Widget listingResultError() {
    return Container();
  }

  Widget listingResult(BuildContext context, bool isLoading, List<ListingManagerForm> listings) {

    late List<ListingManagerForm> sortedList = [];
    sortedList.addAll(listings);
    sortedList.sort((a, b) => compareToBool(a.listingServiceId == context.read<ListingsSearchRequirementsBloc>().state.selectedListingId).compareTo(compareToBool(b.listingServiceId == context.read<ListingsSearchRequirementsBloc>().state.selectedListingId)));

    return PageView(
      controller: widget.controller,
      pageSnapping: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      onPageChanged: (page) {

        setState(() {

          // final Marker marker = context.read<ListingsSearchRequirementsBloc>().state.markers.toList()[page];
          // MapHelper.selectedMarkerId = UniqueId.fromUniqueString(marker.markerId.value);
          // context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedListingIdChanged(UniqueId.fromUniqueString(marker.markerId.value)));
          // if (MapHelper.currentZoom <= 5) {
          //   MapHelper.mapController.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //           CameraPosition(
          //               zoom: MapHelper.currentZoom,
          //               target: marker.position
          //       )
          //     )
          //   );
          // }
          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.isMarkersLoading(false));


        });
      },
      children: sortedList.map(
        (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06),
            child: ListingResultMainCard(
              listing: e,
              model: widget.model,
              showReservations: true,
              isLoading: isLoading,
              didSelectMainImage: (listing) {
                didSelectCreateNewActivity(
                    context,
                    widget.model,
                    null,
                    listing,
                    didSaveActivity: (res) {

                    },
                    didPublishActivity: (res) {
                      
                    }
                );

              },
              didSelectFooter: (ListingManagerForm listing) {

              },
              didSelectEmbeddedRes: (listing, res) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return DismissiblePage(
                        startingOpacity: 0.75,
                        backgroundColor: Colors.transparent,
                        direction: DismissiblePageDismissDirection.startToEnd,
                        isFullScreen: true,
                        onDismissed: () {
                          Navigator.of(context).pop();
                        },
                        child: ActivityPreviewScreen(
                          model: widget.model,
                          listing: listing,
                          reservation: res,
                          currentReservationId: res.reservationId,
                          currentListingId: listing.listingServiceId,
                          didSelectBack: () {  },
                      ),
                    );
                  }
                ));
              },
            ),
          ),
        )
      ).toList()
    );
  }
}

int compareToBool(bool isAvailable) {
  if (isAvailable) {
    return 0;
  } else if (isAvailable) {
    return -1;
  }
  return 1;
}