import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

enum ListingOverviewMarker {listing, activities}
enum FacilityPreviewState {listing, reservation}



Widget loadingListingProfile(ListingManagerForm listing) {
  return Container();
}

Widget couldNotRetrieveListingProfile() {
  return Container(
    child: Center(
      child: Text('This Activity Might be Over!'),
    )
  );
}

Widget loadingConfirmReservation() {
  return Container();
}

String getAppBarTitle(ReservationMobileCreateNewMarker state, String listingName,) {
  switch (state) {
    case ReservationMobileCreateNewMarker.listingDetails:
      return listingName;
    case ReservationMobileCreateNewMarker.additionalDetails:
      return 'More Details';
    case ReservationMobileCreateNewMarker.paymentReview:
      return 'Confirm & Pay';
    case ReservationMobileCreateNewMarker.listingNoLongerAvailable:
      return 'Listing Unavailable';
  }
}

/// be the first to review
Widget couldNotRetrieveReviews(BuildContext context, DashboardModel model) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
            color: model.accentColor,
            border: Border.all(color: model.paletteColor, width: 0.25),
            borderRadius: BorderRadius.circular(18)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [0,1,2,3,5].map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: Container(
                      height: 24,
                      child: Row(
                        children: [
                          SizedBox(width: 170),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 10,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: model.paletteColor, width: 0.5)
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),

                        ],
                      ),
                    ),
                  )
                ).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[1,2.7,1.4,4.55,1.2].map((e) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 120,
                            decoration: BoxDecoration(
                                color: model.paletteColor.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 10,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: model.disabledTextColor.withOpacity(0.75),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 80 / e),
                                  Container(
                                    child: Icon(Icons.star, color: model.paletteColor),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ).toList()
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 12),
      Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: model.paletteColor, width: 0.5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Be The First to Leave a Review', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))),
        ),
      )
    ],
  );
}

