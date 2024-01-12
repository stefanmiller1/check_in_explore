import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/src/provider.dart';
import 'package:dartz/dartz.dart' as dart;

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ActivitySettingsMobileEditor extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final UserProfileModel activityOwner;
  final ReservationItem reservation;
  final Widget mainSettingsWidget;
  final Function() didSave;

  const ActivitySettingsMobileEditor({super.key, required this.model, required this.activityManagerForm, required this.reservation, required this.didSave, required this.mainSettingsWidget, required this.activityOwner});

  @override
  State<ActivitySettingsMobileEditor> createState() => _ActivitySettingsMobileEditorState();
}

class _ActivitySettingsMobileEditorState extends State<ActivitySettingsMobileEditor> {
 
  @override
  void initState() {
    super.initState();
  }
  
  void updateState(BuildContext context) {
    context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(true));
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(false));
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
        child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
            listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.isSaving != c.isSaving || p.activitySettingsForm != c.activitySettingsForm,
            listener: (context, state) {

              /// handle saving errors & success options
              state.authFailureOrSuccessOptionSaving.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              activityServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              unexpected: (e) => Text('Uh Oh. Something un-expected happened', style: TextStyle(color: widget.model.disabledTextColor)),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {

                    Navigator.of(context).pop();
                    widget.didSave();
                  }
                )
              );
            },
            buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages || p.isSaving != c.isSaving || p.isEditingForm != c.isEditingForm || p.activitySettingsForm != c.activitySettingsForm,
            builder: (context, state) {

              return Scaffold(
                  appBar: scaffoldHeaderWidget(
                    context,
                    widget.model,
                    state,
                    didPressPreview: () {

                    }
                  ),
                  body: Stack(
                    children: [
                      widget.mainSettingsWidget,
                      isSavingWidget(context, widget.model, state)
              ],
            )
          );
        }
      )
    );
  }
}


Widget isSavingWidget(BuildContext context, DashboardModel model, UpdateActivityFormState state) {
  return Stack(
    children: [
      if (state.isSaving) Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: model.accentColor,
      ),
      if (state.isSaving) Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            JumpingDots(color: model.paletteColor, radius: 15, numberOfDots: 3),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.saving, style: TextStyle(color: model.disabledTextColor)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ]
  );
}


PreferredSizeWidget scaffoldHeaderWidget(BuildContext context, DashboardModel model, UpdateActivityFormState state, {required Function() didPressPreview}) {
  return AppBar(
    elevation: 0,
    backgroundColor: model.paletteColor,
    centerTitle: true,
    title: Text('Activity Profile', style: TextStyle(color: model.accentColor)),
    actions: [
      IconButton(onPressed: () {
        didPressPreview();
      },
          icon: Icon(Icons.remove_red_eye_outlined, color: model.accentColor),
          padding: EdgeInsets.zero
      ),
      const SizedBox(width: 10),
      /// preview
      /// update..at bottom
      if (!(state.isSaving)) InkWell(
        onTap: () {
          if (state.isEditingForm) {
            context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.createActivityFinished());
          }
        },
        child: Center(child: Text('Save', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: (state.isEditingForm) ? model.accentColor : model.disabledTextColor.withOpacity(0.4), fontWeight: FontWeight.bold))),
      )
    ],
  );
}