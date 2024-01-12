import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

Widget settingsFailureToLoadContainer(DashboardModel model) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, color: model.disabledTextColor, size: 85),
        const SizedBox(height: 10),
        Text('Sorry, Cannot Change Settings', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
        const SizedBox(height: 10),
        Text('Start your own reservation and be able to setup and change your plans', style: TextStyle(color: model.disabledTextColor)),
      ],
    ),
  );
}