import 'package:beamer/beamer.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

class ExploreWebHelperCore {

  static late bool isLoading = false;
  static late bool selectedListing = false;
  static late bool selectedSearch = false;
  static SearchExploreHelperMarker searchExploreMarker = SearchExploreHelperMarker.map;
  static UniqueId? currentFacilityItemId = null;
  static UniqueId? currentReservationItemId = null;
  static late ListingManagerForm? selectedFacilityItem = null;
  static late ReservationItem? selectedReservationItem = null;

  static void didSelectFacilityItem(BuildContext context, ListingManagerForm listing) {
    ExploreWebHelperCore.isLoading = true;
    // ExploreWebHelperCore.selectedSearch = false;
    ExploreWebHelperCore.selectedListing = true;
    ExploreWebHelperCore.selectedFacilityItem = listing;
    ExploreWebHelperCore.currentFacilityItemId = listing.listingServiceId;
    ExploreWebHelperCore.selectedReservationItem = null;
    ExploreWebHelperCore.currentReservationItemId = null;

    Beamer.of(context).update(
        configuration: RouteInformation(
            location: '/${DashboardMarker.home.toString()}/${SearchExploreHelperMarker.map.toString()}/listing/${listing.listingServiceId.getOrCrash()}'
        ),
        rebuild: false
    );
  }

  static void didSelectReservationItem(BuildContext context, ListingManagerForm listing, ReservationItem reservation) {
    ExploreWebHelperCore.isLoading = true;
    ExploreWebHelperCore.selectedSearch = false;
    ExploreWebHelperCore.selectedListing = true;
    ExploreWebHelperCore.selectedFacilityItem = listing;
    ExploreWebHelperCore.currentFacilityItemId = listing.listingServiceId;
    ExploreWebHelperCore.selectedReservationItem = reservation;
    ExploreWebHelperCore.currentReservationItemId = reservation.reservationId;

    Beamer.of(context).update(
        configuration: RouteInformation(
            location: '/${DashboardMarker.home.toString()}/${SearchExploreHelperMarker.map.toString()}/listing/${listing.listingServiceId.getOrCrash()}/reservation/${reservation.reservationId.getOrCrash()}'
        ),

        rebuild: false
    );

  }

}


enum SearchExploreHelperMarker {map, list}

SearchExploreHelperMarker getSearchExploreMarker(String? type) {
  for (SearchExploreHelperMarker item in SearchExploreHelperMarker.values) {
    if (type == item.toString()) {
      return item;
    }
  }
  return SearchExploreHelperMarker.map;
}

String getTitleForExploreType(SearchExploreHelperMarker type) {
  switch (type) {
    case SearchExploreHelperMarker.map:
      return 'Show List';
    case SearchExploreHelperMarker.list:
      return 'Show Map';
    // case SearchExploreHelperMarker.search:
    //   return 'Show Search';
  }
}

IconData getIconForExploreType(SearchExploreHelperMarker type) {
  switch (type) {
    case SearchExploreHelperMarker.map:
      return Icons.list_rounded;
    case SearchExploreHelperMarker.list:
      return Icons.map_outlined;
  }
}