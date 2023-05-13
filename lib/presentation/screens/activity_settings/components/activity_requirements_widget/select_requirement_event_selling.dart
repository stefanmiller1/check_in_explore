import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

class ActivityRequirementEventSelling extends StatefulWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityRequirementEventSelling({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  State<ActivityRequirementEventSelling> createState() => _ActivityRequirementEventSellingState();
}

class _ActivityRequirementEventSellingState extends State<ActivityRequirementEventSelling> {

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
            title: Text('Vendors & Merchants', style: TextStyle(color: widget.model.accentColor)),
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
                        child: Text(AppLocalizations.of(context)!.activityRequirementEventPreferencesVendors, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: widget.model.paletteColor)),
                      ),

                      RadioListTile(
                        toggleable: true,
                        value: 'Yes',
                        groupValue: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isMerchantSupported ?? false) ? 'Yes' : null,
                        onChanged: (String? value) {

                          if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isMerchantSupported ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantSupportedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantSupportedChanged(true));
                          }

                        },
                        activeColor: widget.model.paletteColor,
                        title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNeeded, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      ),
                      RadioListTile(
                        toggleable: true,
                        value: 'No',
                        groupValue: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isMerchantSupported ?? false) ? 'No' : null,
                        onChanged: (String? value) {

                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantSupportedChanged(false));

                        },
                        activeColor: widget.model.paletteColor,
                        title: Text(AppLocalizations.of(context)!.activityRequirementEventPreferencesNo, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      ),

                      SizedBox(height: 20),
                      Visibility(
                        visible: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.isMerchantSupported ?? false),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(AppLocalizations.of(context)!.activityRequirementEventPreferenceVendorsTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(AppLocalizations.of(context)!.activityRequirementEventPreferenceVendorsSubTitle, style: TextStyle(color: widget.model.paletteColor)),
                            ),

                            SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                dataRowHeight: 80,
                                showCheckboxColumn: false,
                                headingRowHeight: 90,
                                columns: <DataColumn> [
                                  DataColumn(label: Container(
                                      width: 50,
                                      child: Text(AppLocalizations.of(context)!.edit, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor)))),
                                  DataColumn(label: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(AppLocalizations.of(context)!.activityCoachPlayerFormFirstName, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor)),
                                      Text(AppLocalizations.of(context)!.activityCoachPlayerFormLastName, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor)),
                                    ],
                                  )),
                                  DataColumn(label: Text(AppLocalizations.of(context)!.activityRequirementEventVendorMerchantName, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor))),
                                  DataColumn(label: Text(AppLocalizations.of(context)!.activityCoachPlayerFormEmail, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor))),

                                ],
                                rows: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants.asMap().map((i, value) {

                                  TextEditingController nameTextController = TextEditingController();
                                  TextEditingController emailTextController = TextEditingController();
                                  TextEditingController socialsTextController = TextEditingController();

                                  if (nameTextController.text != value.name.value.fold(
                                          (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
                                          (r) => r)) {
                                    nameTextController.text = value.name.value.fold(
                                            (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
                                            (r) => r);
                                  }

                                  if (emailTextController.text != value.emailAddress.value.fold(
                                          (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidEmail: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
                                          (r) => r)) {
                                    emailTextController.text = value.emailAddress.value.fold(
                                            (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidEmail: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
                                            (r) => r);
                                  }

                                  if (socialsTextController.text != value.position) {
                                    socialsTextController.text = value.position ?? '';
                                  }

                                  return MapEntry(i, DataRow(
                                      cells: [
                                        DataCell(
                                            Center(
                                              child: Container(
                                                width: 60,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                            (Set<MaterialState> states) {
                                                          if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                                            return widget.model.paletteColor.withOpacity(0.1);
                                                          }
                                                          if (states.contains(MaterialState.hovered)) {
                                                            return widget.model.paletteColor.withOpacity(0.8);
                                                          }
                                                          return widget.model.paletteColor; // Use the component's default.
                                                        },
                                                      ),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {

                                                      setState(() {

                                                        if ((context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants.length ?? 1) >= 2 && i != 0) {

                                                          context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants.removeAt(i);

                                                        } else {

                                                          context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants[i] = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement!.listOfMerchants[i].copyWith(
                                                              contactId: UniqueId(),
                                                              name: FirstLastName(''),
                                                              position: '',
                                                              emailAddress: EmailAddress('')
                                                          );

                                                        }

                                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.merchantListChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants ?? []));
                                                      });
                                                    },
                                                child: Text(AppLocalizations.of(context)!.activitySettingsBlockClearAll, style: TextStyle(color: widget.model.accentColor))
                                              ),
                                            ),
                                          )
                                        ),
                                        DataCell(
                                          Center(
                                            child: Container(
                                              width: 140,
                                              child: getDescriptionTextField(
                                                  context,
                                                  widget.model,
                                                  nameTextController,
                                                  '',
                                                  1,
                                                  null,
                                                  updateText: (value) {
                                                    context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants[i] = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement!.listOfMerchants[i].copyWith(
                                                        name: FirstLastName(value)
                                                    );
                                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.merchantListChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants ?? []));
                                                  }
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Container(
                                              width: 140,
                                              child: getDescriptionTextField(
                                                  context,
                                                  widget.model,
                                                  socialsTextController,
                                                  '',
                                                  1,
                                                  null,
                                                  updateText: (value) {
                                                    context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants[i] = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement!.listOfMerchants[i].copyWith(
                                                        position: value
                                                    );
                                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.merchantListChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants ?? []));
                                                }
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Container(
                                              width: 140,
                                              child: getDescriptionTextField(
                                                  context,
                                                  widget.model,
                                                  emailTextController,
                                                  '',
                                                  1,
                                                  null,
                                                  updateText: (value) {
                                                    context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants[i] = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement!.listOfMerchants[i].copyWith(
                                                        emailAddress: EmailAddress(value)
                                                    );
                                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.merchantListChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants ?? []));
                                                  }
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    )
                                  );
                                }).values.toList() ?? [],
                              ),
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                          return widget.model.paletteColor.withOpacity(0.1);
                                        }
                                        if (states.contains(MaterialState.hovered)) {
                                          return widget.model.paletteColor.withOpacity(0.1);
                                        }
                                        return widget.model.paletteColor; // Use the component's default.
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                        )
                                    )
                                ),
                                onPressed: () {
                                  setState(() {
                                    context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants.add(ContactDetails(contactId: UniqueId(), name: FirstLastName(''), emailAddress: EmailAddress('')));
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.merchantListChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRequirement.eventActivityRulesRequirement?.listOfMerchants ?? []));
                                  });
                                },
                                child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                              ),
                            ),


                        ],
                      ),
                    )
                  ]
                ),
              )
            ),
        );
        }
      )
    );
  }
}