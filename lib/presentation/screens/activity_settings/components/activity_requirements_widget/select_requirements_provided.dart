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

class ActivityRequirementProvided extends StatelessWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityRequirementProvided({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

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
            title: Text('Special Requirements', style: TextStyle(color: model.accentColor)),
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
                    //
                    // Visibility(
                    //   visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.,
                    //   child: Column(
                    //     children: [
                    //
                    //       RadioListTile(
                    //         toggleable: true,
                    //         value: 'Under18',
                    //         groupValue: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isSeventeenAndUnder ? 'Under18' : null,
                    //         onChanged: (String? value) {
                    //
                    //           if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isSeventeenAndUnder) {
                    //             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(false));
                    //           } else {
                    //             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(true));
                    //           }
                    //
                    //         },
                    //         activeColor: model.paletteColor,
                    //         title: Text(AppLocalizations.of(context)!.activityRequirementAgeSeventeenUnder, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    //       ),
                    //     ],
                    //   ),
                    // )

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(AppLocalizations.of(context)!.activityRequirementsCoveredTitle, style: TextStyle(fontWeight: FontWeight.bold, color: model.paletteColor, fontSize: model.questionTitleFontSize)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: model.paletteColor)),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.activityRequirementsCoveredJerseyGear, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isGearProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                              const SizedBox(height: 10),
                              Container(
                                  height: 120,
                                  child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Jersey_Gear.png', color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isGearProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                              const SizedBox(height: 18),
                              FlutterSwitch(
                                width: 60,
                                inactiveColor: model.accentColor,
                                activeColor: model.paletteColor,
                                value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isGearProvided ?? false),
                                onToggle: (value) {

                                  if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isGearProvided ?? false) {
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(false));
                                  } else {
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(true));
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
                              Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                              const SizedBox(height: 10),
                              Container(
                                  height: 120,
                                  child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                              const SizedBox(height: 18),
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
                      ]
                    ),
                    const SizedBox(height: 20),
                        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                          child: Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.activityRequirementsCoveredAnalyticsStandings, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isAnalyticsProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center),
                                const SizedBox(height: 10),
                                Container(
                                    height: 120,
                                    child: Icon(Icons.bar_chart_rounded, size: 110, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isAnalyticsProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45))),
                                const SizedBox(height: 18),
                                FlutterSwitch(
                                  width: 60,
                                  inactiveColor: model.accentColor,
                                  activeColor: model.paletteColor,
                                  value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isAnalyticsProvided ?? false),
                                  onToggle: (value) {

                                    if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isAnalyticsProvided ?? false) {
                                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(false));
                                    } else {
                                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(true));
                                    }

                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      
                    Visibility(
                      visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Officiator/Referees', style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isOfficiatorProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center,),
                            const SizedBox(height: 35),
                            Container(
                                height: 80,
                                width: 120,
                                child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Referee_Officiator.png', color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isOfficiatorProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                            const SizedBox(height: 15),
                            const SizedBox(height: 18),
                            FlutterSwitch(
                              width: 60,
                              inactiveColor: model.accentColor,
                              activeColor: model.paletteColor,
                              value: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isOfficiatorProvided ?? false),
                              onToggle: (value) {

                                if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.isOfficiatorProvided ?? false) {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(false));
                                } else {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(true));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                    
                  ],
                )
              ),
            )
          );
        }
      )
    );
  }
}