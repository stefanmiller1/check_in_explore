import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/src/provider.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';


class ActivityRequirementEventProvided extends StatelessWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityRequirementEventProvided({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityCreatorForm))),
      child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
      listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
      listener: (context, state) {

      },
      buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityCreatorForm != c.activityCreatorForm,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: model.paletteColor,
            title: Text('On The House', style: TextStyle(color: model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
          padding: const EdgeInsets.all(18.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(AppLocalizations.of(context)!.activityRequirementsCoveredTitle, style: TextStyle(fontWeight: FontWeight.bold, color: model.paletteColor, fontSize: model.questionTitleFontSize)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: model.paletteColor)),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                        SizedBox(height: 10),
                        Container(
                            height: 120,
                            width: 120,
                            child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                        SizedBox(height: 18),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isEquipmentProvided ?? false),
                          onToggle: (value) {

                            if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isEquipmentProvided ?? false) {
                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isEquipmentProvidedChanged(false));
                            } else {
                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isEquipmentProvidedChanged(true));
                            }

                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.activityRequirementEventAlcohol, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                        SizedBox(height: 10),
                        Container(
                            height: 120,
                            width: 120,
                            child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Alcohol.png', color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                        SizedBox(height: 18),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholProvided ?? false),
                          onToggle: (value) {

                            if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isAlcoholProvided ?? false) {
                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(false));
                            } else {
                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(true));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ]
                  ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.activityRequirementEventFoodOrDrink, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center),
                        SizedBox(height: 25),
                        Container(
                            height: 90,
                            width: 120,
                            child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Food_Drinks.png', color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                        SizedBox(height: 40),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodProvided ?? false),
                          onToggle: (value) {

                            if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isFoodProvided ?? false) {
                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(false));
                            } else {
                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(true));
                            }

                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Security', style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isSecurityProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center,),
                        SizedBox(height: 15),
                        Container(
                            height: 120,
                            width: 120,
                            child: Center(child: Icon(Icons.lock, size: 55, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isSecurityProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45)))),
                        SizedBox(height: 18),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isSecurityProvided ?? false),
                          onToggle: (value) {
                                if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isSecurityProvided ?? false) {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSecurityProvidedChanged(false));
                                } else {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSecurityProvidedChanged(true));
                                }
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ]
              )
            ),
        );
        }
      )
    );
  }
}