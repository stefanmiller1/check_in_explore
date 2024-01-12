import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_attendee_settings_sub_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_owner_settings_sub_container_widget.dart';
import 'package:flutter/cupertino.dart';

class ActivitySubSettingsContainer extends StatelessWidget {

  final DashboardModel model;
  final UserProfileModel? currentUser;
  final SettingsItemModel currentSelectedSettingItem;
  final ReservationItem? currentReservationItem;
  final ActivityManagerForm? currentActivityManagerForm;
  final Function(SettingsItemModel navItem) didSelectNavItem;

  const ActivitySubSettingsContainer({super.key, required this.model, required this.currentSelectedSettingItem, this.currentReservationItem, this.currentActivityManagerForm, required this.didSelectNavItem, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    if (currentUser?.userId == currentReservationItem?.reservationOwnerId && currentReservationItem != null) {
        return OwnerSettingsListContainer(
            model: model,
            currentSelectedSettingItem: currentSelectedSettingItem,
            didSelectNavItem: (selectedNav) => didSelectNavItem(selectedNav),
            currentReservationItem: currentReservationItem!,
            currentActivityManagerForm: currentActivityManagerForm ?? ActivityManagerForm.empty(),
        );
    } else {
      return AttendeeSettingsListContainer(
        model: model,
        currentSelectedSettingItem: currentSelectedSettingItem,
        didSelectNavItem: (selectedNav) => didSelectNavItem(selectedNav),
        currentReservationItem: currentReservationItem!,
        currentActivityManagerForm: currentActivityManagerForm,
      );
    }
  }
}