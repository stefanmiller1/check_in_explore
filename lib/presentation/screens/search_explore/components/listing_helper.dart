import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:flutter/material.dart';

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

        Positioned(
          top: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<int>.generate(spacesWithImage.length, (int index) => index + 1).asMap().map(
                      (index, e) => MapEntry(index,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          height: 6,
                          // width: ((MediaQuery.of(context).size.width ~/ reservations.length) * 0.75).toDouble(),
                          decoration: BoxDecoration(
                              color: (index == currentPageIndex) ? model.paletteColor : model.paletteColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                      ),
                    ),
                  )
              ).values.toList(),
            ),
          ),
        )
      ],
    ),
  );
}