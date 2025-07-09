import 'package:flutter/widgets.dart';

/// Defines the state of a floating dropdown.
enum FloatingDropdownTabMarker {
  hint,
  preview,
  getStarted,
}

/// Model for configuring a FloatingDropdownMenu.
class FloatingDropdownModel {
  /// The icon to display at the top of the menu.
  final IconData? icon;

  /// Hint text lines to show when in `hint` state.
  final List<String>? hintText;

  /// The main widget to show when in `preview` or `getStarted` state.
  final Widget? mainWidget;

  /// Which state/tab the dropdown is showing.
  final FloatingDropdownTabMarker tabMarker;

  const FloatingDropdownModel({
    this.icon,
    this.hintText,
    this.mainWidget,
    required this.tabMarker,
  });
}
