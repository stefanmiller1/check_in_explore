import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:dartz/dartz.dart' as dart;

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

class ActivityAddBackgroundInfo extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivityAddBackgroundInfo({super.key, required this.model, required this.activityManagerForm, required this.reservation});

  @override
  State<ActivityAddBackgroundInfo> createState() => _ActivityAddBackgroundInfoState();
}

class _ActivityAddBackgroundInfoState extends State<ActivityAddBackgroundInfo> {

    TextEditingController? activityTitleController;
    TextEditingController? activityDescriptionController1;


    @override
    void initState() {
      activityTitleController = TextEditingController();
      activityDescriptionController1 = TextEditingController();
      super.initState();
    }

    @override
    void dispose() {
      activityTitleController?.dispose();
      activityDescriptionController1?.dispose();
      super.dispose();
    }

    // void rebuild(BuildContext context) {
    //
    //
    //   if (activityTitleController!.text != context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityTitle.value.fold(
    //           (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f!.maybeMap(maxCharacterLength: (e) => e.failedValue ?? '', isEmpty: (e) => e.failedValue ?? '', invalidFacilityName: (e) => e.failedValue ?? '', orElse: () => ''), orElse: () => ''),
    //           (r) => r)) {
    //     activityTitleController!.text = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityTitle.value.fold(
    //             (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f!.maybeMap(maxCharacterLength: (e) => e.failedValue ?? '', isEmpty: (e) => e.failedValue ?? '', invalidFacilityName: (e) => e.failedValue ?? '', orElse: () => ''), orElse: () => ''),
    //             (r) => r);
    //   }
    //
    //   if (activityDescriptionController1!.text != context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityDescription1.value.fold(
    //           (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f!.maybeMap(maxCharacterLength: (e) => e.failedValue ?? '', isEmpty: (e) => e.failedValue ?? '', invalidFacilityName: (e) => e.failedValue ?? '', orElse: () => ''), orElse: () => ''),
    //           (r) => r)) {
    //     activityDescriptionController1!.text = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityDescription1.value.fold(
    //             (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f!.maybeMap(maxCharacterLength: (e) => e.failedValue ?? '', isEmpty: (e) => e.failedValue ?? '', invalidFacilityName: (e) => e.failedValue ?? '', orElse: () => ''), orElse: () => ''),
    //             (r) => r);
    //   }
    //
    // }

    @override
    Widget build(BuildContext context) {

      return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
            child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
            listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
              listener: (context, state) {

              },
          buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
          builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: widget.model.paletteColor,
                  title: Text('Add a Title & Description', style: TextStyle(color: widget.model.accentColor)),
                  actions: [

                  ],
                ),
                body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.activityBackgroundTitle, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                          const SizedBox(height: 5),
                          Text(AppLocalizations.of(context)!.activityBackgroundSubTitle, style: TextStyle(color: widget.model.paletteColor)),
                          const SizedBox(height: 20),
                          getDescriptionTextField(
                              context,
                              widget.model,
                              activityTitleController!,
                              '',
                              1,
                              context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityTitle.maxLength,
                              updateText: (value) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTitleChanged(BackgroundInfoTitle(value)));
                            }
                          ),


                          Visibility(
                            visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Text(AppLocalizations.of(context)!.activityClassesBackgroundTitle2, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                                Text(AppLocalizations.of(context)!.activityClassesBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
                              ],
                            ),
                          ),

                          Visibility(
                            visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityTypeOption.experiences,
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Text(AppLocalizations.of(context)!.activityExperienceBackgroundTitle2, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                                Text(AppLocalizations.of(context)!.activityExperienceBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
                              ],
                            ),
                          ),

                          Visibility(
                            visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Text(AppLocalizations.of(context)!.activityGameBackgroundTitle2, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                                Text(AppLocalizations.of(context)!.activityGameBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),
                          getDescriptionTextField(
                              context,
                              widget.model,
                              activityDescriptionController1!,
                              '',
                              6,
                              context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription1.maxLength,
                              updateText: (value) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChanged(BackgroundInfoDescription(value)));
                      }
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}