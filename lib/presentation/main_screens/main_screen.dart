import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/explore_core_widgets/components/template_components/explore_search_shell.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../mobile_screens/main_mobile_screen.dart';
import '../web_screens/main_web_screen.dart';
import 'package:check_in_facade/check_in_facade.dart';

import 'main_screen_web_mobile.dart';


class MainScreen extends StatefulWidget {

  final DashboardMarker initialDashboardMarker;
  final bool? isCreatingNewActivity;
  final UniqueId? initialReservationId;
  final ExploreFilterObject? initialExploreFilterObject;

  const MainScreen({super.key, required this.initialDashboardMarker, this.initialReservationId, this.isCreatingNewActivity, this.initialExploreFilterObject});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late DashboardModel dashboardModel;

  @override
  void initState() {

    dashboardModel = DashboardModel.instance;

    /// foreground work to call local notification
    FirebaseMessaging.onMessage.listen((event) {
      print('new notification - ${event}');
      /// TODO: update current user with new notification
      /// TODO: on selecting notification - update notification status to isRead = true
      if (kIsWeb) {
        LocalNotificationCore.showFlutterNotificationWeb(
            context,
            dashboardModel.paletteColor,
            dashboardModel.accentColor,
            event,
          didSelectNotification: (link) {
            Beamer.of(context).update(
                configuration: RouteInformation(
                    location: link,
                    // '/${DashboardMarker.reservations.toString()}/reservation/${ReservationHelperCore.selectedReservationItem?.reservationId.getOrCrash().toString()}'
                ),
              rebuild: true
            );
          }
        );
      } else {
        LocalNotificationCore.showFlutterNotificationMobile(event);
      }
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    dashboardModel.systemTheme = Theme.of(context);
    dashboardModel.currentThemeData = dashboardModel.systemTheme.brightness != Brightness.dark
        ? ThemeData.light() : ThemeData.dark();
    dashboardModel.changeTheme(dashboardModel.currentThemeData!);

    final DashboardModel model = dashboardModel;

    return Scaffold(
      body: BlocProvider(create: (_) => getIt<ListingsSearchRequirementsBloc>(),
        child: BlocConsumer<ListingsSearchRequirementsBloc, ListingsSearchRequirementsState>(
          listenWhen: (p,c) => p.selectedListingId != c.selectedListingId || p.isMarkersLoading != c.isMarkersLoading || p.currentDashboardMarker != c.currentDashboardMarker,
          listener: (context, state) {
            setState(() {

              // reset attendee item for attendee list in [ActivityAttendeeHelperCore]
              ActivityAttendeeHelperCore.selectedAttendeeItem = null;
              ActivityAttendeeHelperCore.selectedUserProfileItem = null;

            });
;          },
          buildWhen: (p,c) =>
              p.selectedListingId != c.selectedListingId ||
              p.isMarkersLoading != c.isMarkersLoading ||
              p.locationItemId != c.locationItemId ||
              p.locationCityFromMap != c.locationCityFromMap ||
              p.markers.length != c.markers.length ||
              p.listings.length != c.listings.length ||
              p.selectedReservationsSlots?.length != c.selectedReservationsSlots?.length ||
              p.currentDashboardMarker != c.currentDashboardMarker,
              // p.searchType != c.searchType,
          builder: (context, state) {
            return Theme(
              data: dashboardModel.systemTheme.copyWith(
                  colorScheme: dashboardModel.systemTheme.colorScheme.copyWith(
                    surfaceVariant: Colors.transparent
                  )
                ),
              child: retrieveMainResponsiveScreen(model: model));
          }
        ),
      )
    );
  }

  Widget retrieveMainResponsiveScreen({required DashboardModel model}) {

    // if (isWebMobile) {
    //   return MainScreenWebMobile(
    //     model: model
    //   );
    // } else

      if (kIsWeb) {
      return MainWebScreen(
        model: model,
        initialDashboardMarker: widget.initialDashboardMarker,
        initialReservationId: widget.initialReservationId,
        isCreatingNewActivity: widget.isCreatingNewActivity,
        initialExploreFilterObject: widget.initialExploreFilterObject,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return MainMobileScreen(model: model);
    }

    return Container();

  }
}
