import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/widgets/main_container_widget.dart';
import 'package:flutter/material.dart';

class MainMenuContainer extends StatefulWidget {

  final DashboardModel model;
  final Widget mainContainer;
  final Widget sidePanelMainContainer;
  final Widget subContainer;
  final bool presentSideContainer;
  final bool showDrawer;

  const MainMenuContainer({super.key, required this.model, required this.mainContainer, required this.sidePanelMainContainer, required this.presentSideContainer, required this.showDrawer, required this.subContainer});

  @override
  State<MainMenuContainer> createState() => _MainMenuContainerState();
}

class _MainMenuContainerState extends State<MainMenuContainer> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    if (!(widget.showDrawer)) _scaffoldKey.currentState?.closeDrawer();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: (widget.showDrawer) ? 350 : 0,
        child: Drawer(
          elevation: 0,
          backgroundColor: widget.model.webBackgroundColor,
          child: widget.sidePanelMainContainer,
        ),
      ),
      body: Container(
        color: widget.model.webBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: MainDashboardContainer(
                  model: widget.model,
                  mainContainer: widget.mainContainer,
                  sidePanelContainer: widget.sidePanelMainContainer,
                  presentSidePanelContainer: widget.presentSideContainer,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}