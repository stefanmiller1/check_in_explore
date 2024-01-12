import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/widgets/menu_marker_item.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  void initState() {
    selectedMarker = widget.currentMarker;
    sideScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    sideScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedMarker != widget.currentMarker) {
      selectedMarker = widget.currentMarker;
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 80,
      padding: EdgeInsets.only(),
      color: widget.model.accentColor,
      child: Stack(
        children: [

          Container(
            width: 80,
            height: MediaQuery.of(context).size.height,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 80),
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: 80,
              child: ListView(
                children: widget.sideMarkerItems.where((element) => element.isVisible == true).toList().asMap().map((i, e) => MapEntry(i, MouseRegion(
                    onEnter: (g) {
                        setState(() {
                          e.isHovering = true;
                        });
                    },
                    onExit: (f) {
                        setState(() {
                          e.isHovering = false;
                        });
                    },
                    child: MenuMarkerItem(
                          isActive: (selectedMarker == e.dashboardMarker),
                          isHover: e.isHovering,
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
                        ),
                      ),
                    ),
                  ).values.toList()
                )
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                width: 80,
                height: 80,
                color: widget.model.accentColor,
                child: MenuMarkerItem(
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
              ),
            )
        ],
      ),
    );
  }
}