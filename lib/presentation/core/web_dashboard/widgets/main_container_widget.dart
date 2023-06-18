import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';

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

  final ScrollController _sidePanelScrollController = ScrollController();

  @override
  void dispose() {
    _sidePanelScrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [

        widget.mainContainer,

        AnimatedContainer(
            width: (widget.presentSidePanelContainer) ? 350 : 0,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
            child: Container(
              decoration: BoxDecoration(
                color: widget.model.webBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: widget.model.disabledTextColor.withOpacity(0.35),
                        spreadRadius: 5,
                        blurRadius: 13,
                        offset: const Offset(5,0)
                    )
                  ]
              ),
              width: 350,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                controller: _sidePanelScrollController,
                child: widget.sidePanelContainer,
              ),
          ),
        ),

      ],
    );
  }
}