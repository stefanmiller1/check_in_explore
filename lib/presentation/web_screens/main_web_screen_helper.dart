import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

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