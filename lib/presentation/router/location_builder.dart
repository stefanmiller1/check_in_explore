import 'package:beamer/beamer.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/explore_core_widgets/components/template_components/explore_search_shell.dart';
import 'package:check_in_presentation/core/profile_creator_template/profile_creator_template_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/main_screens/main_screen.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';
import 'package:check_in_domain/domain/misc/explore_services/value_objects.dart';

import '../web_screens/focused_main_container_widgets/activity_vendor_form_manage_widget/actvity_vendor_form_manager_helper.dart';

final simpleLocationBuilder = RoutesLocationBuilder(
    routes: {
      '/': (context, state, data) {
        return const BeamPage(
          key: ValueKey('home'),
          name: 'home',
          title: 'home',
          child: MainScreen(
              initialDashboardMarker: DashboardMarker.search
          ),
        );
      },
      '/:mainId': (context, state, data) {
        final initialMarker = state.pathParameters['mainId'];
        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;

        return BeamPage(
          key: ValueKey(initialMarker),
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
                initialDashboardMarker: getDashboardMarker(initialMarker),
          ),
        );
      },
      '/home/:mainId': (context, state, data) {
        
        print('this is the home page');
        final initialMarker = state.pathParameters['mainId'];
        print(state.pathParameters['mainId']);
        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;

        return BeamPage(
          key: ValueKey(initialMarker),
          name: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          title: getDashboardMarkerTitle(getDashboardMarker(initialMarker)),
          child: MainScreen(
            initialDashboardMarker: getDashboardMarker(initialMarker),
          ),
        );
      },
      '/:mainId/message/:chatId': (context, state, data) {
        final chatId = state.pathParameters['chatId']; 
        final initialMarker = state.pathParameters['mainId'];

        RoomsHelperCore.selectedRoomId = chatId;

        return BeamPage(
          key: ValueKey('chat-$chatId'),
          name: 'chat-message',
          title: 'messenger',
          child: MainScreen(
            initialDashboardMarker: getDashboardMarker(initialMarker),
          ),
        );

      },
      '/:mainId/create_my_activity': (context, state, data) {
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
        // ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);

          return BeamPage(
            key: ValueKey('search'),
            name: 'search',
            title: 'search',
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
        ExploreWebHelperCore.searchExploreMarker = getSearchExploreMarker(searchType);
        ExploreWebHelperCore.selectedReservationItem = null;
        ExploreWebHelperCore.currentReservationItemId = null;

        return BeamPage(
          key: const ValueKey('listing'),
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
        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.activity;

        return BeamPage(
          key: ValueKey('reservation_preview'),
          name: 'activity_preview',
          title: 'a circle activity',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
      '/:mainId/:searchType/browse': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['search`Type'];

        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;
        return BeamPage(
          key: ValueKey('search_discovery'),
          name: 'search_discovery',
          title: 'Discovery Feed',
          child: MainScreen(
              initialDashboardMarker: getDashboardMarker(mainId)
          ),
        );
      },
      '/:mainId/:searchType/browse/:browseExploreType/explore': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['search`Type'];
        final exploreType = state.pathParameters['browseExploreType'];

        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;
        ExploreFilterObject initialExploreFilter = ExploreFilterObject.empty();
        initialExploreFilter = initialExploreFilter.copyWith(
          filterByExploreType: ExploreContainerType.browse,
          filterByExplorBrowseType: getExploreTypeFromString(exploreType),
        );

        return BeamPage(
            key: ValueKey('search_discovery_by_explore_type'),
            name: 'search_discovery_by_explore_type',
            title: 'Exploring $exploreType',
            child: MainScreen(
                initialDashboardMarker: getDashboardMarker(mainId),
                initialExploreFilterObject: initialExploreFilter,
            ),
          );  
      },
      '/:mainId/:searchType/profile/:profileId/:profileType/:profileName': (context, state, data) {
        final mainId = state.pathParameters['mainId'];
        final searchType = state.pathParameters['search`Type'];
        final profileId = state.pathParameters['profileId'];
        final profileType = state.pathParameters['profileType'];
        final profileName = state.pathParameters['profileName'];

        ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;

        ExploreFilterObject initialExploreFilter = ExploreFilterObject.empty();
        initialExploreFilter = initialExploreFilter.copyWith(
          filterByExploreType: ExploreContainerType.userProfile,
          userProfileId: profileId,
          searchQuery: profileName,
          profileType: getProfileTypeMarkerFromString(profileType),
        );

        // ExploreSearchQueryObject initialExploreSearchQuery = ExploreSearchQueryObject(
        //   exploreType: ExploreContainerType.userProfile,
        //   userProfileType: getProfileTypeMarkerFromString(profileType),
        //   profileId: (profileId != null) ? UniqueId.fromUniqueString(profileId) : null,
        // );
        
        return BeamPage(
            key: ValueKey('view_user_profile'),
            name: 'view_profile_$profileName',
            title: 'ACIRCLE - $profileName',
            child: MainScreen(
                initialDashboardMarker: getDashboardMarker(mainId),
                initialExploreFilterObject: initialExploreFilter,
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
      '/:mainId/:reservationId/vendor_forms/:vendorFormId': (context, state, data) {
        final initialMarker = state.pathParameters['mainId'];
        final reservationId = state.pathParameters['reservationId'];
        final vendorFormId = state.pathParameters['vendorFormId'];
        // ReservationHelperCore.selectedReservationId = (reservationId != null) ? UniqueId.fromUniqueString(reservationId) : null;
        ActivityVendorHelperCore.selectedFormId = vendorFormId;
        
        return BeamPage(
          key: ValueKey('selected_reservation_vendor_form'),
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

