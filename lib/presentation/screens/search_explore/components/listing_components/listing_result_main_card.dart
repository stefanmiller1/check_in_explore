import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_components/listing_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_components/listing_result_main.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_helper_core.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/components/reservation_card.dart';
import '../helper.dart';


class ListingResultMainCard extends StatefulWidget {

  final bool isLoading;
  final ListingManagerForm listing;
  final DashboardModel model;
  final UserProfileModel? currentUser;
  final bool showReservations;
  final Function(ListingManagerForm listing) didSelectFooter;
  final Function(ListingManagerForm listing) didSelectMainImage;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes;

  const ListingResultMainCard({super.key, required this.isLoading, required this.model, this.currentUser, required this.listing, required this.didSelectMainImage, required this.didSelectFooter, required this.didSelectEmbeddedRes, required this.showReservations});

  @override
  State<ListingResultMainCard> createState() => _ListingResultMainCardState();
}

class _ListingResultMainCardState extends State<ListingResultMainCard> {

  late SpaceOptionSizeDetail? currentSpaceOption = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.model.mobileBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: 'image_hero',
                child: ListingResultMain(
                  showReservations: widget.showReservations,
                  listing: widget.listing,
                  isLoading: widget.isLoading,
                  model: widget.model,
                  didSelectEmbeddedRes: (listing, res) => widget.didSelectEmbeddedRes(listing, res),
                  didSelectListingItem: (listing) => widget.didSelectMainImage(listing),
                  didChangeSpaceOptionItem: (SpaceOptionSizeDetail space) {
                    setState(() {
                      currentSpaceOption = space;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 125,
                width: MediaQuery.of(context).size.width,
                child: widget.isLoading ? isLoading() : retrievedListingsFooter(
                    context,
                    widget.model,
                    widget.listing,
                    currentSpaceOption,
                    true,
                    didTap: () {
                      setState(() {
                        if (kIsWeb) {
                          widget.didSelectFooter(widget.listing);
                        } else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) {
                              return DismissiblePage(
                                startingOpacity: 0.75,
                                backgroundColor: Colors.transparent,
                                direction: DismissiblePageDismissDirection.startToEnd,
                                isFullScreen: true,
                                onDismissed: () {
                                  Navigator.of(context).pop();
                                },
                                child: FacilityPreviewScreen(
                                    listing: widget.listing,
                                    listingId: widget.listing.listingServiceId,
                                    model: widget.model,
                                    isAutoImplyLeading: false,
                                    selectedReservationsSlots: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                    didSelectBack: () {},
                                    didSelectReservation: (listing, res) {

                                  },
                                ),
                              );
                            }
                        ));
                      }
                    });
                })
            ),
          ],
        ),
      ),
    );
  }

  Widget isLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 15,
              ),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 18,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }


  // Widget getDetailsForListing(BuildContext context) {
  //   return BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
  //       builder: (context, state) {
  //         return state.maybeMap(
  //             loadAllPublicListingItemsSuccess: (e) => (e.items.map((e) => e.listingServiceId).contains(UniqueId.fromUniqueString(widget.marker.markerId.value))) ? retrievedListings(context, e.items.firstWhere((element) => element.listingServiceId == UniqueId.fromUniqueString(widget.marker.markerId.value))) : cannotFindAnyListingsHeader(),
  //             loadAllPublicListingItemsFailure: (e) => cannotFindAnyListingsHeader(),
  //             orElse: () => cannotFindAnyListingsHeader());
  //     }
  //   );
  // }
  //

}