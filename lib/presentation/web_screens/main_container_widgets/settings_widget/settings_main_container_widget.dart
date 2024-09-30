import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/settings_web/settings_screen_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final ProfileSettingMarker? currentMarker;
  final UserProfileModel? currentUser;
  final Function() didRebuild;

  const SettingsMainContainerWidget({super.key, required this.model, this.currentUser, required this.currentMarker, required this.didRebuild});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child:  (currentMarker != null) ? ProfileSettingsScreenWeb(
          userProfileModel: currentUser!,
          model: model,
          currentNavItem: currentMarker,
          rebuild: () {
            didRebuild();
          },
      ) : Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.settings, color: model.disabledTextColor, size: 85),
            const SizedBox(height: 10),
            Text('Your Settings', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 10),
            Text('Select any Options from the list to get the conversation started', style: TextStyle(color: model.disabledTextColor)),
          ],
        ),
      ),
    );
  }

}