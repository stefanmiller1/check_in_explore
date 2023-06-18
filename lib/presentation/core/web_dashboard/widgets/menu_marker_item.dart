import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuMarkerItem extends StatefulWidget {

  final DashboardModel model;
  final Function didPress;
  final int? itemCount;
  final bool? isActive, isHover, showBorder;
  final String title;
  final String? imageUrl;
  final IconData iconSrc;
  final bool isLast;

  const MenuMarkerItem({
    super.key,
    required this.model,
    required this.didPress,
    this.itemCount,
    this.isActive,
    this.isHover = false,
    this.showBorder = true,
    required this.title,
    required this.iconSrc,
    required this.isLast,
    this.imageUrl
  });

  @override
  State<MenuMarkerItem> createState() => _MenuMarkerItemState();
}

class _MenuMarkerItemState extends State<MenuMarkerItem> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.didPress();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 40,
              width: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  if (widget.imageUrl == null) Icon(
                    widget.iconSrc,
                    color: ((widget.isActive ?? false) || (widget.isHover ?? false)) ? widget.model.paletteColor : widget.model.disabledTextColor,
                  ),
                  if (widget.imageUrl != null) Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: (widget.isHover ?? false) ? Colors.transparent : widget.model.paletteColor, width: 1.5)
                    ),
                    child: CircleAvatar(
                      backgroundColor: widget.model.webBackgroundColor,
                      radius: 40,
                      backgroundImage: Image.asset('assets/profile-avatar.png').image,
                      foregroundImage: Image.network(widget.imageUrl!).image,
                    ),
                  ),

                  if (widget.itemCount != null && widget.itemCount != 0) Positioned(
                      top: 0,
                      right: 0,
                      child: CounterBadge(count: widget.itemCount ?? 0, model: widget.model)
                  ),
                ],
              ),
            ),
            if (widget.isLast) const SizedBox(height: 42.5),
            if (widget.isLast) Divider(height: 0.5, color: widget.model.disabledTextColor)
          ],
        ),
      ),
    );
  }
}