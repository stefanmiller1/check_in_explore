import 'package:beamer/beamer.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/main_screens/main_screen.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';

final simpleLocationBuilder = RoutesLocationBuilder(
    routes: {
      '/': (context, state, data) {
        return BeamPage(
          key: ValueKey('home'),
          name: 'home',
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
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
                initialDashboardMarker: getDashboardMarker(initialMarker),
          ),
        );
      },
      '/:mainId/create_my_activity': (context, state, data) {
        ExploreWebHelperCore.selectedListing = false;
        ExploreWebHelperCore.selectedSearch = false;
        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.map;

        return BeamPage(
          key: ValueKey('create_my_activity'),
          name: 'create_my_activity',
          title: 'create my activity',
          child: MainScreen(
            isCreatingNewActivity: true,
              initialDashboardMarker: getDashboardMarker('home')
          )
        );
      },
      '/:mainId/reservation/:reservationId': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final resId = state.pathParameters['reservationId'];

        return BeamPage(
          key: ValueKey('reservation-$resId'),
          name: 'reservation',
          title: 'my reservations',
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
            title: 'search $searchType',
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
          title: 'listing',
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
          title: 'a circle activity',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
      '/:mainId/:searchType/search': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['search`Type'];

        ExploreWebHelperCore.selectedSearch = true;
        ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);
        return BeamPage(
          key: ValueKey('search_discovery'),
          name: 'search_discovery',
          title: 'discovery',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
      '/:mainId/:reservationId/:profileTab': (context, state, data) {

        final initialMarker = state.pathParameters['mainId'];
        final reservationId = state.pathParameters['reservationId'];
        final resTab = state.pathParameters['profileTab'];

        ReservationCoreHelper.resOverViewTabs = getReservationTab(resTab);

        return BeamPage(
          key: ValueKey('reservation_profile'),
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
              initialReservationId: (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null,
              initialDashboardMarker: getDashboardMarker(initialMarker)
          ),
        );
      },
      '/:mainId/:reservationId/attendees': (context, state, data) {
        final initialMarker = state.pathParameters['mainId'];
        final reservationId = state.pathParameters['reservationId'];
        // ReservationHelperCore.selectedReservationId = (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null;

        return BeamPage(
          key: ValueKey('reservation_vendors'),
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
              initialReservationId: (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null,
              initialDashboardMarker: getDashboardMarker(initialMarker)
          ),
        );
      },
      '/:mainId/:reservationId/vendor_forms': (context, state, data) {
        final initialMarker = state.pathParameters['mainId'];
        final reservationId = state.pathParameters['reservationId'];
        // ReservationHelperCore.selectedReservationId = (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null;

        return BeamPage(
          key: ValueKey('reservation_vendors'),
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
              initialReservationId: (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null,
              initialDashboardMarker: getDashboardMarker(initialMarker)
          ),
        );
      },
      '/:mainId/:reservationId/settings/:settingsTab': (context, state, data) {

        final initialMarker = state.pathParameters['mainId'];
        final reservationId = state.pathParameters['reservationId'];
        final settingsNavTab = state.pathParameters['settingsTab'];

        final SettingNavMarker navItem = getReservationSettingNavMarker(settingsNavTab);
        ReservationHelperCore.currentSettingsItemModel = (subActivitySettingItems(null).isNotEmpty && subActivitySettingItems(null).where((e) => e.navItem == navItem).isNotEmpty) ? subActivitySettingItems(null).where((e) => e.navItem == navItem).first : subActivitySettingItems(null)[0];

        return BeamPage(
          key: ValueKey('reservation_settings'),
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
              initialReservationId: (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null,
              initialDashboardMarker: getDashboardMarker(initialMarker)
          ),
        );
      },
  }
);

