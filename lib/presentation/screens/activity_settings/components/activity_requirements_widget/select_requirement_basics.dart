import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';


class ActivitySelectRequirementsBasics extends StatefulWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivitySelectRequirementsBasics({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  State<ActivitySelectRequirementsBasics> createState() => _ActivitySelectRequirementsBasicsState();
}

class _ActivitySelectRequirementsBasicsState extends State<ActivitySelectRequirementsBasics> {


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
            title: Text('Expectations', style: TextStyle(color: widget.model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(AppLocalizations.of(context)!.activityRequirementAgeTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context)!.activityFacilityRequirementAgeSubTitle(''), style: TextStyle(color: widget.model.paletteColor)),
                  ),
                  const SizedBox(height: 20),

                  RadioListTile(
                    toggleable: true,
                    value: 'Under18',
                    groupValue: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isSeventeenAndUnder ? 'Under18' : null,
                    onChanged: (String? value) {

                      if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isSeventeenAndUnder) {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(false));
                      } else {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(true));
                      }

                    },
                    activeColor: widget.model.paletteColor,
                    title: Text(AppLocalizations.of(context)!.activityRequirementAgeSeventeenUnder, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  ),


                  Visibility(
                    visible: !context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isSeventeenAndUnder,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: widget.model.accentColor,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            height: 35,
                            width: 60,
                            child: Center(
                              child: Text(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.minimumAgeRequirement.toString(), style: TextStyle(color: widget.model.disabledTextColor)
                            ),
                          )
                        ),
                        QuantityButtons(
                            model: widget.model,
                            initNumber: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.minimumAgeRequirement,
                            counterCallback: (int v) {

                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.minimumAgeChanged(v));

                          }
                        ),
                        Text(AppLocalizations.of(context)!.activityAllowedBelowAge,
                            style: TextStyle(
                                color: widget.model.paletteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Divider(
                      thickness: 0.35,
                      color: widget.model.paletteColor,
                    ),
                  ),


                  Visibility(
                      visible: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activity != ProfileActivityOption.events),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(AppLocalizations.of(context)!.activityRequirementPreferences, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGender, style: TextStyle(color: widget.model.paletteColor)),
                          ),

                          RadioListTile(
                            toggleable: true,
                            value: 'MenOnly',
                            groupValue: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isMensOnly ?? false) ? 'MenOnly' : null,
                            onChanged: (String? value) {

                              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isMensOnly ?? false) {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));

                              } else {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(true));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
                              }

                            },
                            activeColor: widget.model.paletteColor,
                            title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderMen, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          ),

                          RadioListTile(
                            toggleable: true,
                            value: 'WomenOnly',
                            groupValue: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isWomenOnly ?? false) ? 'WomenOnly' : null,
                            onChanged: (String? value) {

                              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isWomenOnly ?? false) {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));

                              } else {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(true));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
                              }

                            },
                            activeColor: widget.model.paletteColor,
                            title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderWomen, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          ),

                          RadioListTile(
                            toggleable: true,
                            value: 'CoedOnly',
                            groupValue: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isCoEdOnly ?? false) ? 'CoedOnly' : null,
                            onChanged: (String? value) {

                              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isCoEdOnly ?? false) {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));

                              } else {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(true));
                              }

                            },
                            activeColor: widget.model.paletteColor,
                            title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderCoed, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          ),

                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesSkillsExpected, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: widget.model.accentColor,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(AppLocalizations.of(context)!.facilitiesSelectMulti, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                              decoration: BoxDecoration(
                                  color: widget.model.accentColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: Border(
                                      top: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
                                      left: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
                                      right: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
                                      bottom: BorderSide(width: 0.5, color: widget.model.disabledTextColor)
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: SkillLevel.values.map(
                                      (e) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                        width: 500,
                                        height: 40,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                                  return widget.model.paletteColor.withOpacity(0.1);
                                                }
                                                if (states.contains(MaterialState.hovered)) {
                                                  return (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.contains(e) ?? false) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.1);
                                                }
                                                return (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.contains(e) ?? false) ? widget.model.paletteColor : Colors.transparent; // Use the component's default.
                                              },
                                            ),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                )
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {

                                              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.contains(e) ?? false) {
                                                context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.remove(e);
                                              } else {
                                                context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.add(e);
                                              }

                                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.skillLevelExpectationChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation ?? []));
                                            });
                                          },
                                          child: Text(getSkillTypeName(context, e), style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.contains(e) ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.skillLevelExpectation?.contains(e) ?? false) ? FontWeight.bold : FontWeight.normal)),
                                    )
                                  ),
                                ),
                              ).toList(),
                            )
                          ),
                          const SizedBox(height: 30),
                        ],
                      )
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