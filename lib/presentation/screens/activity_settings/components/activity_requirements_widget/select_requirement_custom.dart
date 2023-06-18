import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitySelectCustomRequirement extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivitySelectCustomRequirement({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  State<ActivitySelectCustomRequirement> createState() => _ActivitySelectCustomRequirementState();
}

class _ActivitySelectCustomRequirementState extends State<ActivitySelectCustomRequirement> {

  String _pastExperienceReq = 'NoneNeeded';

  @override
  Widget build(BuildContext context) {
    return Container();
    // return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
    //   child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
    //     listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
    //     listener: (context, state) {
    //
    //     },
    //     buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
    //     builder: (context, state) {
    //     return Scaffold(
    //       appBar: AppBar(
    //         elevation: 0,
    //         backgroundColor: widget.model.paletteColor,
    //         title: Text('Special Requirements', style: TextStyle(color: widget.model.accentColor)),
    //         actions: [
    //
    //         ],
    //       ),
    //       body: Padding(
    //         padding: const EdgeInsets.all(18.0),
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
    //               ),
    //               const SizedBox(height: 10),
    //               RadioListTile(
    //                 toggleable: true,
    //                 value: 'Yes',
    //                 groupValue: _pastExperienceReq,
    //                 onChanged: (String? value) {
    //
    //                   setState(() {
    //                     if (_pastExperienceReq == 'Yes') {
    //                       _pastExperienceReq = value ?? 'NoneNeeded';
    //                     } else {
    //                       _pastExperienceReq = value ?? 'Yes';
    //                     }
    //                   });
    //
    //                 },
    //                 activeColor: widget.model.paletteColor,
    //                 title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNeeded, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
    //               ),
    //               RadioListTile(
    //                 toggleable: true,
    //                 value: 'NoneNeeded',
    //                 groupValue: _pastExperienceReq,
    //                 onChanged: (String? value) {
    //
    //                   setState(() {
    //                     if (_pastExperienceReq == 'NoneNeeded') {
    //                       _pastExperienceReq = value ?? 'Yes';
    //                     } else {
    //                       _pastExperienceReq = value ?? 'NoneNeeded';
    //                     }
    //                   });
    //
    //                 },
    //                 activeColor: widget.model.paletteColor,
    //                 title: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNone, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
    //               ),
    //
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceSubTitle, style: TextStyle(color: widget.model.paletteColor)),
    //               ),
    //               const SizedBox(height: 20),
    //               Visibility(
    //                 visible: (_pastExperienceReq == 'Yes'),
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                         decoration: BoxDecoration(
    //                             color: widget.model.accentColor,
    //                             borderRadius: BorderRadius.all(Radius.circular(12))
    //                         ),
    //                         height: 35,
    //                         width: 60,
    //                         child: Center(
    //                           child: Text(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement.toString(), style: TextStyle(color: widget.model.disabledTextColor)
    //                           ),
    //                         )
    //                     ),
    //                     QuantityButtons(
    //                         model: widget.model,
    //                         initNumber: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement,
    //                         counterCallback: (int v) {
    //
    //                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.minimumAgeChanged(v));
    //
    //                         }
    //                     ),
    //                     Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceNone,
    //                         style: TextStyle(
    //                             color: widget.model.paletteColor,
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: widget.model.secondaryQuestionTitleFontSize)),
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(height: 30),
    //
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesAdditional, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
    //               ),
    //               const SizedBox(height: 10),
    //               ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.getOrCrash().asMap().map(
    //                       (i, value) {
    //
    //                     TextEditingController requirementTextController = TextEditingController();
    //
    //                     if (requirementTextController.text.isEmpty) {
    //                       requirementTextController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.getOrCrash()[i].customDetail ?? '';
    //                     } else {
    //
    //                     }
    //
    //                     return MapEntry(i, Container(
    //                       width: 500,
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: getDescriptionTextField(
    //                                 context,
    //                                 widget.model,
    //                                 requirementTextController,
    //                                 '',
    //                                 1,
    //                                 32,
    //                                 updateText: (value) {
    //                                   context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.getOrCrash()[i] = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption!.getOrCrash()[i].copyWith(
    //                                       customDetail: value);
    //                                   // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRequirementChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption ?? ListK([])));
    //                                 }
    //                             ),
    //                           ),
    //                           Visibility(
    //                             visible: i >= 1,
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: IconButton(
    //                                 padding: EdgeInsets.zero,
    //                                 icon: Icon(Icons.clear, size: 35, color: widget.model.paletteColor),
    //                                 onPressed: () {
    //                                   setState(() {
    //                                     // context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.getOrCrash().removeAt(i);
    //                                     // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRequirementChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption ?? ListK([])));
    //                                   });
    //                                 },
    //                               ),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 }
    //               ).values.toList() ?? [],
    //                 Visibility(
    //                   visible: ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.getOrCrash().length ?? 1) < 5),
    //                   child: TextButton(
    //                     style: ButtonStyle(
    //                         backgroundColor: MaterialStateProperty.resolveWith<Color>(
    //                               (Set<MaterialState> states) {
    //                             if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
    //                               return widget.model.paletteColor.withOpacity(0.1);
    //                             }
    //                             if (states.contains(MaterialState.hovered)) {
    //                               return widget.model.paletteColor.withOpacity(0.1);
    //                             }
    //                             return widget.model.paletteColor; // Use the component's default.
    //                           },
    //                         ),
    //                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                             RoundedRectangleBorder(
    //                               borderRadius: const BorderRadius.all(Radius.circular(15)),
    //                             )
    //                         )
    //                     ),
    //                     onPressed: () {
    //                       setState(() {
    //                         // context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.getOrCrash().add(DetailCustomOption(uid: UniqueId(), customDetail: ''));
    //                         // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRequirementChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption ?? ListK([])));
    //                       });
    //                     },
    //                     child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 25),
    //               ],
    //             ),
    //         ),
    //         ),
    //     );
    //     }
    //   )
    // );
  }
}