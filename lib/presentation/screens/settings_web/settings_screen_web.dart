import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/profile_core_widgets/profile_settings/components/notifications_profile.dart';
import 'package:check_in_presentation/profile_core_widgets/profile_settings/components/payments_payouts_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';

class ProfileSettingsScreenWeb extends StatelessWidget {

  final DashboardModel model;
  final UserProfileModel userProfileModel;
  final ProfileSettingMarker? currentNavItem;
  final Function() rebuild;

  const ProfileSettingsScreenWeb({super.key, required this.model, required this.userProfileModel, required this.rebuild, this.currentNavItem});


  Widget getMainSettingsContainer(BuildContext context, ProfileSettingMarker? navItem, UserProfileModel userProfileModel) {

    switch (navItem) {
      case ProfileSettingMarker.personalIno:
        return PersonalInformationProfile(
          model: model,
          profile: userProfileModel,
          didDeleteAccount: () {
            rebuild();
          },
        );
      case ProfileSettingMarker.payments:
        return PaymentsPayoutsProfile(
          model: model,
          isActivityVersion: false,
          profile: userProfileModel,
        );
      case ProfileSettingMarker.notification:
        return NotificationProfile(
            model: model
        );
      case ProfileSettingMarker.privacy:
        // TODO: Handle this case.
      case ProfileSettingMarker.switchToHosting:
        // TODO: Handle this case.
      case ProfileSettingMarker.listSpace:
        // TODO: Handle this case.
      case ProfileSettingMarker.listActivity:
        // TODO: Handle this case.
      case ProfileSettingMarker.manageSpace:
        // TODO: Handle this case.
      case ProfileSettingMarker.howWorks:
        // TODO: Handle this case.
      case ProfileSettingMarker.getHelp:
        // TODO: Handle this case.
      case ProfileSettingMarker.giveFeedback:
        // TODO: Handle this case.
      case ProfileSettingMarker.termsOfService:
        // TODO: Handle this case.
      case ProfileSettingMarker.privacyPolicy:
        // TODO: Handle this case.
      default:
        return Container();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        getMainSettingsContainer(
            context,
            currentNavItem,
            userProfileModel
        ),
      ],
    );
  }

}