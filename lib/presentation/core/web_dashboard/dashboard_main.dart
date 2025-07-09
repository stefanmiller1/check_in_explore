import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_components/main_menu_container.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_components/side_panel_container.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_components/sub_container.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../web_screens/main_web_screen_helper.dart';

class WebDashboardMain extends StatefulWidget {

  final DashboardModel model;
  final bool isLoggedIn;
  final DashboardMarker dashboardMarker;
  final Function(DashboardMarker tab) didSelectDashboardMarkerItem;
  final List<DashboardContainerModel> dashboardContainerItems;
  final DashboardContainerModel optionsMarkerItem;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WebDashboardMain({
    super.key,
    required this.model,
    required this.dashboardMarker,
    required this.didSelectDashboardMarkerItem,
    required this.dashboardContainerItems,
    required this.optionsMarkerItem,
    required this.scaffoldKey,
    required this.isLoggedIn,
  });

  @override
  State<WebDashboardMain> createState() => _WebDashboardMainState();
}


class _WebDashboardMainState extends State<WebDashboardMain> {

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DashboardContainerModel? currentDashboardContainer;
  DashboardMarker? currentMarker;


  Widget updateMainContainer(DashboardMarker dashboardMarker) {
    if (dashboardMarker == DashboardMarker.settings) {
      return widget.optionsMarkerItem.mainContainer.mainContainer;
    }
    if (widget.dashboardContainerItems.where((element) => element.dashboardMarker == dashboardMarker).isNotEmpty) {
    return widget.dashboardContainerItems.firstWhere((element) => element.dashboardMarker == dashboardMarker).mainContainer.mainContainer;
    } else {
      return Container();
    }
  }

  Widget? mainContainerSidePanel(DashboardMarker dashboardMarker) {
    if (widget.dashboardContainerItems.where((element) => element.dashboardMarker == dashboardMarker).isNotEmpty) {
      return widget.dashboardContainerItems.firstWhere((element) => element.dashboardMarker == dashboardMarker).mainContainer.sidePanelMainContainer;
    } else {
      return Container();
    }
  }

  Widget? updateSubContainer(DashboardMarker dashboardMarker) {
    if (dashboardMarker == DashboardMarker.settings) {
      return widget.optionsMarkerItem.subContainer;
    }
    if (widget.dashboardContainerItems.where((element) => element.dashboardMarker == dashboardMarker).isNotEmpty) {
      return widget.dashboardContainerItems.firstWhere((element) => element.dashboardMarker == dashboardMarker).subContainer;
    } else {
      return Container();
    }
  }

  bool subContainerIsHidden(DashboardMarker dashboardMarker) {
    if (dashboardMarker == DashboardMarker.settings) {
      return widget.optionsMarkerItem.mainContainer.isSubContainerAllowed;
    }
    if (widget.dashboardContainerItems.where((element) => element.dashboardMarker == dashboardMarker).isNotEmpty) {
      return widget.dashboardContainerItems.firstWhere((element) => element.dashboardMarker == dashboardMarker).mainContainer.isSubContainerAllowed;
    } else {
      return false;
    }
  }

  bool presentSidePanelContainer(DashboardMarker dashboardMarker) {
    if (widget.dashboardMarker == DashboardMarker.settings) {
      return widget.optionsMarkerItem.mainContainer.presentSidePanel;
    }
    if (widget.dashboardContainerItems.where((element) => element.dashboardMarker == dashboardMarker).isNotEmpty) {
      return widget.dashboardContainerItems.firstWhere((element) => element.dashboardMarker == dashboardMarker).mainContainer.presentSidePanel;
    } else {
      return false;
    }
  }

  bool isMainContainerFullBleeed(DashboardMarker dashboardMarker) {
    if (widget.dashboardContainerItems.where((element) => element.dashboardMarker == dashboardMarker).isNotEmpty) {
      return widget.dashboardContainerItems.firstWhere((element) => element.dashboardMarker == dashboardMarker).mainContainer.isFullBleed ?? false;
    } else {
      return false;
    }
  }

  int retrieveSelectedIndex(DashboardMarker currentMarker) {
    late int index = 0;
    index = widget.dashboardContainerItems.indexWhere((element) => element.dashboardMarker == currentMarker);

    if (index == -1) {
      return 0;
    }
    
    return index;
  }

