import 'dart:async';
import 'dart:math';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/widgets/menu_marker_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/tab_floating_dropdown_helper.dart';


class SidePanelContainer extends StatefulWidget {

  final DashboardModel model;
  final DashboardMarker currentMarker;
  final List<DashboardContainerModel> sideMarkerItems;
  final DashboardContainerModel optionsMarkerItem;
  final Function(DashboardMarker selectedTab) didSelectMarker;

  const SidePanelContainer({super.key, required this.model, required this.currentMarker, required this.sideMarkerItems, required this.didSelectMarker, required this.optionsMarkerItem});

  @override
  State<SidePanelContainer> createState() => _SidePanelContainerState();
}

class _SidePanelContainerState extends State<SidePanelContainer> {
  late ScrollController? sideScrollController;
  late DashboardMarker? selectedMarker;
  final Map<DashboardContainerModel, Timer> _hoverExitTimers = {};
  final Map<DashboardContainerModel, Timer> _hoverConfirmTimers = {};
  final Map<DashboardContainerModel, Timer> _dropdownHoverConfirmTimers = {};

  Timer? _hintTimer;
  Timer? _hintClearTimer;
  bool _isHintTimerRunning = false;

  // Panel drag state
  double _panelOffset = -60.0;

  @override
  void initState() {
    selectedMarker = widget.currentMarker;
    sideScrollController = ScrollController();
    super.initState();
    _startHintTimer();
  }

  @override
  void dispose() {
    _isHintTimerRunning = false;
    _cancelHintTimers();
    for (final timer in _hoverExitTimers.values) {
      timer.cancel();
    }
    for (final timer in _hoverConfirmTimers.values) {
      timer.cancel();
    }
    for (final timer in _dropdownHoverConfirmTimers.values) {
      timer.cancel();
    }
    sideScrollController?.dispose();
    super.dispose();
  }

  double get _listHeight {
    // Calculate height for visible marker items
    final count = widget.sideMarkerItems.where((e) => e.isVisible == true).length;
    const itemHeight = 80.0;
    final additionalHeight = Responsive.isMobile(context) ? 20 : 95.0; // additional items for web view
    // approximate height per item
    // include vertical padding (8 + 8)
    return 190 + (count * itemHeight) + additionalHeight;
  }

