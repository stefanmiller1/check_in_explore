import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dart;

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityAddMoreBackgroundInfoWidget extends StatefulWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityAddMoreBackgroundInfoWidget({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  State<ActivityAddMoreBackgroundInfoWidget> createState() => _ActivityAddMoreBackgroundInfoWidgetState();
}

class _ActivityAddMoreBackgroundInfoWidgetState extends State<ActivityAddMoreBackgroundInfoWidget> {

  TextEditingController? activityDescriptionController2;
  TextEditingController? activityDescriptionController3;

  @override
  void initState() {
    activityDescriptionController2 = TextEditingController();
    activityDescriptionController3 = TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    activityDescriptionController2?.dispose();
    activityDescriptionController3?.dispose();
    super.dispose();
  }

  void rebuild(BuildContext context) {

    if (activityDescriptionController2!.text != context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityDescription2?.value.fold(
            (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f?.maybeMap(maxCharacterLength: (e) => e.failedValue ?? '', isEmpty: (e) => e.failedValue ?? '', invalidFacilityName: (e) => e.failedValue ?? '', orElse: () => ''), orElse: () => ''),
            (r) => r)) {
      activityDescriptionController2!.text = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityDescription2?.value.fold(
              (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f?.maybeMap(maxCharacterLength: (e) => e.failedValue ?? '', isEmpty: (e) => e.failedValue ?? '', invalidFacilityName: (e) => e.failedValue ?? '', orElse: () => ''), orElse: () => ''),
              (r) => r) ?? '';
    }

  }


  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityCreatorForm))),
      child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
      listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
      listener: (context, state) {

      },
      buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityCreatorForm != c.activityCreatorForm,
    builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: widget.model.paletteColor,
            title: Text('More to Know...', style: TextStyle(color: widget.model.accentColor)),
            actions: [

            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.facilityBackgroundTellMore, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                    SizedBox(height: 5),
                    Text(AppLocalizations.of(context)!.activityBackgroundSubTitle3, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    Text(AppLocalizations.of(context)!.activityExperienceBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
                    SizedBox(height: 10),

                    getDescriptionTextField(
                        context,
                        widget.model,
                        activityDescriptionController2!,
                        '',
                        10,
                        context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityDescription2?.maxLength,
                        updateText: (value) {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.activityDescriptionChangedTwo(BackgroundInfoDescription(value)));
                        }
                    ),

                    SizedBox(height: 25),
                    Visibility(
                      visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.activityClassesBackgroundTitle3, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          SizedBox(height: 10),
                          ...context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityGoals?.asMap().map((i, e) {

                            TextEditingController goalsDescriptionController = TextEditingController();

                            return MapEntry(i, getDescriptionTextField(
                                context,
                                widget.model,
                                goalsDescriptionController,
                                '',
                                10,
                                350,
                                updateText: (value) {
                                  setState(() {
                                    context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityGoals?[i] = BackgroundInfoDescription(value);
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.activityGoalsChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityGoals ?? []));
                                  });
                                })
                            );
                          }).values.toList() ?? [],

                          Visibility(
                            visible: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityGoals?.length ?? 1) < 5,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add_circle_outline_rounded, size: 45, color: widget.model.paletteColor),
                                onPressed: () {
                                  setState(() {
                                    context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityGoals?.add(BackgroundInfoDescription(''));
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.activityGoalsChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityGoals ?? []));
                                  });
                                }
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Visibility(
                    //     visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                    //     child: Column(
                    //       children: [
                    //         Text(AppLocalizations.of(context)!.activityGameBackgroundTitle4, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    //         SizedBox(height: 10),
                    //         ...context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityBackground.activityInterests?.map(
                    //                 (e) => Container()
                    //         ).toList() ?? []
                    //     ],
                    //   )
                    // )

                    // getDescriptionTextField(
                    //     context,
                    //     widget.model,
                    //     activityDescriptionController3!,
                    //     '',
                    //     10,
                    //     context.read<UpdateActivityFormBloc>().state.facilityCreatorForm.facilityBackground.rentalDescription3?.maxLength,
                    //     updateText: (value) {
                    //       context.read<UpdateActivityFormBloc>()..add(UpdateFacilityFormEvent.rentalDescription3Changed(value));
                    //     }
                    // ),
                    ],
                  ),
                ),
              ),
            ),
        );
        }
      )
    );
  }
}