  @override
  void initState() {
    currentMarker = widget.dashboardMarker;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    if (currentMarker != widget.dashboardMarker) {
      currentMarker = widget.dashboardMarker;
    }
    if (!(subContainerIsHidden(currentMarker!))) widget.scaffoldKey.currentState?.closeDrawer();

    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: SizedBox(
       width: (subContainerIsHidden(currentMarker!)) ? 350 : 0,
        child: Drawer(
          elevation: 0,
          backgroundColor: widget.model.webBackgroundColor,
          child: updateSubContainer(currentMarker!),
        ),
      ),
      appBar: (Responsive.isMobile(context) && showTopNavBar(currentMarker ?? widget.dashboardMarker) && widget.isLoggedIn) ? AppBar(
        backgroundColor: widget.model.paletteColor,
        elevation: 0,
        title: Text(widget.dashboardContainerItems[retrieveSelectedIndex(currentMarker ?? DashboardMarker.search)].tabTitle,),
        titleTextStyle: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize),
        automaticallyImplyLeading: false,
        leading: (subContainerIsHidden(currentMarker!)) ? IconButton(
          onPressed: () {
            setState(() {
              widget.scaffoldKey.currentState?.openDrawer();
            });
          },
          icon: Icon(Icons.menu, color: widget.model.accentColor),
        ) : null,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  currentMarker = widget.optionsMarkerItem.dashboardMarker;
                });
                widget.didSelectDashboardMarkerItem(widget.optionsMarkerItem.dashboardMarker);
              },
            icon: Icon(widget.optionsMarkerItem.iconTab, color: widget.model.accentColor),
          ),
        ],
      ) : null,
      // bottomNavigationBar: (Responsive.isMobile(context) && widget.isLoggedIn) ? BottomNavigationBar(
      //   onTap: (i) {
      //     setState(() {
      //       currentMarker = widget.dashboardContainerItems[i].dashboardMarker;
      //     });
      //     widget.didSelectDashboardMarkerItem(widget.dashboardContainerItems[i].dashboardMarker);
      //   },
      //   backgroundColor: widget.model.mobileBackgroundColor,
      //   elevation: 0,
      //   currentIndex: ((retrieveSelectedIndex(currentMarker!)) >= 4) ? 0 : retrieveSelectedIndex(currentMarker!),
      //   enableFeedback: true,
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: widget.model.paletteColor,
      //   unselectedItemColor: widget.model.paletteColor.withOpacity(0.65),
      //   items: widget.dashboardContainerItems.where((element) => element.isVisible == true).map(
      //           (e) => BottomNavigationBarItem(
      //     label: e.tabTitle,
      //     icon: (e.imageUrl != null && e.imageUrl?.isNotEmpty == true) ? CircleAvatar(
      //         backgroundImage: Image.asset('assets/profile-avatar.png').image,
      //         foregroundImage: (e.imageUrl?[0] != '') ? Image.network(e.imageUrl?[0] ?? '').image : null
      //       ) : Icon(e.iconTab)
      //     )
      //   ).toList(),
      // ) : null,
      body: Stack(
        children: [
          // Responsive(
          //   mobile: Column(
          //     children: [
          //       Expanded(
          //         child: MainMenuContainer(
          //           model: widget.model,
          //           mainContainer: updateMainContainer(currentMarker!) ?? Container(),
          //           subContainer: updateSubContainer(currentMarker!) ?? Container(),
          //           sidePanelMainContainer: mainContainerSidePanel(currentMarker!) ?? Container(),
          //           presentSideContainer: presentSidePanelContainer(currentMarker!),
          //           showDrawer: (subContainerIsHidden(currentMarker!)) && MediaQuery.of(context).size.width <= 900,
          //           isFullBleed: isMainContainerFullBleeed(currentMarker!),
          //         ),
          //       ),
          //     ],
          //   ),
          //   tablet: Row(
          //     children: [
                
          //       if (subContainerIsHidden(currentMarker!)) Expanded(
          //         flex: 5,
          //         child: SubContainer(
          //           model: widget.model,
          //           currentMarker: currentMarker!,
          //           menuMarkerItems: widget.dashboardContainerItems,
          //           subWidget: updateSubContainer(currentMarker!) ?? Container(),
          //           didSelectMarker: (marker) {
          //             widget.didSelectDashboardMarkerItem(marker);
          //           },
          //           optionsMarkerItem: widget.optionsMarkerItem
          //         ),
          //       ),
          //       Expanded(
          //         flex: 10,
          //         child: MainMenuContainer(
          //           model: widget.model,
          //           mainContainer: updateMainContainer(currentMarker!) ?? Container(),
          //           subContainer: updateSubContainer(currentMarker!) ?? Container(),
          //           sidePanelMainContainer: mainContainerSidePanel(currentMarker!) ?? Container(),
          //           presentSideContainer: presentSidePanelContainer(currentMarker!),
          //           showDrawer: (subContainerIsHidden(currentMarker!)) && MediaQuery.of(context).size.width <= 900,
          //           isFullBleed: isMainContainerFullBleeed(currentMarker!),
          //         ),
          //       )
          
          //     ],
          //   ),
          //   desktop: Row(
          //     children: [
          //       // if (!(Responsive.isMobile(context))) AnimatedContainer(
          //       //   duration: Duration(milliseconds: 750),
          //       //   child: SidePanelContainer(
          //       //     model: widget.model,
          //       //     currentMarker: currentMarker!,
          //       //     sideMarkerItems: widget.dashboardContainerItems,
          //       //     didSelectMarker: (marker) {
          //       //       setState(() {
          //       //         currentMarker = marker;
          //       //       });
          //       //       widget.didSelectDashboardMarkerItem(marker);
          //       //     },
          //       //     optionsMarkerItem: widget.optionsMarkerItem
          //       //   ),
          //       // ),
          //       if (subContainerIsHidden(currentMarker!) && (!(Responsive.isMobile(context)))) Expanded(
          //         flex: _size.width > 1340 ? 3 : 5,
          //         child: AnimatedContainer(
          //           duration: Duration(milliseconds: 750),
          //           child: SubContainer(
          //             model: widget.model,
          //             currentMarker: currentMarker!,
          //             menuMarkerItems: widget.dashboardContainerItems,
          //             subWidget: updateSubContainer(currentMarker!) ?? Container(),
          //             didSelectMarker: (marker) {
          //               widget.didSelectDashboardMarkerItem(marker);
          //             },
          //             optionsMarkerItem: widget.optionsMarkerItem
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: _size.width > 1340 ? 9 : 11,
          //         child: AnimatedContainer(
          //           duration: const Duration(milliseconds: 750),
          //           child: MainMenuContainer(
          //             model: widget.model,
          //             mainContainer: updateMainContainer(currentMarker!) ?? Container(),
          //             subContainer: updateSubContainer(currentMarker!) ?? Container(),
          //             sidePanelMainContainer: mainContainerSidePanel(currentMarker!) ?? Container(),
          //             presentSideContainer: presentSidePanelContainer(currentMarker!),
          //             showDrawer: (subContainerIsHidden(currentMarker!)) && MediaQuery.of(context).size.width <= 900,
          //             isFullBleed: isMainContainerFullBleeed(currentMarker!),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          Row(
            children: [
              if (subContainerIsHidden(currentMarker!) && (!(Responsive.isMobile(context)))) Container(
                width: 450,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 750),
                    child: SubContainer(
                      model: widget.model,
                      currentMarker: currentMarker!,
                      menuMarkerItems: widget.dashboardContainerItems,
                      subWidget: updateSubContainer(currentMarker!) ?? Container(),
                      didSelectMarker: (marker) {
                        widget.didSelectDashboardMarkerItem(marker);
                      },
                      optionsMarkerItem: widget.optionsMarkerItem
                    ),
                  ),
                ),
                Expanded(
                  flex: _size.width > 1340 ? 9 : 11,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 750),
                    child: MainMenuContainer(
                      model: widget.model,
                      mainContainer: updateMainContainer(currentMarker!) ?? Container(),
                      subContainer: updateSubContainer(currentMarker!) ?? Container(),
                      sidePanelMainContainer: mainContainerSidePanel(currentMarker!) ?? Container(),
                      presentSideContainer: presentSidePanelContainer(currentMarker!),
                      showDrawer: (subContainerIsHidden(currentMarker!)) && MediaQuery.of(context).size.width <= 900,
                      isFullBleed: isMainContainerFullBleeed(currentMarker!),
                    ),
                  ),
                )
            ],
          ),

          Positioned(
            left: 12,
            child: SidePanelContainer(
              model: widget.model,
              currentMarker: currentMarker!,
              sideMarkerItems: widget.dashboardContainerItems,
              didSelectMarker: (marker) {
                setState(() {
                  currentMarker = marker;
                });
                widget.didSelectDashboardMarkerItem(marker);
              },
              optionsMarkerItem: widget.optionsMarkerItem
            ),
          ),
        ],
      )
    );
  }
}