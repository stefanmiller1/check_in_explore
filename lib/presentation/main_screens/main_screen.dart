import 'dart:async';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/material.dart';
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


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(create: (_) => getIt<ListingsSearchRequirementsBloc>(),
        child: BlocConsumer<ListingsSearchRequirementsBloc, ListingsSearchRequirementsState>(
          listenWhen: (p,c) => p.selectedListingId != c.selectedListingId ,
          listener: (context, state) {
            setState(() {
              MapHelper.updateMarkers(context, null, null, markerTap: (marker) {
                setState(() {

                  if (marker.childMarkerId != null) {
                    MapHelper.selectedMarkerId = UniqueId.fromUniqueString(marker.childMarkerId!);
                    context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedListingIdChanged(UniqueId.fromUniqueString(marker.childMarkerId!)));

                    // final int index = context.read<ListingsSearchRequirementsBloc>().state.markers.toList().indexWhere((element) => element.markerId.value == cluster.markerId);
                    // final int index = state.markers.toList().map((e) => e.markerId).toList().indexWhere((element) => element.value == state.selectedListingId?.getOrCrash());
                    // SearchHelper.controller.animateToPage(index, duration: const Duration(milliseconds: 650), curve: Curves.easeInOut);

                  } else {
                    MapHelper.selectedMarkerId = null;
                    context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
                  }
                });
              });
            });
          },
          buildWhen: (p,c) => p.selectedListingId != c.selectedListingId || p.isMarkersLoading != c.isMarkersLoading || p.markers != c.markers,
          builder: (context, state) {
            return getMain(context);
          }
        ),
      )
    );
  }

  Widget getMain(BuildContext context) {
   return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsStarted(context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap ?? 'Markham')),
          child: retrieveMainResponsiveScreen(),
      );
  }

  Widget retrieveMainResponsiveScreen() {
    return const Responsive(
      mobile: MainMobileScreen(),
      tablet: MainTabletScreen(),
      desktop: MainDesktopScreen(),
    );
  }
}
