import 'package:flutter/material.dart';

class MainMobileScreenModel {

  final bool isSelected;
  final IconData iconItem;
  final String mainTitle;
  final Widget mainWidgetItem;
  final AppBar? appBarWidgetItem;
  final int? notifications;

  MainMobileScreenModel({
  required this.iconItem,
  required this.mainTitle,
  required this.mainWidgetItem,
  required this.isSelected,
  required this.appBarWidgetItem,
  this.notifications,
  });

}