  void _startHintTimer() {
    setState(() => _isHintTimerRunning = true);
    _hintTimer?.cancel();
    _hintClearTimer?.cancel();
    _hintTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      // only when no manual hover
      if (!widget.sideMarkerItems.any((item) => item.isDropdownExpanded == true)) {
        final items = widget.sideMarkerItems.where((e) => e.isVisible == true && e.tabDropdownModel != null).toList();
        if (items.isEmpty) return;
        final target = items[Random().nextInt(items.length)];
        setState(() {
          // clear all hovers then hint one
          for (var item in items) {
            item.isDropdownExpanded = false;
            item.isHovering = false;
          }
          target.isDropdownExpanded = true;
        });
        // reverse after 5s
        _hintClearTimer = Timer(const Duration(seconds: 5), () {
          if (!mounted) return;
          setState(() {
            target.isDropdownExpanded = false;
          });
          // restart idle hint
          _startHintTimer();
        });
      } else {
        // retry after another interval
        _startHintTimer();
      }
    });
  }

  void _cancelHintTimers() {
    _isHintTimerRunning = false;
    _hintTimer?.cancel();
    _hintClearTimer?.cancel();
    for (var item in widget.sideMarkerItems) {
      item.isHovering = false;
      item.isDropdownExpanded = false;
    }
  }

  Widget buildPanel() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              height: _listHeight,
              width: 82,
              decoration: BoxDecoration(
                color: widget.model.accentColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset(
                        'assets/logo_icon/CIRCLE_LOGO_LIGHT.png',
                        width: 55,
                        height: 55,
                      ),
                    ),
                  ),
                  ...widget.sideMarkerItems.where((element) => element.isVisible == true).toList().asMap().map(
                    (i, e) {
                      return MapEntry(i, FocusableActionDetector(
                        onShowHoverHighlight: (hovering) {
                          if (hovering) {
                            _cancelHintTimers();
                            _hoverExitTimers[e]?.cancel();
                            _hoverConfirmTimers[e]?.cancel();
                            _hoverConfirmTimers[e] = Timer(const Duration(seconds: 1), () {
                              if (!mounted) return;
                              if (e.isHovering == true) {
                                setState(() { e.isHovering = true; });
                              }
                            });
                            setState(() {
                              for (final item in widget.sideMarkerItems) {
                                item.isHovering = false;
                                item.isDropdownExpanded = false;
                              }
                              e.isHovering = true;
                              e.isDropdownExpanded = true;
                            });
                          } else {
                            _hoverExitTimers[e]?.cancel();
                            _hoverConfirmTimers[e]?.cancel();
                            _hoverExitTimers[e] = Timer(const Duration(milliseconds: 150), () {
                              if (!mounted) return;
                              setState(() {
                                e.isHovering = false;
                                e.isDropdownExpanded = false;
                              });
                            });
                          }
                        },
                        child: MenuMarkerItem(
                          isActive: (selectedMarker == e.dashboardMarker),
                          isHover: e.isHovering,
                          isDropdownExpanded: e.isDropdownExpanded,
                          onDropdownHoverChanged: (hovering) {
                            _cancelHintTimers();
                            _hoverExitTimers[e]?.cancel();
                            _dropdownHoverConfirmTimers[e]?.cancel();
                            if (hovering) {
                              setState(() {
                                e.isDropdownExpanded = true;
                              });
                              _dropdownHoverConfirmTimers[e] = Timer(const Duration(seconds: 1), () {
                                if (!mounted) return;
                                if (e.isDropdownExpanded == true) {
                                  setState(() {
                                    e.isDropdownExpanded = true;
                                  });
                                }
                              });
                            } else {
                              _dropdownHoverConfirmTimers[e]?.cancel();
                              setState(() {
                                e.isDropdownExpanded = false;
                                e.isHovering = false;
                              });
                            }
                          },
                          isPrivate: e.isPrivate,
                          model: widget.model,
                          didPress: () {
                            setState(() {
                              selectedMarker = e.dashboardMarker;
                            });
                            widget.didSelectMarker(e.dashboardMarker);
                          },
                          iconSrc: e.iconTab,
                          imageUrl: e.imageUrl,
                          title: e.tabTitle,
                          isLive: e.isLive,
                          isLast: e.dashboardMarker == DashboardMarker.profile,
                          notifications: e.notificationCount,
                          floatingDropdownItem: (_isHintTimerRunning && e.isHovering == false) ? FloatingDropdownModel(
                            tabMarker: FloatingDropdownTabMarker.hint,
                            hintText: e.tabDropdownModel?.hintText,
                            icon: e.tabDropdownModel?.icon,
                            mainWidget: e.tabDropdownModel?.mainWidget,
                          ) : e.tabDropdownModel,
                        ),
                      ));
                    }
                  ).values,
                  MenuMarkerItem(
                    isActive: (selectedMarker == widget.optionsMarkerItem.dashboardMarker),
                    isHover: widget.optionsMarkerItem.isHovering,
                    model: widget.model,
                    didPress: () {
                      setState(() {
                        selectedMarker = widget.optionsMarkerItem.dashboardMarker;
                      });
                      widget.didSelectMarker(widget.optionsMarkerItem.dashboardMarker);
                    },
                    iconSrc: widget.optionsMarkerItem.iconTab,
                    title: widget.optionsMarkerItem.tabTitle,
                    isLive: widget.optionsMarkerItem.isLive,
                    isLast: false,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.model.paletteColor,
                      ),
                      child: Center(
                        child: IconButton(
                          tooltip: 'Create',
                          icon: const Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            didSelectCreateNewActivity(
                              context,
                              widget.model,
                              null,
                              null,
                              didSaveActivity: (res) {},
                              didPublishActivity: (res) {},
                            );
                          },
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedMarker != widget.currentMarker) {
      selectedMarker = widget.currentMarker;
    }

    if (!Responsive.isMobile(context)) {
      return buildPanel();
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          // Both panel and arrow move together
          Transform.translate(
            offset: Offset(_panelOffset, 0),
            child: Row(
              children: [
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _panelOffset += details.delta.dx;
                      _panelOffset = _panelOffset.clamp(-82.0, 0.0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    final velocity = details.velocity.pixelsPerSecond.dx;
                    setState(() {
                      if (velocity < -300 || _panelOffset < -40) {
                        _panelOffset = -82.0;
                      } else if (velocity > 300 || _panelOffset >= -40) {
                        _panelOffset = 0.0;
                      }
                    });
                  },
                  child: buildPanel(),
                ),
                // Arrow handle (moves with panel)
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _panelOffset += details.delta.dx;
                      _panelOffset = _panelOffset.clamp(-82.0, 0.0);
                    });
                  },  
                  onHorizontalDragEnd: (details) {
                    final velocity = details.velocity.pixelsPerSecond.dx;
                    setState(() {
                      if (velocity < -300 || _panelOffset < -40) {
                        _panelOffset = -82.0;
                      } else if (velocity > 300 || _panelOffset >= -40) {
                        _panelOffset = 0.0;
                      }
                    });
                  },
                  onTap: () {
                    setState(() {
                      _panelOffset = (_panelOffset == 0.0) ? -82.0 : 0.0;
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.model.paletteColor,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                    child: Icon(
                      _panelOffset == 0.0 ? CupertinoIcons.left_chevron : CupertinoIcons.right_chevron,
                      size: 32,
                      color: widget.model.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}