import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_widget/add_activity_background_info.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_widget/add_activity_class_accolades_background_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityBackgroundPreview extends StatelessWidget {

  final DashboardModel model;

  const ActivityBackgroundPreview({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        InkWell(
          onTap: () {

          },
          child: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityProfileImages != null && context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityProfileImages!.isNotEmpty) ? AvatarStack(
            avatars: [

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
                  return ActivityAddBackgroundInfo(
                    model: model,
                    activityCreatorForm: context.read<UpdateActivityFormBloc>().state.activityCreatorForm,
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
              Text(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityTitle.value.fold((l) => 'Add a Title', (r) => r)),
              Text(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityDescription1.value.fold((l) => 'Add a Description', (r) => r)),
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

  const ActivityClassBackgroundPreview({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return ActivityAddClassBackgroundInfo(
                    model: model,
                    activityCreatorForm: context.read<UpdateActivityFormBloc>().state.activityCreatorForm,
                  );
                })
            );
          },
          leading: Icon(Icons.menu_book, color: model.paletteColor,),
          title: const Text('Details About Instructor'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// class contact detail item
              Row(
                children: [
                  Text('years of experience: '),
                  Text(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground?.numberOfYearsInExperience.toString() ?? '0'),
                ],
              ),
              /// add certificates
              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground?.certificates != null && context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground!.certificates.isNotEmpty) Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text('Certificates:'),
                  const SizedBox(height: 8),
                  ...context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground!.certificates.map(
                          (e) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: model.accentColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.certificateTitle.value.fold((l) => 'Add Certificate Title', (r) => r)),
                                  Text(getCertificateName(context, e.certificateType), style: TextStyle(color: model.disabledTextColor)),
                                ],
                              ),
                              Text(DateFormat.yMMM().format(e.dateReceived), style: TextStyle(color: model.disabledTextColor))
                            ],
                          ),
                        ),
                      )
                  ).toList(),
                ],
              ),
              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground?.certificates == null || context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground!.certificates.isEmpty) const Text('Add Your Certificates'),
              /// add experience

              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground?.experience != null && context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground!.experience.isNotEmpty) Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text('Experience:'),
                  const SizedBox(height: 8),
                  ...context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground!.experience.map(
                          (e) => Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: model.accentColor
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(e.experienceTitle.value.fold((l) => 'Add Experience', (r) => r)),
                                  Text('${DateFormat.y().format(e.experiencePeriod.start)} - ${DateFormat.y().format(e.experiencePeriod.end)}', style: TextStyle(color: model.disabledTextColor)),
                          ],
                        ),
                      ),
                    )
                  ).toList(),
                ],
              ),

              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground?.experience == null || context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.classActivityBackground!.experience.isEmpty) const Text('Add Your Experience')


            ],
          ),
      trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
    );
  }
}
