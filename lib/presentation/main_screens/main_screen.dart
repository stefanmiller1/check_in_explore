import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_attendees/activity_attendees_list_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../mobile_screens/main_mobile_screen.dart';
import '../web_screens/main_web_screen.dart';
import 'package:check_in_facade/auth/notification_facade/notification_core_config.dart';


class MainScreen extends StatefulWidget {

  final DashboardMarker initialDashboardMarker;
  final UniqueId? initialReservationId;

  const MainScreen({super.key, required this.initialDashboardMarker, this.initialReservationId});

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
    if (kIsWeb) {
      return MainWebScreen(
          model: model,
          initialDashboardMarker: widget.initialDashboardMarker,
          initialReservationId: widget.initialReservationId,
      );
    }
    return MainMobileScreen(model: model);
  }
}
