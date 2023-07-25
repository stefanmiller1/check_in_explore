import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

class ReservationHelperCore {

  static ReservationItem? selectedReservationItem;
  static ActivityManagerForm? currentActivityForm;
  static ListingManagerForm? currentListingManagerForm;
  static UserProfileModel? currentUserProfile;
  static bool isLoading = false;
  static bool didPresentSidePanel = false;

  static SettingsItemModel currentSettingsItemModel = subActivitySettingItems(null)[0];

}