import 'dart:math';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helper.dart';

class ListingResultMain extends StatefulWidget {

  final bool isLoading;
  final bool showReservations;
  final ListingManagerForm listing;
  final DashboardModel model;
  final Function(SpaceOptionSizeDetail space) didChangeSpaceOptionItem;
  final Function(ListingManagerForm listing) didSelectListingItem;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes;

  const ListingResultMain({super.key, required this.isLoading, required this.model, required this.listing, required this.didSelectListingItem, required this.showReservations, required this.didSelectEmbeddedRes, required this.didChangeSpaceOptionItem});

  @override
  State<ListingResultMain> createState() => _ListingResultMainState();
}

class _ListingResultMainState extends State<ListingResultMain> {


  late bool isShowingListing = true;
  late final PageController _listingPageController = PageController(initialPage: 0);
  late int _currentPageIndex = 0;

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return widget.isLoading ? isLoadingMainContainer(context) : mainContainerForListingResult();
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


  Widget mainContainerForListingResult() {
    return Stack(
      children: [
          /// base listing page
          listingSpacesPagePreview(
            context,
            widget.model,
            panelHeight(context) - listingHeaderHeight - 125,
            _listingPageController,
            _currentPageIndex,
            widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
            !(isShowingListing),
            onPageChanged: (page, currentSpace) {
              List<SpaceOption> spaceOptions = widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r);
              setState(() {
                _currentPageIndex = page;
                widget.didChangeSpaceOptionItem(currentSpace);
              });
            },
          didSelectItem: () {
              widget.didSelectListingItem(widget.listing);
          }
        ),
          /// auto scrolling pageview for activities
        if (isShowingListing && widget.showReservations) retrievedReservations(
            context,
            didSelectEmbeddedRes: (listing, res) => widget.didSelectEmbeddedRes(listing, res)
        ),
        if (widget.showReservations) Positioned(
            top: 5,
            right: 5,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (isShowingListing) ? widget.model.paletteColor : widget.model.accentColor
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        isShowingListing = !isShowingListing;
                      });
                    },
                    tooltip: 'Show Listing',
                    icon: Icon(Icons.home_outlined, color: (isShowingListing) ? widget.model.accentColor : widget.model.paletteColor),
                ),
              ),
            ),
          )
        )
      ],
    );
  }


  Widget retrievedReservations(BuildContext context, {required Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes}) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([widget.listing.listingServiceId.getOrCrash()], null, null, [ReservationSlotState.confirmed, ReservationSlotState.current])),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
            return state.maybeMap(
              resLoadInProgress: (_) => isLoadingMainContainer(context),
              loadReservationListSuccess: (e) {
                return ActivityResultMain(
                    reservations: e.item,
                    model: widget.model,
                    listing: widget.listing,
                    didSelectEmbeddedRes: (listing, res) => didSelectEmbeddedRes(listing, res)
                );
              },
              orElse: () => Container()
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


  // Widget reservationPreviewer(ReservationItem reservation) {
  //   return Stack(
  //     alignment: Alignment.topCenter,
  //     children: [
  //
  //     ],
  //   );
  // }


}