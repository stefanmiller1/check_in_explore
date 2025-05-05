import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

bool showTopNavBar(DashboardMarker marker) => marker == DashboardMarker.resSettings || marker == DashboardMarker.settings || marker == DashboardMarker.reservations || marker == DashboardMarker.profile;

String? getImageFromSelectedReservationActivity(ActivityManagerForm? activityManagerForm, ReservationItem? reservationItem, ListingManagerForm? listingForm) {
  late String currentImageForRes;

  if (activityManagerForm != null) {
    if (activityManagerForm.profileService.activityBackground.activityProfileImages?.isNotEmpty == true)  {
      return activityManagerForm.profileService.activityBackground.activityProfileImages?.first.uriPath;
    }
  }

  if (listingForm != null && reservationItem != null) {
    if (retrieveReservationSpacesFromListing(reservationItem, listingForm).where((element) => element.photoUri != null).isNotEmpty) {
      return retrieveReservationSpacesFromListing(reservationItem, listingForm).firstWhere((element) => element.photoUri != null).photoUri;
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