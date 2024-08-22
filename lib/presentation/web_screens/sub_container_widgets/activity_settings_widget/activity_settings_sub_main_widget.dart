import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_attendee_settings_sub_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_owner_settings_sub_container_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitySubSettingsContainer extends StatelessWidget {

  final DashboardModel model;
  final ReservationItem? initialReservationId;
  final UserProfileModel? currentUser;
  final SettingsItemModel currentSelectedSettingItem;
  // final ReservationItem? currentReservationItem;
  // final ActivityManagerForm? currentActivityManagerForm;
  // final AttendeeItem? currentAttendee;
  final Function(SettingsItemModel navItem) didSelectNavItem;

  const ActivitySubSettingsContainer({super.key, required this.model, required this.didSelectNavItem, required this.currentUser, this.initialReservationId, required this.currentSelectedSettingItem});


  @override
  Widget build(BuildContext context) {
    if (initialReservationId != null) {
      return getSettingsListContainer(initialReservationId!);
    } else {
      return Container();
    }
  }

  Widget getSettingsListContainer(ReservationItem reservation) {
    if (currentUser?.userId == reservation.reservationOwnerId) {
      return OwnerSettingsListContainer(
        model: model,
        currentSelectedSettingItem: currentSelectedSettingItem,
        currentReservationItem: reservation,
        didSelectNavItem: (selectedNav) => didSelectNavItem(selectedNav),
      );
    } else {
      return ManageAttendeeSettingsSubContainer(
        model: model,
        currentSettingItem: currentSelectedSettingItem,
        reservationItem: reservation,
        currentUser: currentUser?.userId.getOrCrash(),
        didSelectNavItem: (selectedNav) => didSelectNavItem(selectedNav),
      );
    }
  }

}