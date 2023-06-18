import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_helper.dart';

Widget listingSpacesPagePreview(BuildContext context, DashboardModel model, double height, PageController pageController, int currentPageIndex, List<SpaceOption> spaces, {required Function(int) onPageChanged}) {
  // Image(image: e.items.firstWhere((element) => element.listingServiceId.getOrCrash() == widget.marker.markerId.value).listingProfileService.spaceSetting.spaceTypes.getOrCrash().first.quantity.first.spacePhoto!.image) : noReservationsFound()
  final List<Image> spacesWithImage = [];

  for (SpaceOption space in spaces) {
    for (SpaceOptionSizeDetail spaceDetails in space.quantity) {

      if (spaceDetails.spacePhoto != null) {
        spacesWithImage.add(spaceDetails.spacePhoto!);
      }
    }
  }


  return SizedBox(
    height: height,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        PageView.builder(
            controller: pageController,
            itemCount: spacesWithImage.length,
            onPageChanged: (page) {
              onPageChanged(page);
            },
            itemBuilder: (context, index) {
              final Image spacePhoto = spacesWithImage[index];

              return Image(
                image: spacePhoto.image, fit: BoxFit.cover,
              );
            }
        ),
        getImageItemSelectionTabWidget(context, model, spacesWithImage.length, currentPageIndex)

      ],
    ),
  );
}

Widget retrieveListingPreviewFacility(BuildContext context, DashboardModel model, ListingManagerForm listings) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        Text(listings.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        FutureBuilder<double?>(
                            future: MapHelper.determineDistanceAway(LatLng(listings.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listings.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0)),
                            initialData: 0,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                return Text('${snap.data?.toInt()}m • away', style: TextStyle(color: model.disabledTextColor), maxLines: 1);
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: 100,
                decoration: BoxDecoration(
                  color: model.paletteColor,
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(completeTotalPriceWithOutCurrency((listings.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                ),
              ),
              // const SizedBox(height: 4),
              // Text(' -- slots/week', style: TextStyle(color: model.paletteColor))
            ],
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

Widget retrievedListingsFooter(BuildContext context, DashboardModel model, ListingManagerForm listings, {required Function() didTap}) {
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
                          FutureBuilder<double?>(
                              future: MapHelper.determineDistanceAway(LatLng(listings.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listings.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0)),
                              initialData: 0,
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return Text('${snap.data?.toInt()}m • away', style: TextStyle(color: model.disabledTextColor), maxLines: 1);
                                }
                                return Container();
                              }),
                        ],
                      )
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),


                  const SizedBox(height: 5),
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
                const SizedBox(height: 8),
                Container(
                  // width: 100,
                  decoration: BoxDecoration(
                    color: model.paletteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(completeTotalPriceWithOutCurrency((listings.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listings.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                  ),
                ),
                const SizedBox(height: 4),
                Text(' -- slots/week', style: TextStyle(color: model.paletteColor))
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