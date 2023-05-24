import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';



// class ActivitySetupClassesWidget extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityManagerForm activityManagerForm;
//
//   const ActivitySetupClassesWidget({Key? key, required this.model, required this.activityManagerForm}) : super(key: key);
//
//   @override
//   State<ActivitySetupClassesWidget> createState() => _ActivitySetupClassesWidgetState();
// }
//
// class _ActivitySetupClassesWidgetState extends State<ActivitySetupClassesWidget> {
//
//   String? _selectedCoachNewTeam;
//   // String? _selectedWorkingMethod;
//   // String? _selectedNoLimit;
//   AffiliationOption? affiliateOptionCreate;
//
//   TextEditingController? affiliateTitle;
//   TextEditingController? affiliateContactDetails;
//
//
//   @override
//   void initState() {
//
//     affiliateOptionCreate = AffiliationOption(
//         affiliateType: AffiliateType.organization,
//         affiliateName: '',
//         affiliateContact: ''
//     );
//
//     affiliateTitle = TextEditingController();
//     affiliateContactDetails = TextEditingController();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     affiliateTitle?.dispose();
//     affiliateContactDetails?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//       // if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability?.playerRoster?.isEmpty ?? true) {
//       //   for (var i = 1; i <= (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability?.attendeeLimit ?? 3); i++) {
//       //     ContactDetails detailItem = ContactDetails(contactId: UniqueId(), name: FirstLastName(''), emailAddress: EmailAddress(''));
//       //     context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability?.playerRoster?.add(detailItem);
//       //     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//       //   }
//       // }
//
//     return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm))),
//       child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//       listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
//       listener: (context, state) {
//
//       },
//       buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityManagerForm != c.activityManagerForm,
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: widget.model.paletteColor,
//             title: Text('Preset Classes', style: TextStyle(color: widget.model.accentColor)),
//             actions: [
//
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Visibility(
//                       visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityType.activity == ProfileActivityOption.coaching,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text(AppLocalizations.of(context)!.activityPresetClassesMainTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                           ),
//                           SizedBox(height: 20),
//                           RadioListTile(
//                             toggleable: true,
//                             value: 'ExistingTeam',
//                             groupValue: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.coachExistingTeam ?? false ? 'ExistingTeam' : null,
//                             onChanged: (String? value) {
//                               _selectedCoachNewTeam = value;
//
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsCoachingNewTeamChanged(false));
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsCoachingExistingTeamChanged(true));
//
//                             },
//                             activeColor: widget.model.paletteColor,
//                             title: Text(AppLocalizations.of(context)!.activityPresetClassesNewTeam, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                           ),
//                           RadioListTile(
//                             toggleable: true,
//                             value: 'NewTeam',
//                             groupValue: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.coachNewTeam ?? false ? 'NewTeam' : null,
//                             onChanged: (String? value) {
//                               _selectedCoachNewTeam = value;
//
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsCoachingNewTeamChanged(true));
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsCoachingExistingTeamChanged(false));
//                             },
//                             activeColor: widget.model.paletteColor,
//                             title: Text(AppLocalizations.of(context)!.activityPresetClassesExistingTeam, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                           ),
//                         ],
//                       )
//                   ),
//                   SizedBox(height: 20),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(AppLocalizations.of(context)!.activityPresetClassesWorkingType, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                       ),
//                       SizedBox(height: 20),
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'WorkingAlone',
//                         groupValue: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isWorkingAlone ?? false ? 'WorkingAlone' : null,
//                         onChanged: (String? value) {
//                           // _selectedCoachNewTeam = value;
//
//                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsWorkingAlone(true));
//                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsWorkingWithAffiliatesChanged(false));
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Text(AppLocalizations.of(context)!.activityPresetClassesWorkingAlone, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       ),
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'WithHelp',
//                         groupValue: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isWorkingWithAffiliates ?? false ? 'WithHelp' : null,
//                         onChanged: (String? value) {
//                           // _selectedCoachNewTeam = value;
//                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsWorkingAlone(false));
//                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsWorkingWithAffiliatesChanged(true));
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Text(AppLocalizations.of(context)!.activityPresetClassesWorkingHelp, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       ),
//                       SizedBox(height: 20),
//
//
//                       Visibility(
//                         visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isWorkingWithAffiliates ?? false,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//
//                             SizedBox(height: 20),
//                             Container(
//                               alignment: Alignment.centerLeft,
//                               height: 55,
//                               // width: (widget.model.mainContentWidth)! - 200,
//                               decoration: BoxDecoration(
//                                   color: widget.model.accentColor,
//                                   borderRadius: BorderRadius.all(Radius.circular(17.5))
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 15.0),
//                                 child: Text(AppLocalizations.of(context)!.activityCreateAndAdd, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text(AppLocalizations.of(context)!.activityPresetClassesWorkingTypeTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                             ),
//                             SizedBox(height: 20),
//                             DropdownButtonHideUnderline(
//                                 child: DropdownButton2(
//                                     offset: const Offset(-10,-15),
//                                     isDense: true,
//                                     buttonElevation: 0,
//                                     buttonDecoration: BoxDecoration(
//                                       color: Colors.transparent,
//                                       borderRadius: BorderRadius.circular(35),
//                                     ),
//                                     customButton: Container(
//                                       decoration: BoxDecoration(
//                                         color: widget.model.accentColor,
//                                         borderRadius: BorderRadius.circular(35),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(2.5),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(left: 8.0),
//                                               child: Text(getAffiliateName(context, affiliateOptionCreate?.affiliateType ?? AffiliateType.organization), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(right: 8.0),
//                                               child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     onChanged: (Object? navItem) {
//                                     },
//                                     buttonWidth: 80,
//                                     buttonHeight: 70,
//                                     dropdownElevation: 1,
//                                     dropdownPadding: const EdgeInsets.all(1),
//                                     dropdownDecoration: BoxDecoration(
//                                         boxShadow: [BoxShadow(
//                                             color: Colors.black.withOpacity(0.11),
//                                             spreadRadius: 1,
//                                             blurRadius: 15,
//                                             offset: Offset(0, 2)
//                                         )
//                                         ],
//                                         color: widget.model.cardColor,
//                                         borderRadius: BorderRadius.circular(14)),
//                                     itemHeight: 50,
//                                     // dropdownWidth: (widget.model.mainContentWidth)! - 100,
//                                     focusColor: Colors.grey.shade100,
//                                     items: AffiliateType.values.map(
//                                             (e) => DropdownMenuItem<AffiliateType>(
//                                             onTap: () {
//                                               setState(() {
//                                                 affiliateOptionCreate = affiliateOptionCreate?.copyWith(
//                                                     affiliateType: e
//                                                 );
//                                               });
//                                             },
//                                             value: e,
//                                             child: Text(getAffiliateName(context, e), style: TextStyle(color: widget.model.disabledTextColor)
//                                             )
//                                         )
//                                     ).toList()
//                                 )
//                             ),
//                             SizedBox(height: 10),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text(AppLocalizations.of(context)!.activityPresetClassesWorkingTypeName, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
//                             ),
//                             SizedBox(height: 10),
//                             getDescriptionTextField(
//                                 context,
//                                 widget.model,
//                                 affiliateTitle!,
//                                 '',
//                                 2,
//                                 150,
//                                 updateText: (value) {
//                                   affiliateOptionCreate = affiliateOptionCreate?.copyWith(
//                                       affiliateName: value
//                                   );
//                                 }
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text(AppLocalizations.of(context)!.signUpDashboardEmail, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
//                             ),
//                             SizedBox(height: 10),
//                             getDescriptionTextField(
//                                 context,
//                                 widget.model,
//                                 affiliateContactDetails!,
//                                 '',
//                                 2,
//                                 200,
//                                 updateText: (value) {
//
//                                   affiliateOptionCreate = affiliateOptionCreate?.copyWith(
//                                       affiliateContact: value
//                                   );
//                                 }
//                             ),
//                             SizedBox(height: 20),
//                             Align(
//                               alignment: Alignment.center,
//                               child: IconButton(
//                                 padding: EdgeInsets.zero,
//                                 icon: Icon(
//                                   Icons.add_circle_outline_rounded,
//                                   color: widget.model.paletteColor,
//                                   size: 45,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//
//                                     if (affiliateOptionCreate != null && affiliateOptionCreate!.affiliateName.isNotEmpty && affiliateOptionCreate!.affiliateContact.isNotEmpty) {
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.affiliateOptions.add(affiliateOptionCreate!);
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classAffiliateOptionsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.affiliateOptions ?? []));
//                                       affiliateOptionCreate = affiliateOptionCreate?.copyWith(
//                                           affiliateName: '',
//                                           affiliateContact: ''
//                                       );
//                                       affiliateTitle?.clear();
//                                       affiliateContactDetails?.clear();
//                                     }
//                                   });
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             ...?context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.affiliateOptions.map(
//                                     (e) => Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     // width: (widget.model.mainContentWidth)! - 100,
//                                     decoration: BoxDecoration(
//                                         color: widget.model.accentColor,
//                                         borderRadius: BorderRadius.all(Radius.circular(17.5))
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(4.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 15.0),
//                                                 child: Text(e.affiliateName, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 20.0),
//                                                 child: Text(e.affiliateContact, style: TextStyle(color: widget.model.paletteColor)),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 20.0),
//                                                 child: Text(getAffiliateName(context, e.affiliateType), style: TextStyle(color: widget.model.paletteColor)),
//                                               )
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 15.0),
//                                             child: TextButton(
//                                               style: ButtonStyle(
//                                                 backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                       (Set<MaterialState> states) {
//                                                     if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                       return widget.model.paletteColor.withOpacity(0.1);
//                                                     }
//                                                     if (states.contains(MaterialState.hovered)) {
//                                                       return widget.model.paletteColor.withOpacity(0.8);
//                                                     }
//                                                     return widget.model.paletteColor; // Use the component's default.
//                                                   },
//                                                 ),
//                                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                   RoundedRectangleBorder(
//                                                     borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                   ),
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.affiliateOptions.remove(e);
//                                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classAffiliateOptionsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.affiliateOptions ?? []));
//                                                 });
//                                               },
//                                               child: Text(AppLocalizations.of(context)!.remove, style: TextStyle(color: widget.model.accentColor)),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                             ).toList(),
//
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20),
//
//
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(AppLocalizations.of(context)!.activityPresetClassesAcceptanceTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(AppLocalizations.of(context)!.activityPresetClassesAcceptanceSubTitle, style: TextStyle(color: widget.model.paletteColor)),
//                       ),
//                       SizedBox(height: 20),
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'NoLimit',
//                         groupValue: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToUnlimitedAttendees ?? false ? 'NoLimit' : null,
//                         onChanged: (String? value) {
//                           // _selectedCoachNewTeam = value;
//
//                           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToUnlimitedAttendees ?? false) {
//                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsAllowedUnlimitedAttendeeChanged(false));
//                           } else {
//                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsAllowedUnlimitedAttendeeChanged(true));
//                           }
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Text(AppLocalizations.of(context)!.activityAttendanceTypeQuantityNone, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       ),
//
//                       Visibility(
//                         visible: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToUnlimitedAttendees ?? false),
//                         child: Row(
//                           children: [
//                             Container(
//                                 decoration: BoxDecoration(
//                                     color: widget.model.accentColor,
//                                     borderRadius: BorderRadius.all(Radius.circular(12))
//                                 ),
//                                 height: 35,
//                                 width: 60,
//                                 child: Center(
//                                   child: Text(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.attendeeLimit.toString() ?? '3', style: TextStyle(color: widget.model.disabledTextColor)
//                                   ),
//                                 )
//                             ),
//                             QuantityButtons(
//                                 model: widget.model,
//                                 initNumber: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.attendeeLimit,
//                                 counterCallback: (int v) {
//
//                                   setState(() {
//
//
//                                     if ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.length ?? v) < v) {
//
//                                       print('add one');
//                                       ContactDetails detailItem = ContactDetails(contactId: UniqueId(), name: FirstLastName(''), emailAddress: EmailAddress(''));
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.add(detailItem);
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//
//                                     } else if ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.length ?? v) > v) {
//
//                                       print('remove');
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.removeLast();
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                                     }
//
//
//
//
//
//                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classAttendeeLimitChanged(v));
//                                   });
//                                 }
//                             ),
//                             Text(AppLocalizations.of(context)!.activityAttendanceTypeTitle,
//                                 style: TextStyle(
//                                     color: widget.model.paletteColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             ),
//         );
//         }
//       )
//     );
//   }
// }
//
//
// // ignore: must_be_immutable
// class ActivitySetupClassesAddAttendees extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivitySetupClassesAddAttendees({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivitySetupClassesAddAttendees> createState() => _ActivitySetupClassesAddAttendeesState();
// }
//
// class _ActivitySetupClassesAddAttendeesState extends State<ActivitySetupClassesAddAttendees> {
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//
//     return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityCreatorForm))),
//       child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//       listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
//       listener: (context, state) {
//
//       },
//       buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityManagerForm != c.activityManagerForm,
//       builder: (context, state) {
//
//         // if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability?.classesActivityAvailability?.additionalPlayerLimit == null) {
//         //   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerLimitChanged(3));
//         // }
//
//         return Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: widget.model.paletteColor,
//             title: Text('Class Attendees', style: TextStyle(color: widget.model.accentColor)),
//             actions: [
//
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Text(AppLocalizations.of(context)!.activityPresetClassesCoachTeamTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(AppLocalizations.of(context)!.activityPresetClassesCoachTeamSubTitle, style: TextStyle(color: widget.model.paletteColor)),
//                   ),
//                   SizedBox(height: 20),
//                   RadioListTile(
//                     toggleable: true,
//                     value: 'NoLimit',
//                     groupValue: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToMorePlayers ?? false ? 'NoLimit' : null,
//                     onChanged: (String? value) {
//
//                       if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToMorePlayers ?? false) {
//                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsOpenToMorePlayers(false));
//                       } else {
//                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classIsOpenToMorePlayers(true));
//                       }
//
//                     },
//                     activeColor: widget.model.paletteColor,
//                     title: Text(AppLocalizations.of(context)!.activityPresetClassesCoachTeamNoNew, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                   ),
//
//                   Visibility(
//                     visible: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToMorePlayers ?? false),
//                     child: Row(
//                       children: [
//                         Container(
//                             decoration: BoxDecoration(
//                                 color: widget.model.accentColor,
//                                 borderRadius: BorderRadius.all(Radius.circular(12))
//                             ),
//                             height: 35,
//                             width: 60,
//                             child: Center(
//                               child: Text(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.additionalPlayerLimit.toString() ?? '8', style: TextStyle(color: widget.model.disabledTextColor)
//                               ),
//                             )
//                         ),
//                         QuantityButtons(
//                             model: widget.model,
//                             initNumber: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.additionalPlayerLimit ?? 8,
//                             counterCallback: (int v) {
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerLimitChanged(v));
//                             }
//                         ),
//                         Text(AppLocalizations.of(context)!.activityAttendanceTypeTitle,
//                             style: TextStyle(
//                                 color: widget.model.paletteColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: Text(AppLocalizations.of(context)!.activityPresetClassesCoachingTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(AppLocalizations.of(context)!.activityPresetClassesCoachingSubTitle, style: TextStyle(color: widget.model.paletteColor)),
//                   ),
//                   SizedBox(height: 20),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                         dataRowHeight: 80,
//                         showCheckboxColumn: false,
//                         headingRowHeight: 90,
//                         columns: <DataColumn>  [
//                           DataColumn(label: Container(
//                               width: 50,
//                               child: Text(AppLocalizations.of(context)!.edit, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor)))),
//                           DataColumn(label: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(AppLocalizations.of(context)!.activityCoachPlayerFormFirstName, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor)),
//                               Text(AppLocalizations.of(context)!.activityCoachPlayerFormLastName, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor)),
//                             ],
//                           )),
//                           DataColumn(label: Text(AppLocalizations.of(context)!.activityCoachPlayerFormPosition, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor))),
//                           DataColumn(label: Text(AppLocalizations.of(context)!.activityCoachPlayerFormEmail, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor))),
//                           DataColumn(label: Text(AppLocalizations.of(context)!.search, style: TextStyle(fontWeight:  FontWeight.bold, color: widget.model.paletteColor))),
//                         ],
//
//                         rows: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster != null) ? context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.asMap().map((i, value) {
//
//                           TextEditingController nameTextController = TextEditingController();
//                           TextEditingController positionTextController = TextEditingController();
//                           TextEditingController emailTextController = TextEditingController();
//
//
//                           // if (nameTextController.text != value.name.value.fold(
//                           //         (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
//                           //         (r) => r)) {
//                           //   nameTextController.text = value.name.value.fold(
//                           //           (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
//                           //           (r) => r);
//                           // }
//                           //
//                           // if (emailTextController.text != value.emailAddress.value.fold(
//                           //         (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidEmail: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
//                           //         (r) => r)) {
//                           //   emailTextController.text = value.emailAddress.value.fold(
//                           //           (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidEmail: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
//                           //           (r) => r);
//                           // }
//                           //
//                           // if (positionTextController.text != value.position) {
//                           //   positionTextController.text = value.position ?? '';
//                           // }
//
//
//                           return MapEntry(i, DataRow(
//                               cells: [
//                                 DataCell(
//                                     Center(
//                                       child: Container(
//                                         width: 60,
//                                         child: TextButton(
//                                             style: ButtonStyle(
//                                               backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                     (Set<MaterialState> states) {
//                                                   if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                     return widget.model.paletteColor.withOpacity(0.1);
//                                                   }
//                                                   if (states.contains(MaterialState.hovered)) {
//                                                     return widget.model.paletteColor.withOpacity(0.8);
//                                                   }
//                                                   return widget.model.paletteColor; // Use the component's default.
//                                                 },
//                                               ),
//                                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                 RoundedRectangleBorder(
//                                                   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                 ),
//                                               ),
//                                             ),
//                                             onPressed: () {
//
//                                               setState(() {
//
//                                                 if (i != 0 && (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.length ?? 1) >= (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.attendeeLimit ?? 3)) {
//                                                   context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.removeAt(i);
//                                                 } else {
//
//                                                   context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability!.playerRoster![i].copyWith(
//                                                       contactId: UniqueId(),
//                                                       name: FirstLastName(''),
//                                                       position: '',
//                                                       emailAddress: EmailAddress('')
//                                                   );
//                                                 }
//
//
//                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                                               });
//                                             },
//                                             child: Text(AppLocalizations.of(context)!.activitySettingsBlockClearAll, style: TextStyle(color: widget.model.accentColor))
//                                         ),
//                                       ),
//                                     )
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Container(
//                                       width: 140,
//                                       child: getDescriptionTextField(
//                                           context,
//                                           widget.model,
//                                           nameTextController,
//                                           '',
//                                           1,
//                                           null,
//                                           updateText: (value) {
//                                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability!.playerRoster![i].copyWith(
//                                                 name: FirstLastName(value)
//                                             );
//                                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                                           }
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Container(
//                                       width: 75,
//                                       child: getDescriptionTextField(
//                                           context,
//                                           widget.model,
//                                           positionTextController,
//                                           '',
//                                           1,
//                                           null,
//                                           updateText: (value) {
//                                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability!.playerRoster![i].copyWith(
//                                                 position: value
//                                             );
//                                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                                           }
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Center(
//                                     child: Container(
//                                       width: 140,
//                                       child: getDescriptionTextField(
//                                           context,
//                                           widget.model,
//                                           emailTextController,
//                                           '',
//                                           1,
//                                           null,
//                                           updateText: (value) {
//                                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability!.playerRoster![i].copyWith(
//                                                 emailAddress: EmailAddress(value)
//                                             );
//                                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                                           }
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                     IconButton(
//                                         padding: EdgeInsets.zero,
//                                         icon: Icon(
//                                           Icons.search_rounded,
//                                           color: widget.model.paletteColor,
//                                           size: 45,
//                                         ),
//                                         onPressed: () {
//
//                                           // setState(() {
//                                           //   showDialog(
//                                           //       context: context,
//                                           //       barrierColor: widget.model.disabledTextColor.withOpacity(0.3),
//                                           //       builder: (BuildContext thisContext) {
//                                           //         return AddNewProfileWidget(
//                                           //           model: widget.model,
//                                           //           title: AppLocalizations.of(context)!.profileFacilitySettingsCoOwners,
//                                           //           subTitle: AppLocalizations.of(context)!.profileFacilitySettingsCoOwnerDescription,
//                                           //           selectedProfile: (profile) {
//                                           //
//                                           //             setState(() {
//                                           //
//                                           //               context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability?.playerRoster?[i] = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability!.playerRoster![i].copyWith(
//                                           //                   contactId: profile.userId,
//                                           //                   name: profile.legalName,
//                                           //                   emailAddress: profile.emailAddress
//                                           //               );
//                                           //               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                                           //
//                                           //               Navigator.of(thisContext).pop();
//                                           //             });
//                                           //           },
//                                           //         );
//                                           //       }
//                                           //   );
//                                           // });
//                                         }
//                                     )
//                                 ),
//                               ]));
//                         }).values.toList() as List<DataRow> : []
//                     ),
//                   ),
//
//                   SizedBox(height: 15),
//                   Visibility(
//                     visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToUnlimitedAttendees ?? false,
//                     child: Center(
//                       child: TextButton(
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                   (Set<MaterialState> states) {
//                                 if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                   return widget.model.paletteColor.withOpacity(0.1);
//                                 }
//                                 if (states.contains(MaterialState.hovered)) {
//                                   return widget.model.paletteColor.withOpacity(0.1);
//                                 }
//                                 return widget.model.paletteColor; // Use the component's default.
//                               },
//                             ),
//                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                 )
//                             )
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.add(ContactDetails(contactId: UniqueId(), name: FirstLastName(''), emailAddress: EmailAddress('')));
//                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classPlayerRosterChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster ?? []));
//                           });
//                         },
//                         child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                   )
//
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       )
//     );
//   }
// }