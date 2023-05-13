import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityRequirementEventBasics extends StatelessWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityRequirementEventBasics({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityCreatorForm))),
      child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
        listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
          listener: (context, state) {

          },
          buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityCreatorForm != c.activityCreatorForm,
          builder: (context, state) {
            bool activityAgeSetting = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.minimumAgeRequirement >= 18 && !context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isSeventeenAndUnder;

            return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: model.paletteColor,
            title: Text('Special Requirements', style: TextStyle(color: model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(AppLocalizations.of(context)!.activityRequirementEventAlcoholTitle, style: TextStyle(fontWeight: FontWeight.bold, color: (activityAgeSetting) ? model.paletteColor : model.disabledTextColor.withOpacity(0.6), fontSize: model.questionTitleFontSize)),
                    ),
                    Visibility(
                      visible: !activityAgeSetting,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(AppLocalizations.of(context)!.activityFacilityRequirementEventAge, style: TextStyle(color: model.disabledTextColor)),
                      ),
                    ),


                    IgnorePointer(
                      ignoring: !activityAgeSetting,
                      child: RadioListTile(
                        toggleable: true,
                        value: 'Yes',
                        groupValue: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholForSale ?? false) ? 'Yes' : null,
                        onChanged: (String? value) {

                          if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholForSale ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(true));
                          }

                        },
                        activeColor: (activityAgeSetting) ? model.paletteColor : model.disabledTextColor.withOpacity(0.6),
                        title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNeeded, style: TextStyle(color: (activityAgeSetting) ? model.paletteColor : model.disabledTextColor.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    ),

                    IgnorePointer(
                      ignoring: !activityAgeSetting,
                      child: RadioListTile(
                        toggleable: true,
                        value: 'No',
                        groupValue: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholForSale ?? false) ? 'No' : null,
                        onChanged: (String? value) {

                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(false));

                        },
                        activeColor: (activityAgeSetting) ? model.paletteColor : model.disabledTextColor.withOpacity(0.6),
                        title: Text(AppLocalizations.of(context)!.activityRequirementEventPreferencesNo, style: TextStyle(color: (activityAgeSetting) ? model.paletteColor : model.disabledTextColor.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    ),

                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(AppLocalizations.of(context)!.activityRequirementEventFoodTitle, style: TextStyle(fontWeight: FontWeight.bold, color: model.paletteColor, fontSize: model.questionTitleFontSize)),
                    ),

                    RadioListTile(
                      toggleable: true,
                      value: 'Yes',
                      groupValue: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodForSale ?? false) ? 'Yes' : null,
                      onChanged: (String? value) {

                        if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodForSale ?? false) {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(false));
                        } else {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(true));
                        }

                      },
                      activeColor: model.paletteColor,
                      title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNeeded, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                    ),
                    RadioListTile(
                      toggleable: true,
                      value: 'No',
                      groupValue: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodForSale ?? false) ? 'No' : null,
                      onChanged: (String? value) {

                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(false));

                      },
                      activeColor: model.paletteColor,
                      title: Text(AppLocalizations.of(context)!.activityRequirementEventPreferencesNo, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                  ),
                ]
              )
            ),
        );
        }
      )
    );
  }
}