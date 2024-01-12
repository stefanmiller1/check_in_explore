import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

class DashboardContainerModel {

  final DashboardMainContainerModel mainContainer;
  final Widget subContainer;
  final DashboardMarker dashboardMarker;
  final IconData iconTab;
  final String tabTitle;
  late bool? isHovering;
  late List<String>? imageUrl;
  late bool? isVisible;
  late bool? isPrivate;
  late bool? isLive;

  DashboardContainerModel({
      required this.mainContainer,
      required this.subContainer,
      required this.dashboardMarker,
      required this.iconTab,
      required this.tabTitle,
      this.isHovering,
      this.imageUrl,
      this.isVisible,
      this.isPrivate,
      this.isLive
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