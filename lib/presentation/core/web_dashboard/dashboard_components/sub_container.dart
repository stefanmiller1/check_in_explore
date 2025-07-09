import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_components/side_panel_container.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubContainer extends StatefulWidget {

  final DashboardModel model;
  final Widget subWidget;
  final DashboardMarker currentMarker;
  final List<DashboardContainerModel> menuMarkerItems;
  final DashboardContainerModel optionsMarkerItem;
  final Function(DashboardMarker marker) didSelectMarker;

  const SubContainer({
    super.key,
    required this.model,
    required this.subWidget,
    required this.currentMarker,
    required this.menuMarkerItems,
    required this.didSelectMarker,
    required this.optionsMarkerItem
  });

  @override
  State<SubContainer> createState() => _SubContainerState();
}

class _SubContainerState extends State<SubContainer> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 60),
        child: SidePanelContainer(
          model: widget.model,
          sideMarkerItems: widget.menuMarkerItems,
          currentMarker: widget.currentMarker,
          didSelectMarker: (marker) {
            widget.didSelectMarker(marker);
          },
          optionsMarkerItem: widget.optionsMarkerItem,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: widget.model.accentColor.withOpacity(0.68),
          child: Row(
            children: [
              const SizedBox(width: 90),
              Flexible(child: widget.subWidget),
            ],
          )
        ),
      ),
    );
  }
}