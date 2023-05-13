import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helper.dart';

class ListingResultMain extends StatefulWidget {

  final bool isLoading;
  final ListingManagerForm listing;
  final DashboardModel model;

  const ListingResultMain({super.key, required this.isLoading, required this.model, required this.listing});

  @override
  State<ListingResultMain> createState() => _ListingResultMainState();
}

class _ListingResultMainState extends State<ListingResultMain> {


  late PageController _pageController = PageController(initialPage: 0);
  late int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading ? isLoadingMainContainer(context) : retrievedReservations(context);
  }

  Widget isLoadingMainContainer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: panelHeight(context) - listingHeaderHeight - 145,
        color: Colors.grey.withOpacity(0.15),
      ),
    );
  }


  Widget retrievedReservations(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([widget.listing.listingServiceId.getOrCrash()], null, null, [ReservationSlotState.requested, ReservationSlotState.cancelled, ReservationSlotState.refunded, ReservationSlotState.current, ReservationSlotState.completed])),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
            return state.maybeMap(
              resLoadInProgress: (_) => isLoadingMainContainer(context),
              loadReservationListFailure: (_) => listingSpacesPagePreview(
                  context,
                  widget.model,
                  panelHeight(context) - listingHeaderHeight - 125,
                  _pageController,
                  _currentPageIndex,
                  widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
                  onPageChanged: (page) {
                    setState(() {
                      _currentPageIndex = page;
                  });
                }
              ),
              loadReservationListSuccess: (e) => listingSpacesPagePreview(
                  context,
                  widget.model,
                  panelHeight(context) - listingHeaderHeight - 125,
                  _pageController,
                  _currentPageIndex,
                  widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
                  onPageChanged: (page) {
                    setState(() {
                      _currentPageIndex = page;
                    });
                  }
              ),
              orElse: () => listingSpacesPagePreview(
                  context,
                  widget.model,
                  panelHeight(context) - listingHeaderHeight - 125,
                  _pageController,
                  _currentPageIndex,
                  widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
                  onPageChanged: (page) {
                    setState(() {
                      _currentPageIndex = page;
                    });
                  }
              ),
          );
        },
      ),
    );
  }

  //
  // Widget retrieveListing(BuildContext context, List<ReservationItem> reservations) {
  //   return BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
  //       builder: (context, state) {
  //         return state.maybeMap(
  //             loadAllPublicListingItemsSuccess: (e) => (e.items.map((e) => e.listingServiceId).contains(UniqueId.fromUniqueString(widget.marker.markerId.value))) ?
  //             listingSpacesPagePreview(
  //                 context,
  //                 widget.model,
  //                 panelHeight(context) - listingHeaderHeight - 125,
  //                 _pageController,
  //                 _currentPageIndex,
  //                 e.items.firstWhere((element) => element.listingServiceId.getOrCrash() == widget.marker.markerId.value).listingProfileService.spaceSetting.spaceTypes.getOrCrash(),
  //                 onPageChanged: (page) {
  //                   setState(() {
  //                     _currentPageIndex = page;
  //                 });
  //               }
  //             ) : noReservationsFound(),
  //           loadAllPublicListingItemsFailure: (e) => noReservationsFound(),
  //           orElse: () => noReservationsFound());
  //       }
  //   );
  // }

  /// first check to see if listings internal programs exist - show fpr each program (i guess internal programs should require the making of reservations that are your own)
  /// reservation content
  /// reservation type
  /// reservation organization
  /// reservation dates (past and coming up)
  /// reservation join upcoming slots
  /// general display...of location and what is happening there within the parameters you choose
  /// reservation messages?
  /// save/bookmark reservation
  /// create a new reservation
  // Widget getDetailsForListing(BuildContext context) {
  //   return BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
  //       builder: (context, state) {
  //         return state.maybeMap(
  //             loadAllPublicListingItemsSuccess: (e) => ,
  //             loadAllPublicListingItemsFailure: (e) => cannotFindAnyListingsHeader(),
  //             orElse: () => cannotFindAnyListingsHeader());
  //     }
  //   );
  // }

  Widget reservationPageView(BuildContext context, List<ReservationItem> reservations) {
    return SizedBox(
      height: panelHeight(context) - listingHeaderHeight - 225,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
              controller: _pageController,
              itemCount: reservations.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPageIndex = page;
                });
              },
              itemBuilder: (context, index) {

                final ReservationItem reservation = reservations[index];

                return Container(
                  // color: Colors.red,
                  child: Center(child: Text(reservation.instanceId.getOrCrash())),
                );
              }
          ),

          Positioned(
            top: 15,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<int>.generate(reservations.length, (int index) => index + 1).asMap().map(
                          (index, e) => MapEntry(index,
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  height: 6,
                                  // width: ((MediaQuery.of(context).size.width ~/ reservations.length) * 0.75).toDouble(),
                                  decoration: BoxDecoration(
                                    color: (index == _currentPageIndex) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                        ),
                      ),
                    )
                  ).values.toList(),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget reservationPreviewer(ReservationItem reservation) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [

      ],
    );
  }


}