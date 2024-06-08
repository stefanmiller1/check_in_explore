import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_helper_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:flutter/material.dart';

import '../listing_components/listing_result_main_card.dart';

class DiscoveryListingWidget extends StatefulWidget {

  final List<ListingManagerForm> listings;
  final DashboardModel model;
  final ProfileActivityOption? activityFilterType;
  final Function(ListingManagerForm) didSelectListing;

  const DiscoveryListingWidget({super.key, required this.listings, required this.model, required this.activityFilterType, required this.didSelectListing});


  @override
  State<DiscoveryListingWidget> createState() => _DiscoveryListingWidgetState();
}

class _DiscoveryListingWidgetState extends State<DiscoveryListingWidget> {

  int _currentPage = 0;
  late bool showButton = false;
  late final Future<List<ReservationPreviewer>> getItemList;

  Future<List<ReservationPreviewer>> getWeightedDiscoveryFeed(List<ListingManagerForm> listings) async {
    late List<ReservationPreviewer> listingToPreview = [];

    for (ListingManagerForm listingItem in listings) {

      late int weight = 0;
      final List<SpaceOption> spaces = listingItem.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r);
      final List<SpaceOptionSizeDetail> spaceDetails = [];
      for (SpaceOption spaceOption in spaces) {
        spaceDetails.addAll(spaceOption.quantity);
      }
      final List<FacilityActivityCreatorForm> spaceActivityOptions = [];
      for (SpaceOptionSizeDetail spaceOptionSizeDetail in spaceDetails) {
        spaceActivityOptions.addAll(spaceOptionSizeDetail.activitySettings?.facilityActivityOptions ?? []);
      }

      /// filter by type of listing
      if (spaceActivityOptions.map((e) => e.activity.activity).contains(widget.activityFilterType) == true) {

        ReservationPreviewer resPreview = ReservationPreviewer(
            listing: listingItem,
            previewWeight: weight
        );


        /// number of reservations completed - contributes 1 point per res
        try {
          final listingsTotalReservationsCount = await ReservationFacade.instance.getNumberOfReservationsBooked(
              listingId: listingItem.listingServiceId.getOrCrash(),
              statusType: [ReservationSlotState.completed, ReservationSlotState.current],
              hoursTimeAhead: null,
              hoursTimeBefore: null
          );

          resPreview = resPreview.copyWith(
              reservationCount: listingsTotalReservationsCount
          );
          /// has attendees (1 point per attendee - or 5 points flat?)
          if (listingsTotalReservationsCount != 0) {
            weight += (1 * listingsTotalReservationsCount);
          }


        } catch (e) {}


        try {
          final listingsReservations = await ReservationFacade.instance.getReservationsBooked(
              listingId: listingItem.listingServiceId.getOrCrash(),
              statusType: [ReservationSlotState.current, ReservationSlotState.confirmed],
              hoursTimeAhead: null,
              hoursTimeBefore: null
          );

          resPreview = resPreview.copyWith(
              reservations: listingsReservations
          );

        } catch (e) {}



        resPreview = resPreview.copyWith(
            previewWeight: weight
        );
        listingToPreview.add(resPreview);
      }
    }
    return listingToPreview.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
  }

  @override
  void initState() {
    // TODO: implement initState
    getItemList = getWeightedDiscoveryFeed(widget.listings);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) {
        setState(() {
          showButton = true;
        });
      },
      onHover: (e) {
        setState(() {
          showButton = true;
        });
      },
      onExit: (e) {
        setState(() {
          showButton = false;
        });
      },
      child: FutureBuilder<List<ReservationPreviewer>>(
        future: getItemList,
        builder: (context, snap) {
          final listingList = snap.data ?? [];


          final PageController _reservationPageController = PageController(initialPage: 2, viewportFraction: 450 / MediaQuery.of(context).size.width);


          return Stack(
            alignment: Alignment.topCenter,
            children: [

              PageView.builder(
                  padEnds: false,
                  controller: _reservationPageController,
                  itemCount: listingList.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ReservationPreviewer preview = listingList[index];

                    /// TODO: add header weight messgaes
                    /// if within 10 days of finishing add 'ENDING SOON'
                    /// if over 50 weight add 'POPULAR'
                    /// if started within 14 days from now 'NEW'
                    /// if between 20 - 30 'ON THE RISE'

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (preview.listing != null) Container(
                            height: MediaQuery.of(context).size.height,
                            width: 450,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.11),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                            child: ListingResultMainCard(
                              listing: preview.listing!,
                              showReservations: false,
                              model: widget.model,
                              isLoading: snap.connectionState == ConnectionState.waiting,
                              didSelectEmbeddedRes: (listing, res) {

                              },
                              didSelectMainImage: (listing) {
                                widget.didSelectListing(listing);
                              },
                              didSelectFooter: (ListingManagerForm listing) {
                                widget.didSelectListing(listing);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),

              AnimatedOpacity(
                duration: Duration(milliseconds: 350),
                opacity: (showButton) ? 1 : 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color:  widget.model.paletteColor,
                              border: Border.all(color: widget.model.paletteColor, width: 0.5),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _reservationPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                              });
                            },
                            icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.model.disabledTextColor),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: widget.model.paletteColor,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _reservationPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                              });
                            },
                            icon: Icon(Icons.arrow_forward_ios_rounded, color: widget.model.disabledTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}