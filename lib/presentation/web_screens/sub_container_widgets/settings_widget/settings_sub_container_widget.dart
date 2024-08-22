import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/profile_core_widgets/profile_settings/profile_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';

class SettingsSubContainer extends StatelessWidget {

  final DashboardModel model;
  final UserProfileModel? currentUser;
  final Function() rebuild;
  final Function(ProfileSettingMarker navItem) didSelectItem;

  const SettingsSubContainer({super.key, required this.model, this.currentUser, required this.didSelectItem, required this.rebuild});

  @override
  Widget build(BuildContext context) {
      if (currentUser != null) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                ProfileSettingsScreen(
                    model: model,
                    isActivityApp: false,
                    currentSettingsMarker: ReservationHelperCore.currentProfileSettingsMarker,
                    didSelectLogOut: () {
                      rebuild();
                    },
                    didDeleteAccount: () {
                      rebuild();
                    },
                    isWeb: true,
                    didSelectNav: (nav) {
                      didSelectItem(nav);
                  }
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height,
      );
    }
  }



}