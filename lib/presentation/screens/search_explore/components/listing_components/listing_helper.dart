import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../map_helper.dart';

Widget listingSpacesPagePreview(BuildContext context, DashboardModel model, double height, PageController pageController, int currentPageIndex, List<SpaceOption> spaces, bool showItemSelectedTabs, {required Function() didSelectItem, required Function(int, SpaceOptionSizeDetail) onPageChanged}) {
  // Image(image: e.items.firstWhere((element) => element.listingServiceId.getOrCrash() == widget.marker.markerId.value).listingProfileService.spaceSetting.spaceTypes.getOrCrash().first.quantity.first.spacePhoto!.image) : noReservationsFound()
  final List<SpaceOptionSizeDetail> spacesWithImage = [];

  for (SpaceOption space in spaces) {
    for (SpaceOptionSizeDetail spaceDetails in space.quantity) {

      if (spaceDetails.spacePhoto != null) {
        spacesWithImage.add(spaceDetails);
      }
    }
  }


  return GestureDetector(
    onTap: didSelectItem,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
              controller: pageController,
              itemCount: spacesWithImage.length,
              onPageChanged: (page) {
                final SpaceOptionSizeDetail currentSpaceDetail = spacesWithImage[page];
                onPageChanged(page, currentSpaceDetail);
              },
              itemBuilder: (context, index) {
                final Image spacePhoto = spacesWithImage[index].spacePhoto ?? Image.asset('assets/images/facility_creator/activity_subscription_get_started_bw.png');

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    errorBuilder: (context, err, stack) {
                      return Container();
                    },
                    image: spacePhoto.image, fit: BoxFit.cover,
                  ),
                );
              }
          ),
          if (showItemSelectedTabs) getImageItemSelectionTabWidget(context, model, spacesWithImage.length, currentPageIndex),
        ],
      ),
    ),
  );
}

