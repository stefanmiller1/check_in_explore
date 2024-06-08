import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_attendee_settings_sub_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_owner_settings_sub_container_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';

class ActivitySubSettingsContainer extends StatelessWidget {

  final DashboardModel model;
  final UserProfileModel? currentUser;
  final SettingsItemModel currentSelectedSettingItem;
  final ReservationItem? currentReservationItem;
  final ActivityManagerForm? currentActivityManagerForm;
  final AttendeeItem? currentAttendee;
  final Function(SettingsItemModel navItem) didSelectNavItem;

  const ActivitySubSettingsContainer({super.key, required this.model, required this.currentSelectedSettingItem, this.currentReservationItem, this.currentActivityManagerForm, required this.didSelectNavItem, required this.currentUser, this.currentAttendee});

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
    } else if (currentReservationItem != null) {
      return AttendeeSettingsListContainer(
        model: model,
        currentSelectedSettingItem: currentSelectedSettingItem,
        didSelectNavItem: (selectedNav) => didSelectNavItem(selectedNav),
        currentReservationItem: currentReservationItem!,
        currentActivityManagerForm: currentActivityManagerForm,
        currentAttendee: currentAttendee,
      );
    } else {
      return Container();
    }
  }
}