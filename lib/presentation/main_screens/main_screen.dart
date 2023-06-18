import 'dart:async';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/responsive/responsive.dart';
import '../mobile_screens/main_mobile_screen.dart';
import '../tablet_screens/main_tablet_screen.dart';
import '../web_screens/main_web_screen.dart';


class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late DashboardModel dashboardModel;

  @override
  void initState() {

    dashboardModel = DashboardModel.instance;
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
          listenWhen: (p,c) => p.selectedListingId != c.selectedListingId || p.isMarkersLoading != c.isMarkersLoading,
          listener: (context, state) {

;          },
          buildWhen: (p,c) =>
              p.selectedListingId != c.selectedListingId ||
              p.isMarkersLoading != c.isMarkersLoading ||
              p.locationItemId != c.locationItemId ||
              p.locationCityFromMap != c.locationCityFromMap ||
              p.markers.length != c.markers.length ||
              p.listings.length != c.listings.length ||
              p.selectedReservationsSlots?.length != c.selectedReservationsSlots?.length ||
              p.searchType != c.searchType,
          builder: (context, state) {
            return retrieveMainResponsiveScreen(model: model);
          }
        ),
      )
    );
  }

  Widget retrieveMainResponsiveScreen({required DashboardModel model}) {
    if (kIsWeb) {
      return MainWebScreen(model: model);
    }
    return MainMobileScreen(model: model);

  }
}
