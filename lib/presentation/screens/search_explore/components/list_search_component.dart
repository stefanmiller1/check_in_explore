import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/search_explore_options/search_explore_item/search_explore_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;

import 'list_helper.dart';

class ListSearchContainer extends StatefulWidget {

  final DashboardModel model;
  final UniqueId? currentUserId;
  final Function(ListingManagerForm listing) didSelectListing;
  final Function(ListingManagerForm? listing, ReservationItem res) didSelectReservation;

  const ListSearchContainer({super.key, required this.model, required this.currentUserId, required this.didSelectListing, required this.didSelectReservation});

  @override
  State<ListSearchContainer> createState() => _ListSearchContainerState();
}

class _ListSearchContainerState extends State<ListSearchContainer> {

  late SpaceOptionSizeDetail? currentSpaceOption = null;

  @override
  void initState() {
    super.initState();
  }


  /// retrieve all loaded listing and corresponding activities (based on activity type, status(public/private) & end date). Load all listings/reservations/posts into [SearchExploreItem] - depending on result item type display all searchExploreItems
  List<SearchExploreItem> createListItemsForSearchContainer(List<ListingManagerForm> listings, List<ReservationItem> reservations) {

    final List<SearchExploreItem> searchItems = [];
    searchItems.clear();

    /// can implement the use of scores based on each listing parameter...number of 'good' reviews...number of completed activities...based on points that add up to then be used as sort order (can also make as part of firebase query parameter)
    for (ListingManagerForm listing in listings) {
      final listingToAdd = SearchExploreItem(
        exploreItemId: listing.listingServiceId,
        userId: listing.listingProfileService.backgroundInfoServices.listingOwner,
        exploreType: SearchExploreType.facility
      );
      searchItems.add(listingToAdd);
    }

    for (ReservationItem reservation in reservations) {
      final listingToAdd = SearchExploreItem(
          exploreItemId: reservation.reservationId,
          exploreItemSubId: reservation.instanceId,
          userId: reservation.reservationOwnerId,
          exploreType: SearchExploreType.activity
      );
      searchItems.add(listingToAdd);
    }
    return searchItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList(context.read<ListingsSearchRequirementsBloc>().state.listings.map((e) => e.listingServiceId.getOrCrash()).toList(), null, null, [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current])),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                resLoadInProgress: (_) => Positioned(
                    // bottom: bottomOffset,
                    child: Container(
                      height: 115,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: widget.model.mobileBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                        ),
                      child: Center(child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3))),
                    ),
                  )
                ),
                loadReservationListSuccess: (items) => getReservationsForSearchListView(context, items.item),
                orElse: () => getReservationsForSearchListView(context, [])
            );
          },
        )
    );
  }

  Widget loadExploreItems() {
    return Container();
  }

  Widget noExploreItemsFound() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Text('none found...'),
    );
  }

  Widget getReservationsForSearchListView(BuildContext context, List<ReservationItem> reservations) {
    if (createListItemsForSearchContainer(context.read<ListingsSearchRequirementsBloc>().state.listings.toList(), reservations).isEmpty) {
      return noExploreItemsFound();
    } else {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// featured/suggested search items?
        /// happening this week?

        /// wrap collection of facility & activity.
        Container(
          width: (MediaQuery.of(context).size.width >= 1400) ? 1400 : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 18.0,
              children: createListItemsForSearchContainer(context.read<ListingsSearchRequirementsBloc>().state.listings.toList(), reservations).map(
                  (e) {

                    return getSearchComponentListItem(
                        context,
                        widget.model,
                        widget.currentUserId ?? UniqueId(),
                        e.exploreType,
                        context.read<ListingsSearchRequirementsBloc>().state.listings.toList().where((element) => element.listingServiceId == e.exploreItemId ||
                                    element.listingServiceId == e.exploreItemSubId).isNotEmpty ?
                        context.read<ListingsSearchRequirementsBloc>().state.listings.toList().where(
                                (element) => element.listingServiceId == e.exploreItemId ||
                                    element.listingServiceId == e.exploreItemSubId).first : null,
                        reservations.where((element) => element.reservationId == e.exploreItemId).isNotEmpty ?
                        reservations.where((element) => element.reservationId == e.exploreItemId).first : null,
                        currentSpaceOption,
                        didSelectListing: (listing) {
                            widget.didSelectListing(listing);
                        },
                        didSelectReservation: (listing, res) {
                            widget.didSelectReservation(listing, res);
                        }, currentSpaceOptionSizeDetail: (space) {
                          setState(() {
                            currentSpaceOption = space;
                          });
                      }
                    );
                  }
              ).toList(),
            ),
          ),
        ),

        /// load more button...

        ],
      );
    }
  }
}