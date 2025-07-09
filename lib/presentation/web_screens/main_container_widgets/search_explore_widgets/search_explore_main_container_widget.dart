import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/core/router_helper.dart';
import 'package:check_in_presentation/explore_core_widgets/components/template_components/explore_search_shell.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/list_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_explore_filter.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/web/search_when_web.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/web/search_where_web.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/web/search_who_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchExploreMainContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final Function() didUpdate;
  final UserProfileModel? currentUser;
  final ExploreFilterObject? initialFilterObject;

  const SearchExploreMainContainerWidget({super.key, required this.model, required this.currentUser, required this.didUpdate, this.initialFilterObject});

  @override
  State<SearchExploreMainContainerWidget> createState() => _SearchExploreMainContainerWidgetState();
}

class _SearchExploreMainContainerWidgetState extends State<SearchExploreMainContainerWidget> {

  @override
  void initState() {
    MapHelper.scrollController = ScrollController();
    super.initState();
  }

  Widget getMainContainer(BuildContext context, SearchExploreHelperMarker marker) {
    switch (marker) {
    //   case SearchExploreHelperMarker.map:
    //   return Container();
    //   case SearchExploreHelperMarker.list:
    //     return Stack(
    //       alignment: Alignment.bottomCenter,
    //       children: [
    //         ListSearchContainer(
    //           model: widget.model,
    //           currentUserId: widget.currentUser?.userId,
    //           didSelectListing: (ListingManagerForm listing) {
    //             setState(() {
    //               ExploreWebHelperCore.didSelectFacilityItem(context, listing);
    //             });

    //             Future.delayed(const Duration(seconds: 2), () {
    //               setState(() {
    //                 ExploreWebHelperCore.isLoading = false;
    //               });
    //             });

    //           },
    //           didSelectReservation: (ListingManagerForm? listing, ReservationItem reservation) {
    //             setState(() {
    //               if (listing != null) {
    //                 ExploreWebHelperCore.didSelectReservationItem(context, listing, reservation);
    //               }
    //             });

    //             Future.delayed(const Duration(seconds: 2), () {
    //               setState(() {
    //                 ExploreWebHelperCore.isLoading = false;
    //               });
    //             });
    //           },
    //         ),
    //         getSearchHeaderToggleTopBar(),
    //         // getFooterFilterBar(),
    //      ],
    //   );
    //   case SearchExploreHelperMarker.profile:
    //     return Container();
    //     // TODO: Handle this case.
    //     break;
    //   case SearchExploreHelperMarker.listing:
    //     if (ExploreWebHelperCore.currentReservationItemId == null && ExploreWebHelperCore.currentFacilityItemId != null) {
    //       return Stack(
    //         alignment: Alignment.bottomCenter,
    //         children: [
    //           PointerInterceptor(
    //                 child: FacilityPreviewScreen(
    //                   model: widget.model,
    //                   listingId: ExploreWebHelperCore.currentFacilityItemId!,
    //                   listing: ExploreWebHelperCore.selectedFacilityItem,
    //                   isAutoImplyLeading: true,
    //                   selectedReservationsSlots: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
    //                   didSelectBack: () {},
    //                   didSelectReservation: (listing, res) {
    //                       setState(() {
    //                         ExploreWebHelperCore.didSelectReservationItem(context, listing, res);
    //                       });
    //                       Future.delayed(const Duration(seconds: 2), () {
    //                         setState(() {
    //                           ExploreWebHelperCore.isLoading = false;
    //                         });

    //                     });
    //                   },
    //                 ),
    //               ),
    //         ],
    //       );
    //         } else {
    //       return Container();
    //     }
      case SearchExploreHelperMarker.activity:
       if (ExploreWebHelperCore.currentReservationItemId != null && ExploreWebHelperCore.currentFacilityItemId != null) {
         return Stack(
           alignment: Alignment.bottomCenter,
           children: [
             PointerInterceptor(
               child: ActivityPreviewScreen(
                 model: widget.model,
                 currentListingId: ExploreWebHelperCore.currentFacilityItemId!,
                 currentReservationId: ExploreWebHelperCore
                     .currentReservationItemId!,
                 listing: ExploreWebHelperCore.selectedFacilityItem,
                 reservation: ExploreWebHelperCore.selectedReservationItem,
                 didSelectBack: () {

                 },
               ),
             ),
           ],
         );
       } else {
         return Container();
       }
      case SearchExploreHelperMarker.search:
        return  SlideInTransitionWidget(
          durationTime: 400,
          offset: const Offset(0.0, 1.0),
          transitionWidget: PointerInterceptor(
            child: ExploreSearchMainDashboard(
              model: widget.model,
              initialFilterObject: widget.initialFilterObject,
        ),
                  ),
                );
      default: 
        return  SlideInTransitionWidget(
          durationTime: 400,
          offset: const Offset(0.0, 1.0),
          transitionWidget: PointerInterceptor(
            child: ExploreSearchMainDashboard(
              model: widget.model,
              initialFilterObject: widget.initialFilterObject,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // SlideInTransitionWidget(
        //           durationTime: 400,
        //           offset: const Offset(0.0, 1.0),
        //           transitionWidget: PointerInterceptor(
        //             child: ExploreSearchMainDashboard(
        //               model: widget.model,
        //               initialFilterObject: widget.initialFilterObject,
        //         ),
        //       ),
        //     )
       getMainContainer(context, ExploreWebHelperCore.searchExploreMarker),

     

        // Visibility(
        //   visible: ExploreWebHelperCore.searchExploreMarker == SearchExploreHelperMarker.search,
        //   child: Positioned(
        //       top: 15,
        //       right: 15,
        //       child: IconButton(
        //         icon: Icon(Icons.cancel, color: widget.model.paletteColor, size: 35),
        //         onPressed: () {
        //           setState(() {
        //             Beamer.of(context).update(
        //                 configuration: RouteInformation(
        //                     location: homeTabRoute(DashboardMarker.search),
        //                 ),
        //                 rebuild: false
        //             );
        //             ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.map;
        //         });
        //       },
        //     )
        //   ),
        // ),


        // Visibility(
        //     visible: ExploreWebHelperCore.selectedListing,
        //     child: Stack(
        //       alignment: Alignment.bottomCenter,
        //       children: [
        //         if (ExploreWebHelperCore.currentReservationItemId != null && ExploreWebHelperCore.currentFacilityItemId != null) PointerInterceptor(
        //           child: ActivityPreviewScreen(
        //               model: widget.model,
        //               currentListingId: ExploreWebHelperCore.currentFacilityItemId!,
        //               currentReservationId: ExploreWebHelperCore.currentReservationItemId!,
        //               listing: ExploreWebHelperCore.selectedFacilityItem,
        //               reservation: ExploreWebHelperCore.selectedReservationItem,
        //               didSelectBack: () {  },
        //         ),
        //       ),
        //     ],
        //   )
        // ),

  //       if (ExploreWebHelperCore.searchExploreMarker == SearchExploreHelperMarker.activity || ExploreWebHelperCore.searchExploreMarker == SearchExploreHelperMarker.listing) Positioned(
  //         bottom: 130,
  //         child: Visibility(
  //           visible: ExploreWebHelperCore.isLoading == false,
  //           child: InkWell(
  //             onTap: () {
  //               setState(() {
  //                 ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;
  //                 ExploreWebHelperCore.isLoading = true;

  //                       Beamer.of(context).update(
  //                           configuration: RouteInformation(
  //                               location: homeTabRoute(DashboardMarker.search),
  //                           ),
  //                           rebuild: false
  //                       );

  //                 Future.delayed(const Duration(milliseconds: 600), () {
  //                   setState(() {
  //                     ExploreWebHelperCore.isLoading = false;
  //                   });
  //                 });
  //               });
  //             },
  //             child: Container(
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: widget.model.paletteColor,
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 3.0),
  //                 child: Center(
  //                   child: Chip(
  //                       side: BorderSide.none,
  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //                       backgroundColor: widget.model.paletteColor,
  //                       label: Text('Back',
  //                           style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
  //                       avatar: Icon(Icons.u_turn_left_rounded, color: widget.model.accentColor)
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),

  //       if (ExploreWebHelperCore.isLoading) Container(
  //           width: double.infinity,
  //           height: double.infinity,
  //           color: widget.model.mobileBackgroundColor,
  //           child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)
  //       ),
      ],
    );
  }

