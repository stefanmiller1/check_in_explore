import 'package:flutter/material.dart';

enum DashboardMarker {home, reservations, chat, profile, settings, resProfile, resAttendees, resSettings}

class DashboardContainerModel {

  final DashboardMainContainerModel mainContainer;
  final Widget subContainer;
  final DashboardMarker dashboardMarker;
  final IconData iconTab;
  final String tabTitle;
  late bool? isHovering;
  late String? imageUrl;
  late bool? isVisible;

  DashboardContainerModel({
      required this.mainContainer,
      required this.subContainer,
      required this.dashboardMarker,
      required this.iconTab,
      required this.tabTitle,
      this.isHovering,
      this.imageUrl,
      this.isVisible
  });

}


class DashboardMainContainerModel {

  final Widget mainContainer;
  final Widget sidePanelMainContainer;
  final bool isSubContainerAllowed;
  final bool presentSidePanel;

  DashboardMainContainerModel({
      required this.mainContainer,
      required this.sidePanelMainContainer,
      required this.isSubContainerAllowed,
      required this.presentSidePanel});

  DashboardMainContainerModel empty() => DashboardMainContainerModel(mainContainer: Container(), sidePanelMainContainer: Container(), isSubContainerAllowed: false, presentSidePanel: false);
}