import 'package:beamer/beamer.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/main_screens/main_screen.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_helper_core.dart';
import 'package:flutter/cupertino.dart';

final simpleLocationBuilder = RoutesLocationBuilder(
    routes: {
      '/': (context, state, data) {
        return BeamPage(
          key: ValueKey('home'),
          title: 'home',
          child: const MainScreen(
              initialDashboardMarker: DashboardMarker.home
          ),
        );
      },
      '/:mainId': (context, state, data) {
        final initialMarker = state.pathParameters['mainId'];
        ExploreWebHelperCore.selectedListing = false;
        ExploreWebHelperCore.selectedSearch = false;
        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.map;

        return BeamPage(
          key: ValueKey(initialMarker),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
                initialDashboardMarker: getDashboardMarker(initialMarker),
          ),
        );
      },
      '/:mainId/reservation/:reservationId': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final resId = state.pathParameters['reservationId'];
        ReservationHelperCore.selectedReservationItem = null;
        ReservationHelperCore.currentListingManagerForm = null;
        ReservationHelperCore.currentUserProfile = null;
        ReservationHelperCore.selectedReservationItem = null;
        ReservationHelperCore.currentActivityForm = null;
        ReservationHelperCore.selectedReservationAttendeeItem = null;
        ReservationHelperCore.currentAttendeeTicketItems = null;
        return BeamPage(
          key: ValueKey('reservation-$resId'),
          name: 'reservation',
          child: MainScreen(
              initialReservationId: resId != null ? UniqueId.fromUniqueString(resId) : null,
              initialDashboardMarker: getDashboardMarker(mainId),
          ),
        );
      },
      '/:mainId/:searchType': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['searchType'];
        ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);
        ExploreWebHelperCore.selectedListing = false;
        ExploreWebHelperCore.selectedSearch = false;

          return BeamPage(
            key: ValueKey('search-${searchType}'),
            name: 'search',
            child: MainScreen(
                initialDashboardMarker: getDashboardMarker(mainId)
            ),
          );
      },
      '/:mainId/:searchType/listing/:listingId': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['searchType'];
        final listingId = state.pathParameters['listingId'];

        ExploreWebHelperCore.currentFacilityItemId = listingId != null ? UniqueId.fromUniqueString(listingId) : UniqueId();
        ExploreWebHelperCore.selectedListing = true;
        ExploreWebHelperCore.selectedSearch = false;
        ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);
        ExploreWebHelperCore.selectedReservationItem = null;
        ExploreWebHelperCore.currentReservationItemId = null;

        return BeamPage(
          key: ValueKey('listing'),
          name: 'listing',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
      '/:mainId/:searchType/listing/:listingId/reservation/:reservationId': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['searchType'];
        final listingId = state.pathParameters['listingId'];
        final reservationId = state.pathParameters['reservationId'];

        ExploreWebHelperCore.currentFacilityItemId = listingId != null ? UniqueId.fromUniqueString(listingId) : UniqueId();
        ExploreWebHelperCore.currentReservationItemId = reservationId != null ? UniqueId.fromUniqueString(reservationId) : UniqueId();
        ExploreWebHelperCore.selectedReservationItem = null;
        ExploreWebHelperCore.selectedFacilityItem = null;
        ExploreWebHelperCore.selectedListing = true;
        ExploreWebHelperCore.selectedSearch = false;
        ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);

        return BeamPage(
          key: ValueKey('reservation_preview'),
          name: 'reservation_preview',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
      '/:mainId/:searchType/search': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['searchType'];

        ExploreWebHelperCore.selectedSearch = true;
        ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);
        return BeamPage(
          key: ValueKey('search_discovery'),
          name: 'search_discovery',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
  }
);

