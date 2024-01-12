import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:flutter/material.dart';


String? getImageFromSelectedReservationActivity(ActivityManagerForm? activityManagerForm, ReservationItem? reservationItem, ListingManagerForm? listingForm) {
  late String currentImageForRes;

  if (activityManagerForm != null) {
    if (activityManagerForm.profileService.activityBackground.activityProfileImages?.isNotEmpty == true)  {
      return activityManagerForm.profileService.activityBackground.activityProfileImages?.first.uriPath;
    }
  }

  if (listingForm != null && reservationItem != null) {
    if (retrieveReservationSpacesFromListing(reservationItem, listingForm).where((element) => element.spacePhoto != null).isNotEmpty) {
      return retrieveReservationSpacesFromListing(reservationItem, listingForm).firstWhere((element) => element.spacePhoto != null).photoUri;
    }
  }

  return null;
}


List<String>? getImageFromCurrentReservations(BuildContext context, List<ReservationItem> reservations, List<ActivityManagerForm> activities) {

  final List<String> imageList = [];


  for (ReservationItem reservationItem in reservations) {

      /// add activity
        if (activities.where((element) => element.activityFormId == reservationItem.reservationId).isNotEmpty) {
          final ActivityManagerForm activity = activities.where((element) => element.activityFormId == reservationItem.reservationId).first;
          if (activity.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) {
            imageList.add(activity.profileService.activityBackground.activityProfileImages?[0].uriPath ?? '');
          } else {
            imageList.add('');
        }
      } else {
          imageList.add('');
      }
    }

  return imageList;

}