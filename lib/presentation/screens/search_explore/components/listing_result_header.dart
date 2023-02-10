import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/profile_user_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/listing_preview/listing_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helper.dart';

class ListingResultHeader extends StatefulWidget {

  final bool isLoading;
  final Marker marker;
  final DashboardModel model;
  final UserProfileModel? currentUser;

  const ListingResultHeader({super.key, required this.isLoading, required this.marker, required this.model, this.currentUser});

  @override
  State<ListingResultHeader> createState() => _ListingResultHeaderState();
}

class _ListingResultHeaderState extends State<ListingResultHeader> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: 115,
      width: MediaQuery.of(context).size.width,
      child: widget.isLoading ? isLoading() : getDetailsForListing(context)
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


  Widget getDetailsForListing(BuildContext context) {
    return BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadAllPublicListingItemsSuccess: (e) => (e.items.map((e) => e.listingServiceId).contains(UniqueId.fromUniqueString(widget.marker.markerId.value))) ? retrievedListings(context, e.items.firstWhere((element) => element.listingServiceId == UniqueId.fromUniqueString(widget.marker.markerId.value))) : cannotFindAnyListingsHeader(),
              loadAllPublicListingItemsFailure: (e) => cannotFindAnyListingsHeader(),
              orElse: () => cannotFindAnyListingsHeader());
      }
    );
  }


  Widget retrievedListings(BuildContext context, ListingManagerForm listings) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context, HeroDialogRoute(
              barrierLabelString: '',
              builder: (context) {
                  return ListingPreviewScreen(
                    listing: listings,
                    marker: widget.marker,
                    model: widget.model,
                    // currentUser: widget.currentUser,
                );
              }
          ));
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: widget.model.accentColor,
                        borderRadius: const BorderRadius.all(Radius.circular(35)),
                      ),
                      child: retrieveUserProfile(
                        listings.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash(),
                        widget.model,
                        null,
                        widget.model.paletteColor,
                        widget.model.secondaryQuestionTitleFontSize,
                        profileType: UserProfileType.firstLetterOnlyProfile,
                        selectedButton: (e) {

                        },

                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listings.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1),
                        FutureBuilder<double?>(
                            future: MapHelper.determineDistanceAway(widget.marker.position),
                            initialData: 0,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                return Row(
                                  children: [
                                    Text('${snap.data?.toInt()}m • away', style: TextStyle(color: widget.model.disabledTextColor)),
                                  ],
                                );
                              }
                              return Container();
                            }),
                      ],
                    )),

                  ],
                ),
                const SizedBox(height: 5),


                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(listings.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: widget.model.paletteColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(height: 10),

              ],
            ),
          ),



          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor.withOpacity(0.05),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today, color: widget.model.paletteColor, size: 18,), tooltip: 'reservations',)),
                  const SizedBox(width: 10),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor.withOpacity(0.05),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline_rounded, color: widget.model.paletteColor, size: 21,), tooltip: 'save',))
                ],
              ),
              const SizedBox(height: 8),
              Container(
                // width: 100,
                decoration: BoxDecoration(
                  color: widget.model.paletteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(completeTotalPriceWithOutCurrency((listings.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                ),
              ),
              const SizedBox(height: 4),
              Text(' -- slots/week', style: TextStyle(color: widget.model.paletteColor))
            ],
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }


}