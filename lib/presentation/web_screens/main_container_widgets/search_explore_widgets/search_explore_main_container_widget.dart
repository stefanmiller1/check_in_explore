import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/create_activity/create_activity_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/discovery_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/list_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_components/listing_result_main_card.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_explore_filter.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/web/search_when_web.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/web/search_where_web.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/web/search_who_web.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_helper_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../screens/create_activity/create_activity_screen.dart';

class SearchExploreMainContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final Function() didUpdate;
  final UserProfileModel? currentUser;

  const SearchExploreMainContainerWidget({super.key, required this.model, required this.currentUser, required this.didUpdate});

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
      case SearchExploreHelperMarker.map:
        return Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: MapSearchContainer(
                      model: widget.model,
                      selectedListing: (listing) {
                        setState(() {
                          widget.didUpdate();
                        });
                      },
                      didSelectListingPreview: (listing) {

                        didSelectCreateNewActivity(
                          context,
                          widget.model,
                          listing,
                          2
                        );
                        // setState(() {
                        //   ExploreWebHelperCore.didSelectFacilityItem(context, listing);
                        // });
                        //   Future.delayed(const Duration(seconds: 2), () {
                        //     setState(() {
                        //       ExploreWebHelperCore.isLoading = false;
                        //    });
                        // });
                      },
                    ),
                  ),

                 getSearchHeaderToggleTopBar(),
                 // getFooterFilterBar(),

                  ],
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  AnimatedContainer(
                    width: (kIsWeb && Responsive.isDesktop(context)) ? 400 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceInOut,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 400,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: MapHelper.scrollController,
                            itemCount: context.read<ListingsSearchRequirementsBloc>().state.listings.length,
                            itemBuilder: (_, index) {
                              final listingItem = context.read<ListingsSearchRequirementsBloc>().state.listings.toList()[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 7.0),
                                child: SizedBox(
                                  height: 550,
                                  width: 400,
                                  child: ListingResultMainCard(
                                    listing: listingItem,
                                    model: widget.model,
                                    showReservations: true,
                                    isLoading: context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading,
                                    didSelectEmbeddedRes: (listing, res) {
                                      setState(() {
                                        ExploreWebHelperCore.didSelectReservationItem(context, listing, res);
                                      });
                                      Future.delayed(const Duration(seconds: 2), () {
                                      setState(() {
                                        ExploreWebHelperCore.isLoading = false;
                                        });
                                      });
                                    },
                                    didSelectMainImage: (listing) {
                                      MapHelper.mapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                  zoom: 15,
                                                  target: LatLng(
                                                      listing.listingProfileService.listingLocationSetting.locationPosition!.latitude,
                                                      listing.listingProfileService.listingLocationSetting.locationPosition!.longitude
                                                  )
                                        )
                                      )
                                    );
                                  },
                                  didSelectFooter: (ListingManagerForm listing) {
                                    didSelectCreateNewActivity(
                                        context,
                                        widget.model,
                                        listing,
                                        2
                                    );
                                    // setState(() {
                                    //   ExploreWebHelperCore.didSelectFacilityItem(context, listing);
                                    // });
                                    //   Future.delayed(const Duration(seconds: 2), () {
                                    //     setState(() {
                                    //       ExploreWebHelperCore.isLoading = false;
                                    //     });
                                    //
                                    // });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 20,
                    child: AnimatedContainer(
                      width: (kIsWeb && Responsive.isDesktop(context)) ? 300 : 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceInOut,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading ? Shimmer.fromColors(
                            enabled: context.read<ListingsSearchRequirementsBloc>().state.isMarkersLoading,
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 35,
                              width: 190,
                              decoration: BoxDecoration(
                                color: widget.model.accentColor.withOpacity(0.15),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ) : Chip(
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              backgroundColor: widget.model.paletteColor,
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${context.read<ListingsSearchRequirementsBloc>().state.listings.length} Listings Found', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      case SearchExploreHelperMarker.list:
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListSearchContainer(
              model: widget.model,
              currentUserId: widget.currentUser?.userId,
              didSelectListing: (ListingManagerForm listing) {
                setState(() {
                  ExploreWebHelperCore.didSelectFacilityItem(context, listing);
                });

                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    ExploreWebHelperCore.isLoading = false;
                  });
                });

              },
              didSelectReservation: (ListingManagerForm? listing, ReservationItem reservation) {
                setState(() {
                  if (listing != null) {
                    ExploreWebHelperCore.didSelectReservationItem(context, listing, reservation);
                  }
                });

                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    ExploreWebHelperCore.isLoading = false;
                  });
                });
              },
            ),
            getSearchHeaderToggleTopBar(),
            // getFooterFilterBar(),
         ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child:  Stack(
            alignment: Alignment.center,
            children: [

              getMainContainer(context, ExploreWebHelperCore.searchExploreMarker),


              AnimatedOpacity(
                duration: Duration(milliseconds: 800),
                opacity: ExploreWebHelperCore.selectedSearch ? 1 : 0,
                  child: Visibility(
                      visible: ExploreWebHelperCore.selectedSearch,
                      child: SlideInTransitionWidget(
                        durationTime: 400,
                        offset: const Offset(0.0, 1.0),
                        transitionWidget: PointerInterceptor(
                          child: DiscoverySearchComponent(
                            model: widget.model,
                            didSelectListing: (listing) {
                              didSelectCreateNewActivity(
                                  context,
                                  widget.model,
                                  listing,
                                  2
                              );
                            //   setState(() {
                            //     ExploreWebHelperCore.didSelectFacilityItem(context, listing);
                            //   });
                            // Future.delayed(const Duration(seconds: 2), () {
                            //   setState(() {
                            //     ExploreWebHelperCore.isLoading = false;
                            //   });
                            // });
                        },
                      ),
                    ),
                  )
                ),
              ),

              Visibility(
                visible: ExploreWebHelperCore.selectedSearch,
                child: Positioned(
                    top: 15,
                    right: 15,
                    child: IconButton(
                      icon: Icon(Icons.cancel, color: widget.model.paletteColor, size: 35),
                      onPressed: () {
                        setState(() {
                          Beamer.of(context).update(
                              configuration: RouteInformation(
                                  location: '/${DashboardMarker.home.name.toString()}'
                              ),
                              rebuild: false
                          );
                          ExploreWebHelperCore.selectedSearch = false;
                      });
                    },
                  )
                ),
              ),

              Visibility(
                visible: ExploreWebHelperCore.selectedListing,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (ExploreWebHelperCore.currentReservationItemId == null && ExploreWebHelperCore.currentFacilityItemId != null) PointerInterceptor(
                      child: FacilityPreviewScreen(
                        model: widget.model,
                        listingId: ExploreWebHelperCore.currentFacilityItemId!,
                        listing: ExploreWebHelperCore.selectedFacilityItem,
                        isAutoImplyLeading: true,
                        selectedReservationsSlots: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                        didSelectBack: () {},
                        didSelectReservation: (listing, res) {
                            setState(() {
                              ExploreWebHelperCore.didSelectReservationItem(context, listing, res);
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                ExploreWebHelperCore.isLoading = false;
                              });

                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                  visible: ExploreWebHelperCore.selectedListing,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (ExploreWebHelperCore.currentReservationItemId != null && ExploreWebHelperCore.currentFacilityItemId != null) PointerInterceptor(
                        child: ActivityPreviewScreen(
                            model: widget.model,
                            currentListingId: ExploreWebHelperCore.currentFacilityItemId!,
                            currentReservationId: ExploreWebHelperCore.currentReservationItemId!,
                            listing: ExploreWebHelperCore.selectedFacilityItem,
                            reservation: ExploreWebHelperCore.selectedReservationItem,
                            didSelectBack: () {  },
                    ),
                      ),
                  ],
                )
              ),

              if (ExploreWebHelperCore.selectedListing) Positioned(
                bottom: 130,
                child: Visibility(
                  visible: ExploreWebHelperCore.isLoading == false,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        ExploreWebHelperCore.selectedListing = false;
                        ExploreWebHelperCore.isLoading = true;

                        Beamer.of(context).update(
                            configuration: RouteInformation(
                                location: '/${DashboardMarker.home.name.toString()}'
                            ),
                            rebuild: false
                        );

                        Future.delayed(const Duration(milliseconds: 600), () {
                          setState(() {
                            ExploreWebHelperCore.isLoading = false;
                          });
                        });
                      });
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Center(
                          child: Chip(
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: widget.model.paletteColor,
                              label: Text('Back',
                                  style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                              avatar: Icon(Icons.u_turn_left_rounded, color: widget.model.accentColor)
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (ExploreWebHelperCore.isLoading) Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: widget.model.mobileBackgroundColor,
                  child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)),

            ],
          ),
        )
      ),
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
                              location: '/${DashboardMarker.home.name.toString()}/${SearchExploreHelperMarker.map.toString()}/search'
                          ),

                          rebuild: false
                      );
                      ExploreWebHelperCore.selectedSearch = true;
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
                          child: Text('Search & Find New Communities', style: TextStyle(color: widget.model.paletteColor), maxLines: 1,),
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