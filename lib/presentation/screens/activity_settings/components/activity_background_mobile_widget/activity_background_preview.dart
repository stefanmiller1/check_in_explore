import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_mobile_widget/background_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_settings_mobile_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ActivityBackgroundPreview extends StatelessWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;
  final UserProfileModel currentUser;

  const ActivityBackgroundPreview({super.key, required this.model, required this.reservation, required this.currentUser, required this.activityManagerForm});

  @override
  Widget build(BuildContext context) {

   return Column(
      children: [
        const SizedBox(height: 15),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return ActivitySettingsMobileEditor(
                    model: model,
                    activityManagerForm: activityManagerForm,
                    reservation: reservation,
                    activityOwner: currentUser,
                    mainSettingsWidget: BackgroundInfoSettingsWidget(
                      model: model,
                      currentUser: currentUser,
                      activityManagerForm: activityManagerForm,
                      reservationItem: reservation,
                    ),
                    didSave: () {
                      Navigator.of(context).pop();
                    },
                  );
                })
            );
          },
          child: (activityManagerForm.profileService.activityBackground.activityProfileImages != null && activityManagerForm.profileService.activityBackground.activityProfileImages!.isNotEmpty) ? Column(
            children: [
              Container(
                height: 100,
                width: 180,
                child: AvatarStack(
                    infoWidgetBuilder: (surplus) {
                      return Container(
                        decoration: BoxDecoration(
                            color: model.paletteColor,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: Text('+$surplus', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)),
                        ),
                      );
                    },
                  avatars: activityManagerForm.profileService.activityBackground.activityProfileImages!.map(
                          (e) => Image.network(e.uriPath ?? '').image
                  ).toList()
                ),
              ),
              const SizedBox(height: 12.5),
              Text('Update Activity Images', style: TextStyle(color: model.disabledTextColor))
            ],
          ) : Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: Image.asset('assets/profile-avatar.png').image,
                ),
                const SizedBox(height: 12.5),
                Text('Update Activity Images', style: TextStyle(color: model.disabledTextColor))
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return ActivitySettingsMobileEditor(
                    model: model,
                    activityManagerForm: activityManagerForm,
                    reservation: reservation,
                    activityOwner: currentUser,
                    mainSettingsWidget: BackgroundInfoSettingsWidget(
                      model: model,
                      currentUser: currentUser,
                      activityManagerForm: activityManagerForm,
                      reservationItem: reservation,
                    ),
                    didSave: () {
                      Navigator.of(context).pop();
                    },
                  );
                })
            );
          },
          leading: Icon(Icons.edit, color: model.paletteColor,),
          title: const Text('About the Activity'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activityManagerForm.profileService.activityBackground.activityTitle.value.fold((l) => 'Add a Title', (r) => r)),
              Text(activityManagerForm.profileService.activityBackground.activityDescription1.value.fold((l) => 'Add a Description', (r) => r)),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
        ),
      ],
    );
  }
}

class ActivityClassBackgroundPreview extends StatelessWidget {

  final DashboardModel model;
  final ReservationItem reservation;

  const ActivityClassBackgroundPreview({super.key, required this.model, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (_) {
            //       return ActivityAddClassBackgroundInfo(
            //         model: model,
            //         activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
            //         reservation: reservation,
            //       );
            //     })
            // );
          },
          leading: Icon(Icons.menu_book, color: model.paletteColor,),
          title: const Text('Details About Instructor'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// get all instructors
              // ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.classActivityBackground?.map(
              //         (instructor)  {
              //           return instructorWidgetCard(instructor, context, model);
              //         }
              //       ).toList() ?? [],

              /// class contact detail item

            ],
          ),
      trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
    );
  }
}