Widget retrieveListingPreviewFacility(BuildContext context, DashboardModel model, ListingManagerForm listings) {

  final List<SpaceOptionSizeDetail> spacesWithImage = [];
  final List<SpaceOption> spaces = listings.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r);
  for (SpaceOption space in spaces) {
    for (SpaceOptionSizeDetail spaceDetails in space.quantity) {

      if (spaceDetails.spacePhoto != null) {
        spacesWithImage.add(spaceDetails);
      }
    }
  }
  late SpaceOptionSizeDetail? currentSpace = null;

  if (currentSpace == null && spacesWithImage.isNotEmpty) currentSpace = spacesWithImage[0];
  final PricingRuleSettings currentPricing = listings.listingRulesService.pricingRuleSettings.where((element) => element.spaceId == currentSpace?.spaceId).isNotEmpty ? listings.listingRulesService.pricingRuleSettings.where((element) => element.spaceId == currentSpace?.spaceId).first : listings.listingRulesService.defaultPricingRuleSettings;


  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        color: model.accentColor,
                        borderRadius: const BorderRadius.all(Radius.circular(35)),
                      ),
                      child: retrieveUserProfile(
                        listings.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash(),
                        model,
                        null,
                        model.paletteColor,
                        model.secondaryQuestionTitleFontSize,
                        profileType: UserProfileType.firstLetterOnlyProfile,
                        trailingWidget: null,
                        selectedButton: (e) {

                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listings.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        FutureBuilder<double?>(
                            future: MapHelper.determineDistanceAway(LatLng(listings.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listings.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0)),
                            initialData: 0,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                return Text(convertLength(snap.data?.toInt() ?? 0), style: TextStyle(color: model.disabledTextColor), maxLines: 1);
                              }
                              return Container();
                          }),
                        ],
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Container(
              // width: 100,
              decoration: BoxDecoration(
                color: model.paletteColor,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: listings.listingRulesService.isPricingRuleFixed == true,
                      child: Text('${completeTotalPriceWithOutCurrency((listings.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency)} / ${((currentSpace?.durationType ?? 30) == 1440) ? 'day' : '${(currentSpace?.durationType ?? 30)}min'}', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                    Visibility(
                      visible: listings.listingRulesService.isPricingRuleFixed == false,
                      child: Text('${completeTotalPriceWithOutCurrency((currentPricing.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency)} / ${((currentSpace?.durationType ?? 30) == 1440) ? 'day' : '${(currentSpace?.durationType ?? 30)}min'}', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Container(
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(listings.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: model.paletteColor), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    ),
  );
}


Widget retrievedListingsFooter(BuildContext context, DashboardModel model, ListingManagerForm listings, SpaceOptionSizeDetail? currentSpace, bool showMoreInfo, {required Function() didTap}) {
  final List<SpaceOptionSizeDetail> spacesWithImage = [];
  final List<SpaceOption> spaces = listings.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r);
  for (SpaceOption space in spaces) {
    for (SpaceOptionSizeDetail spaceDetails in space.quantity) {

      if (spaceDetails.spacePhoto != null) {
        spacesWithImage.add(spaceDetails);
      }
    }
  }

  if (currentSpace == null && spacesWithImage.isNotEmpty) currentSpace = spacesWithImage[0];
  final PricingRuleSettings currentPricing = listings.listingRulesService.pricingRuleSettings.where((element) => element.spaceId == currentSpace?.spaceId).isNotEmpty ? listings.listingRulesService.pricingRuleSettings.where((element) => element.spaceId == currentSpace?.spaceId).first : listings.listingRulesService.defaultPricingRuleSettings;

  return InkWell(
    onTap: () {
      didTap();
    },
    child: Column(
      children: [
        Row(
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
                          color: model.accentColor,
                          borderRadius: const BorderRadius.all(Radius.circular(35)),
                        ),
                        child: retrieveUserProfile(
                          listings.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash(),
                          model,
                          null,
                          model.paletteColor,
                          model.secondaryQuestionTitleFontSize,
                          profileType: UserProfileType.firstLetterOnlyProfile,
                          trailingWidget: null,
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
                          Text(listings.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1),
                          Row(
                            children: [
                              Flexible(child: Text(listings.listingProfileService.listingLocationSetting.city.getOrCrash(), style: TextStyle(color: model.disabledTextColor), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              const SizedBox(width: 4),
                              FutureBuilder<double?>(
                                  future: MapHelper.determineDistanceAway(LatLng(listings.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listings.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0)),
                                  initialData: 0,
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      return Text(convertLength(snap.data?.toInt() ?? 0), style: TextStyle(color: model.disabledTextColor), maxLines: 1);
                                    }
                                  return Container();
                                }),
                            ],
                          ),
                        ],
                       )
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // const SizedBox(height: 5),
                  if (showMoreInfo) Container(
                    decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(listings.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: model.paletteColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
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
                          color: model.paletteColor.withOpacity(0.05),
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                        ),
                        child: IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today, color: model.paletteColor, size: 18,), tooltip: 'reservations',)),
                    const SizedBox(width: 10),
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: model.paletteColor.withOpacity(0.05),
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                        ),
                        child: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline_rounded, color: model.paletteColor, size: 21,), tooltip: 'save',))
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  // width: 100,
                  decoration: BoxDecoration(
                    color: model.paletteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: listings.listingRulesService.isPricingRuleFixed == true,
                          child: Text('${completeTotalPriceWithOutCurrency((listings.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency)} / Slot', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                        ),
                        Visibility(
                            visible: listings.listingRulesService.isPricingRuleFixed == false,
                            child: Text('${completeTotalPriceWithOutCurrency((currentPricing.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency)} / Slot', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                ),
                if (showMoreInfo) const SizedBox(height: 4),
                if (showMoreInfo) Container(
                    decoration: BoxDecoration(
                      color: ((currentSpace?.durationType ?? 30) == 1440) ? model.paletteColor.withOpacity(0.15) : model.paletteColor.withOpacity(0.05),
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(((currentSpace?.durationType ?? 30) == 1440) ? 'day slots' : '${(currentSpace?.durationType ?? 30)}min. slots', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)
                  ),
                    )
                )
              ],
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ],
    ),
  );
}


String convertLength(int length) {
  if (length <= 500) {
    return '${length}m • away';
  } else {
    return '${(length/1000).toStringAsFixed(0)}km • away';
  }
}