  Widget getSearchHeaderToggleTopBar() {
    return Positioned(
        top: 10,
        child: Visibility(
          visible: ExploreWebHelperCore.isLoading == false,
          child: PointerInterceptor(
            child: Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      Beamer.of(context).update(
                          configuration: RouteInformation(
                              location: searchExploreRoute()
                          ),

                          rebuild: false
                      );
                      ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.search;
                    });
                  },
                  child: Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: widget.model.disabledTextColor.withOpacity(0.35),
                            spreadRadius: 5,
                            blurRadius: 13,
                            offset: const Offset(5,0)
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 6),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.search_rounded, color: widget.model.paletteColor),
                            )
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('Search & Find New Circles', style: TextStyle(color: widget.model.paletteColor), maxLines: 1,),
                        )
                      ],
                    ),
                  ),
                ),


                // Positioned(
                //   right: 10,
                //   child: InkWell(
                //     onTap: () {
                //       setState(() {
                //         switch (ExploreWebHelperCore.searchExploreMarker) {
                //           case SearchExploreHelperMarker.map:
                //             ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.list;
                //             break;
                //           case SearchExploreHelperMarker.list:
                //             Beamer.of(context).update(
                //                 configuration: RouteInformation(
                //                     location: '/${DashboardMarker.home.toString()}'
                //                 ),
                //                 rebuild: false
                //             );
                //             ExploreWebHelperCore.searchExploreMarker = SearchExploreHelperMarker.map;
                //             break;
                //           default:
                //             break;
                //         }
                //       });
                //     },
                //     child: Container(
                //       height: 40,
                //       decoration: BoxDecoration(
                //         color: widget.model.paletteColor,
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 3.0),
                //         child: Center(
                //           child: Chip(
                //               side: BorderSide.none,
                //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //               backgroundColor: widget.model.paletteColor,
                //               label: Text(getTitleForExploreType(ExploreWebHelperCore.searchExploreMarker),
                //                   style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                //               avatar: Icon(getIconForExploreType(ExploreWebHelperCore.searchExploreMarker), color: widget.model.accentColor)
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
  }

  Widget getFooterFilterBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AnimatedOpacity(
          opacity: (SearchExploreWebHelperCore.isShowingWhoFilter || SearchExploreWebHelperCore.isShowingWhenFilter || SearchExploreWebHelperCore.isShowingWhereFilter) ? 1 : 0,
          duration: const Duration(milliseconds: 700),
          child: PointerInterceptor(
            child: Visibility(
              visible: (SearchExploreWebHelperCore.isShowingWhoFilter || SearchExploreWebHelperCore.isShowingWhenFilter || SearchExploreWebHelperCore.isShowingWhereFilter),
              child: InkWell(
                onTap: () {
                  setState(() {
                    SearchExploreWebHelperCore.isShowingWhoFilter = false;
                    SearchExploreWebHelperCore.isShowingWhereFilter = false;
                    SearchExploreWebHelperCore.isShowingWhenFilter = false;
                    widget.didUpdate();
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),

        if (SearchExploreWebHelperCore.isShowingWhereFilter) Container(
          height: 590,
          width: 600,
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PointerInterceptor(
              child: SlideInTransitionWidget(
                durationTime: 700,
                offset: const Offset(0.0, 1.0),
                transitionWidget: SearchWhereWeb(
                    didSelectItem: () {
                      setState(() {
                        SearchExploreWebHelperCore.isShowingWhoFilter = false;
                        SearchExploreWebHelperCore.isShowingWhereFilter = false;
                        SearchExploreWebHelperCore.isShowingWhenFilter = true;
                        widget.didUpdate();
                      });
                    },
                    model: widget.model
                ),
              ),
            ),
          ),
        ),
        if (SearchExploreWebHelperCore.isShowingWhenFilter) Container(
          height: 664,
          width: 600,
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PointerInterceptor(
              child: SlideInTransitionWidget(
                durationTime: 700,
                offset: const Offset(0.0, 1.0),
                transitionWidget: SearchWhenWeb(
                    didSelectItem: () {
                      setState(() {
                        SearchExploreWebHelperCore.isShowingWhoFilter = true;
                        SearchExploreWebHelperCore.isShowingWhereFilter = false;
                        SearchExploreWebHelperCore.isShowingWhenFilter = false;
                        widget.didUpdate();
                      });
                    },
                    model: widget.model
                ),
              ),
            ),
          ),
        ),
        if (SearchExploreWebHelperCore.isShowingWhoFilter) Container(
          height: 729,
          width: 600,
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: PointerInterceptor(
              child: SlideInTransitionWidget(
                durationTime: 700,
                offset: const Offset(0.0, 1.0),
                transitionWidget: SearchWhoWeb(
                    didSelectItem: () {
                      setState(() {
                        SearchExploreWebHelperCore.isShowingWhoFilter = false;
                        SearchExploreWebHelperCore.isShowingWhereFilter = false;
                        SearchExploreWebHelperCore.isShowingWhenFilter = false;
                        widget.didUpdate();
                      });
                    },
                    model: widget.model
                ),
              ),
            ),
          ),
        ),


        PointerInterceptor(
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(18)),
            child: Container(
              height: 155,
              width: MediaQuery.of(context).size.width,
              color: widget.model.accentColor,
            ),
          ),
        ),
        Container(
          height: 155,
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchExploreFilter(
                  model: widget.model,
                  didSelectFilterBy: widget.didUpdate
              ),
            ],
          ),
        ),
      ],
    );
  }
}