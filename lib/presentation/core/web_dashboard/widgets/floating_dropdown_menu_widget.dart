import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'tab_floating_dropdown_helper.dart';
import 'package:hovering/hovering.dart';

class FloatingDropdownMenu extends StatefulWidget {
  final bool isExpanded;
  final DashboardModel model;
  final FloatingDropdownModel dropdownModel;
  final VoidCallback? onClosed;
  final ValueChanged<bool>? onHoverChanged;
  final Function()? onPressed;

  const FloatingDropdownMenu({
    super.key,
    required this.isExpanded,
    required this.model,
    required this.dropdownModel,
    this.onClosed,
    this.onHoverChanged,
    this.onPressed,
  });

  @override
  State<FloatingDropdownMenu> createState() => _FloatingDropdownMenuState();
}

class _FloatingDropdownMenuState extends State<FloatingDropdownMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeOpacity;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOut,
    );
    _fadeOpacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: (widget.isExpanded) ? Offset(-0.5, 0) : Offset(-1.5, 0),  // start further off-screen left for opposite direction
      end: Offset.zero
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInOut,
      ),
    );
    if (widget.isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant FloatingDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !_controller.isAnimating) {
      _controller.forward();
    } else if (!widget.isExpanded && !_controller.isAnimating && _controller.status != AnimationStatus.dismissed) {
      _controller.reverse().then((_) {
        if (mounted) widget.onClosed?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildDropdownContent() {
    final iconWidget = widget.dropdownModel.icon != null
        ? (widget.dropdownModel.tabMarker == FloatingDropdownTabMarker.hint
            ? Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.model.accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(widget.dropdownModel.icon, color: widget.model.paletteColor),
              )
            : null)
        : null;

    switch (widget.dropdownModel.tabMarker) {
      case FloatingDropdownTabMarker.hint:
        return [
          if (iconWidget != null) iconWidget,
          ...(widget.dropdownModel.hintText ?? []).asMap().entries.map((entry) {
          final idx = entry.key;
          final text = entry.value;
          return SlideInTransitionWidget(
            durationTime: 250 * idx,           // stagger by index
            offset: const Offset(0, 0.25),      // small vertical slide
            transitionWidget: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: widget.model.accentColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
              ),
              child: Text(text, style: TextStyle(color: widget.model.paletteColor)),
            ),
          );
        }).toList(),
        ];
      case FloatingDropdownTabMarker.preview:
        return [
          if (iconWidget != null) iconWidget,
          if (widget.dropdownModel.mainWidget != null)
            widget.dropdownModel.mainWidget!,
        ];
      case FloatingDropdownTabMarker.getStarted:
        return [
          if (iconWidget != null) iconWidget,
          if (widget.dropdownModel.mainWidget != null)
          Container(
            decoration: BoxDecoration(
                color: widget.model.accentColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
              ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: widget.dropdownModel.mainWidget!,
            )
          ),
          const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: HoverButton(
                onpressed: () {
                  widget.onPressed?.call();
                },
                animationDuration: Duration.zero,
                color: widget.model.paletteColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Get Started', textAlign: TextAlign.center, style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                )
              ),
            )
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHoverChanged?.call(true),
      onExit: (_) => widget.onHoverChanged?.call(false),
      child: FadeTransition(
        opacity: _fadeOpacity,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _fadeAnimation,
            alignment: Alignment.topCenter,
            child: Container(
              // constraints: const BoxConstraints(minWidth: 160),
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildDropdownContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}