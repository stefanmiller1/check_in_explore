import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;


class ActivityRuleGameToCreate extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivityRuleGameToCreate({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  State<ActivityRuleGameToCreate> createState() => _ActivityRuleGameToCreateState();
}

class _ActivityRuleGameToCreateState extends State<ActivityRuleGameToCreate> {


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
            title: Text('Special Rules', style: TextStyle(color: widget.model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.activityRuleGameExpectationCompetitionPools, style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.questionTitleFontSize)),
                    SizedBox(height: 10),
                    Text(AppLocalizations.of(context)!.activityRuleGameExpectationCompetitionAdd, style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    Text(AppLocalizations.of(context)!.activityRuleGameExpectationCompetitionAddSub, style: TextStyle(
                        color: widget.model.paletteColor)),
                    ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?.asMap().map((i, e)
                           => MapEntry(i, Row(
                             children: [
                               Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                              offset: const Offset(-10,-15),
                                              isDense: true,
                                              buttonElevation: 0,
                                              buttonDecoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(35),
                                              ),
                                              customButton: Container(
                                                decoration: BoxDecoration(
                                                  color: widget.model.accentColor,
                                                  borderRadius: BorderRadius.circular(35),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Text(getDonationName(context, context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?[i] ?? DonationType.cash), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onChanged: (Object? navItem) {
                                              },
                                              buttonWidth: 80,
                                              buttonHeight: 70,
                                              dropdownElevation: 1,
                                              dropdownPadding: const EdgeInsets.all(1),
                                              dropdownDecoration: BoxDecoration(
                                                  boxShadow: [BoxShadow(
                                                      color: Colors.black.withOpacity(0.11),
                                                      spreadRadius: 1,
                                                      blurRadius: 15,
                                                      offset: Offset(0, 2)
                                                    )
                                                  ],
                                                  color: widget.model.cardColor,
                                                  borderRadius: BorderRadius.circular(14)),
                                              itemHeight: 50,
                                              // dropdownWidth: (widget.model.mainContentWidth)! - 100,
                                              focusColor: Colors.grey.shade100,
                                              items: DonationType.values.map(
                                                      (e) => DropdownMenuItem<DonationType>(
                                                      onTap: () {
                                                        setState(() {
                                                          context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?[i] = e;
                                                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.allowedDonationTypesChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes ?? []));
                                                        });
                                                      },
                                                      value: e,
                                                      child: Text(getDonationName(context, e), style: TextStyle(color: widget.model.disabledTextColor)
                              )
                             )
                            ).toList()
                           )
                          ),
                                 ),
                               ),
                           SizedBox(width: 15),
                           Visibility(
                             visible: i != 0,
                             child: Padding(
                               padding: const EdgeInsets.only(bottom: 15.0),
                               child: TextButton(onPressed: () {
                                 setState(() {

                                   context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?.removeAt(i);
                                   context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.allowedDonationTypesChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes ?? []));


                                 });
                               }, child: Icon(Icons.cancel_outlined, size: 40, color: (i != 0) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                             ),
                           ),

                       ],
                      ),
                     )
                    ).values.toList() ?? [],
                    SizedBox(height: 10),
                    Visibility(
                      visible: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?.length ?? 1) < 5,
                      child: Center(
                        child: IconButton(onPressed: () {
                          setState(() {

                            if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?.length ?? 1) < 5) {

                              context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes?.add(DonationType.cash);
                              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.allowedDonationTypesChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.allowedDonationTypes ?? []));
                            }

                          });
                        }, icon: Icon(Icons.add_circle_outline, size: 25, color: widget.model.paletteColor,)),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.activityRuleGameExpectationCompetitionContribute, style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    SizedBox(height: 20),

                    RadioListTile(
                      toggleable: true,
                      value: 'Yes',
                      groupValue: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.isAllowedExternalContributions ?? false) ? 'Yes' : null,
                      onChanged: (String? value) {

                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.isAllowedExternalContributions ?? false) {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedExternalContributions(false));
                        } else {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedExternalContributions(true));
                        }

                      },
                      activeColor: widget.model.paletteColor,
                      title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNeeded, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    ),
                    RadioListTile(
                      toggleable: true,
                      value: 'No',
                      groupValue: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.gameActivityRules?.isAllowedExternalContributions ?? false) ? 'No' : null,
                      onChanged: (String? value) {

                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedExternalContributions(false));

                      },
                      activeColor: widget.model.paletteColor,
                      title: Text(AppLocalizations.of(context)!.activityRequirementEventPreferencesNo, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
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