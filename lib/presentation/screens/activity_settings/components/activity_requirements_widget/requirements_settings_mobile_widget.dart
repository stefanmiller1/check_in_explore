import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_access_visibility_widgets/access_visibility_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/requirements_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_settings_mobile_container.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/src/provider.dart';
import 'package:dartz/dartz.dart' as dart;

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequirementsSettingsMobileEditor extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final ActivityManagerForm activityManagerForm;
  final UserProfileModel activityOwner;
  final ReservationItem reservation;
  final Function() didSave;

  const RequirementsSettingsMobileEditor({super.key, required this.model, required this.activityManagerForm, required this.reservation, required this.didSave, required this.activityOwner, required this.currentUser});

  @override
  State<RequirementsSettingsMobileEditor> createState() => _RequirementsSettingsMobileEditorState();
}

class _RequirementsSettingsMobileEditorState extends State<RequirementsSettingsMobileEditor> {

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
                      RequirementSettingsWidget(
                        model: widget.model,
                        currentUser: widget.currentUser,
                        activityManagerForm: widget.activityManagerForm,
                        reservationItem: widget.reservation,
                        activityOwner: widget.activityOwner,
                      ),
                      isSavingWidget(context, widget.model, state)
                    ],
                  )
              );
            }
        )
    );
  }
}