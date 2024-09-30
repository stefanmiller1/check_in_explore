import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainDashboardContainer extends StatefulWidget {

  final DashboardModel model;
  final bool presentSidePanelContainer;
  final Widget sidePanelContainer;
  final Widget mainContainer;

  const MainDashboardContainer({super.key, required this.model, required this.presentSidePanelContainer, required this.sidePanelContainer, required this.mainContainer});

  @override
  State<MainDashboardContainer> createState() => _MainDashboardContainerState();
}

class _MainDashboardContainerState extends State<MainDashboardContainer> {

  // final ScrollController _sidePanelScrollController = ScrollController();

  @override
  void dispose() {
    // _sidePanelScrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Stack(
      alignment: Alignment.centerRight,
      children: [
        if (Responsive.isMobile(context)) widget.mainContainer,
        if (!Responsive.isMobile(context)) Padding(
          padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: widget.model.accentColor,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: widget.mainContainer,
            ),
          ),
        ),
        // Positioned(
        //   top: 120,
        //   child: AnimatedContainer(
        //       width: (widget.presentSidePanelContainer) ? 350 : 0,
        //       duration: const Duration(milliseconds: 650),
        //       curve: Curves.easeInOut,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: Colors.transparent,
        //             borderRadius: BorderRadius.circular(25),
        //           ),
        //           width: 350,
        //           height: MediaQuery.of(context).size.height - 120,
        //           child: widget.sidePanelContainer,
        //     ),
        //    ),
        //   ),
        // ),

      ],
    );
  }
}