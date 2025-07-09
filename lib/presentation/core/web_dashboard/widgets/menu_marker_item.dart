import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/widgets/floating_dropdown_menu_widget.dart';

import 'tab_floating_dropdown_helper.dart';

class MenuMarkerItem extends StatefulWidget {

  final DashboardModel model;
  final Function didPress;
  final bool? isDropdownExpanded;
  final ValueChanged<bool>? onDropdownHoverChanged;
  final int? itemCount;
  final bool? isActive, isHover, showBorder, isPrivate;
  final String title;
  final List<String>? imageUrl;
  final IconData iconSrc;
  final bool isLast;
  final bool? isLive;
  final int? notifications;
  final FloatingDropdownModel? floatingDropdownItem;

  const MenuMarkerItem({
    super.key,
    required this.model,
    required this.didPress,
    this.itemCount,
    this.isActive,
    this.isPrivate,
    this.isHover = false,
    this.showBorder = true,
    required this.title,
    required this.iconSrc,
    required this.isLast,
    this.imageUrl,
    this.isLive,
    this.notifications,
    this.isDropdownExpanded,
    this.onDropdownHoverChanged,
    this.floatingDropdownItem
  });

  @override
  State<MenuMarkerItem> createState() => _MenuMarkerItemState();
}

class _MenuMarkerItemState extends State<MenuMarkerItem> {
  OverlayEntry? _dropdownOverlayEntry;
  final GlobalKey _markerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Overlay logic for dropdown
    if (widget.floatingDropdownItem != null && Responsive.isMobile(context) == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isDropdownExpanded == true && _dropdownOverlayEntry == null) {
          final renderBox = _markerKey.currentContext?.findRenderObject() as RenderBox?;
          final offset = renderBox?.localToGlobal(Offset.zero);
          if (offset != null) {
            _dropdownOverlayEntry = OverlayEntry(
              builder: (context) => Positioned(
                left: offset.dx + 92,
                top: offset.dy,
                child: Material(
                  color: Colors.transparent,
                  child: FloatingDropdownMenu(
                    isExpanded: widget.isDropdownExpanded ?? false,
                    model: widget.model,
                    dropdownModel: widget.floatingDropdownItem!,
                    onClosed: () {
                      _dropdownOverlayEntry?.remove();
                      _dropdownOverlayEntry = null;
                    },
                    onHoverChanged: widget.onDropdownHoverChanged,
                    onPressed: () {
                      widget.didPress();
                    }
                  ),
                ),
              ),
            );
            if (_dropdownOverlayEntry != null) Overlay.of(context).insert(_dropdownOverlayEntry!);
          }
        } else if (widget.isDropdownExpanded == false && _dropdownOverlayEntry != null) {
          // Trigger reverse animation
          _dropdownOverlayEntry?.markNeedsBuild();
        }
      });
    }

    return Container(
      key: _markerKey,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.didPress();
          });
        },
        child: Padding(
          padding: (widget.isPrivate == true) ? EdgeInsets.zero : const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (widget.isLive == true) Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  widget.iconSrc,
                  color: Colors.red,
                  semanticLabel: widget.title,
                ),
              ),
              badges.Badge(
                showBadge: widget.notifications != null && widget.notifications != 0,
                badgeContent: widget.notifications != 0 ? Text(widget.notifications.toString(), style: TextStyle(color: widget.model.accentColor)) : null,
                badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
                child: Container(
                  height: (widget.isPrivate == true) ? 80 : (widget.isLive == true) ? 60 : 40,
                  width: 80,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (widget.imageUrl == null || widget.imageUrl?.isEmpty == true) Icon(
                        widget.iconSrc,
                        semanticLabel: widget.title,
                        color: ((widget.isActive ?? false) || (widget.isHover ?? false))
                            ? widget.model.paletteColor
                            : widget.model.disabledTextColor,
                      ),
                      if (widget.imageUrl != null && widget.imageUrl?.length == 1 && widget.imageUrl?.isNotEmpty == true) Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: (widget.isActive ?? false) || (widget.isHover ?? false) ? widget.model.paletteColor : Colors.transparent, width: 1.5)
                        ),
                        child: CircleAvatar(
                          backgroundColor: widget.model.webBackgroundColor,
                          radius: 40,
                          backgroundImage: Image.asset('assets/profile-avatar.png').image,
                          foregroundImage: (widget.imageUrl?[0] != '') ? Image.network(widget.imageUrl?[0] ?? '').image : null,
                        ),
                      ),
                      if (widget.imageUrl != null && (widget.imageUrl?.length ?? 0) > 1) Stack(
                        children: [
                          if ((widget.imageUrl?.length ?? 0) >= 3) Positioned(
                            top: 24,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: widget.model.paletteColor, width: 0.75),
                              ),
                              child: CircleAvatar(
                                backgroundColor: widget.model.webBackgroundColor,
                                radius: 40,
                                backgroundImage: Image.asset('assets/profile-avatar.png').image,
                                foregroundImage: (widget.imageUrl?[2] != '') ? Image.network(widget.imageUrl?[2] ?? '').image : null,
                              ),
                            ),
                          ),
                          if ((widget.imageUrl?.length ?? 0) >= 2) Positioned(
                            top: 12,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    if ((widget.imageUrl?.length ?? 0) >= 3) BoxShadow(
                                        color: Colors.black.withOpacity(0.11),
                                        spreadRadius: 1,
                                        blurRadius: 15,
                                        offset: Offset(0, 2)
                                    )
                                  ],
                                border: Border.all(color: widget.model.paletteColor, width: 0.75),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: CircleAvatar(
                                backgroundColor: widget.model.webBackgroundColor,
                                radius: 40,
                                backgroundImage: Image.asset('assets/profile-avatar.png').image,
                                foregroundImage: (widget.imageUrl?[1] != '') ? Image.network(widget.imageUrl?[1] ?? '').image : null,
                              ),
                            ),
                          ),
                          if ((widget.imageUrl?.length ?? 0) > 1) Positioned(
                              top: 0,
                              child: Column(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.23),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0, 2)
                                        )
                                      ],
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: (widget.isActive ?? false) || (widget.isHover ?? false) ? widget.model.paletteColor : Colors.transparent, width: 1.5)
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: widget.model.webBackgroundColor,
                                      radius: 40,
                                      backgroundImage: Image.asset('assets/profile-avatar.png').image,
                                      foregroundImage: (widget.imageUrl?[0] != '') ? Image.network(widget.imageUrl?[0] ?? '').image : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.itemCount != null && widget.itemCount != 0) Positioned(
                          top: 0,
                          right: 0,
                          child: CounterBadge(count: widget.itemCount ?? 0, model: widget.model)
                      ),
                      if (widget.isPrivate == true) Positioned(
                        top: 0,
                        child: Icon(Icons.lock_outline, color: widget.model.paletteColor),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.isLast || widget.isLive == true) const SizedBox(height: 42.5),
              if (widget.isLast || widget.isLive == true) Divider(height: 0.5, color: widget.model.disabledTextColor)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dropdownOverlayEntry?.remove();
    super.dispose();
  }
}