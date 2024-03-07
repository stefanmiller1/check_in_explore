import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


Widget getPaymentHistoryItemWidget(BuildContext context, DashboardModel model, PaymentIntent paymentIntent, ListingManagerForm listing, ReservationItem reservationItem, {required Function(PaymentIntent) didSelectPayment}) {

  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
            didSelectPayment(paymentIntent);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Row(
                        children: [
                          if (listing.listingProfileService.spaceSetting.spaceTypes.getOrCrash().where((element) => element.quantity.where((element) => element.photoUri != null).isNotEmpty).first.quantity.first.spacePhoto?.image != null) Container(
                            height: 75,
                            width: 75,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(image: listing.listingProfileService.spaceSetting.spaceTypes.getOrCrash().first.quantity.first.spacePhoto!.image, fit: BoxFit.cover),
                            ),
                          ),
                          if (listing.listingProfileService.spaceSetting.spaceTypes.getOrCrash().where((element) => element.quantity.where((element) => element.photoUri != null).isEmpty).isNotEmpty) getActivityTypeTabOption(
                              context,
                              model,
                              100,
                              false,
                              getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                          ),
                          const SizedBox(width: 10),
                          if (paymentIntent.payment_method != null) Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Paid - ${DateFormat.y().format(reservationItem.dateCreated)}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SvgPicture.asset(getCardIconItem().where((element) => element.contains(paymentIntent.payment_method!.cardDetails.brand)).isNotEmpty ? getCardIconItem().where((element) => element.contains(paymentIntent.payment_method!.cardDetails.brand)).first : 'assets/payment_icons/discover.svg', fit: BoxFit.fitHeight, color: model.disabledTextColor, height: 15),
                                  const SizedBox(width: 5),
                                  Text('${paymentIntent.payment_method!.cardDetails.brand} **** ${paymentIntent.payment_method!.cardDetails.lastFourNumbers}', style: TextStyle(color: model.disabledTextColor, ),),
                                  const SizedBox(width: 5),
                                  Text('${paymentIntent.payment_method!.cardDetails.expiryYearDate}', style: TextStyle(color: model.disabledTextColor)),
                                ],
                              ),
                              Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.disabledTextColor)),
                            ],
                          ),

                        ],
                      ),
                    ),


                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                           Text(reservationItem.reservationCost.substring(0, reservationItem.reservationCost.length - 4), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                           if (paymentIntent.currency != null) Text(paymentIntent.currency!.toUpperCase(), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      ],
                    ),
                  ],
                ),
              )
          ),
        ),
      )
  );
}
