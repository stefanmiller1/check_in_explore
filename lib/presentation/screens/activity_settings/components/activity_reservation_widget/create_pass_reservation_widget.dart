import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityAttendeeCreatePasses extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivityAttendeeCreatePasses({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  State<ActivityAttendeeCreatePasses> createState() => _ActivityAttendeeCreatePassesState();
}

class _ActivityAttendeeCreatePassesState extends State<ActivityAttendeeCreatePasses> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
  //   return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
  //     child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
  //     listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
  //     listener: (context, state) {
  //
  //     },
  //       buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
  //       builder: (context, state) {
  //       return Scaffold(
  //         appBar: AppBar(
  //         elevation: 0,
  //         backgroundColor: widget.model.paletteColor,
  //         title: Text('Ticket Attendees', style: TextStyle(color: widget.model.accentColor)),
  //         actions: [
  //
  //           ],
  //         ),
  //         body: Center(
  //             child: Padding(
  //                 padding: const EdgeInsets.all(18.0),
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //
  //                       Text('${AppLocalizations.of(context)!.activityAttendanceTypeGenerate} ${AppLocalizations.of(context)!.activityAttendanceTypePasses}', style: TextStyle(
  //                           color: widget.model.paletteColor,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       SizedBox(height: 50),
  //
  //
  //                       Text(AppLocalizations.of(context)!.activityAttendanceTypePassesGroups, style: TextStyle(
  //                           color: widget.model.paletteColor,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       Text(AppLocalizations.of(context)!.facilitiesSelect, style: TextStyle(color: widget.model.paletteColor)),
  //                       SizedBox(height: 10),
  //
  //                       RadioListTile(
  //                         toggleable: true,
  //                         value: 'NotAllowed',
  //                         groupValue: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.isAllowedGroupAttendance ?? true) ? 'NotAllowed' : null,
  //                         onChanged: (String? value) {
  //
  //                           if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.isAllowedGroupAttendance ?? true) {
  //                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesAttendanceIsAllowedGroups(false));
  //                           } else {
  //                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesAttendanceIsAllowedGroups(true));
  //                           }
  //
  //
  //                         },
  //                         activeColor: widget.model.paletteColor,
  //                         title: Text(AppLocalizations.of(context)!.activityAttendanceTypePassesGroupsNo, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       ),
  //
  //
  //
  //                       Visibility(
  //                           // visible: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAttendance.activityPasses?.isAllowedGroupAttendance ?? true),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //
  //                               SizedBox(height: 10),
  //                               Text('Minimum Number of Attendees In a Group', style: TextStyle(color: widget.model.paletteColor)),
  //                               SizedBox(height: 10),
  //                               Container(
  //                                 width: 375,
  //                                 child: DropdownButtonHideUnderline(
  //                                   child: DropdownButton2(
  //                                       offset: const Offset(-10,-15),
  //                                       isDense: true,
  //                                       buttonElevation: 0,
  //                                       buttonDecoration: BoxDecoration(
  //                                         color: Colors.transparent,
  //                                         borderRadius: BorderRadius.circular(35),
  //                                       ),
  //                                       customButton: Container(
  //                                         decoration: BoxDecoration(
  //                                           color: widget.model.accentColor,
  //                                           borderRadius: BorderRadius.circular(35),
  //                                         ),
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(2.5),
  //                                           child: Row(
  //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                             children: [
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 8.0),
  //                                                 child: Text('Groups of ${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.minimumGroupQuantity ?? 6}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
  //                                               ),
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(right: 8.0),
  //                                                 child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       onChanged: (Object? navItem) {
  //                                       },
  //                                       buttonWidth: 80,
  //                                       buttonHeight: 70,
  //                                       dropdownElevation: 1,
  //                                       dropdownPadding: const EdgeInsets.all(1),
  //                                       dropdownDecoration: BoxDecoration(
  //                                           boxShadow: [BoxShadow(
  //                                               color: Colors.black.withOpacity(0.11),
  //                                               spreadRadius: 1,
  //                                               blurRadius: 15,
  //                                               offset: Offset(0, 2)
  //                                           )
  //                                           ],
  //                                           color: widget.model.cardColor,
  //                                           borderRadius: BorderRadius.circular(14)),
  //                                       itemHeight: 50,
  //                                       focusColor: Colors.grey.shade100,
  //                                       items: [for(var i=2; i<100; i+=1) i].where((element) => element != 0).map(
  //                                               (e) => DropdownMenuItem<int>(
  //                                               onTap: () {
  //
  //                                                 setState(() {
  //
  //                                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMinimumGroupQuantityChanged(e));
  //
  //                                                   if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 0) < e) {
  //                                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMaximumGroupQuantityChanged(e + 1));
  //                                                   }
  //
  //                                                   if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.passQuantity ?? 0) < e) {
  //                                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesQuantityChanged(e + 1));
  //                                                   }
  //
  //                                                 });
  //
  //
  //                                               },
  //                                               value: e,
  //                                               child: Text('Groups of $e', style: TextStyle(color: widget.model.disabledTextColor)
  //                                               )
  //                                           )
  //                                       ).toList()
  //                                   ),
  //                                 ),
  //                               ),
  //
  //                               SizedBox(height: 15),
  //                               Text('Maximum Number of Attendees In a Group', style: TextStyle(color: widget.model.paletteColor)),
  //                               SizedBox(height: 10),
  //                               Container(
  //                                 width: 375,
  //                                 child: DropdownButtonHideUnderline(
  //                                   child: DropdownButton2(
  //                                       offset: const Offset(-10,-15),
  //                                       isDense: true,
  //                                       buttonElevation: 0,
  //                                       buttonDecoration: BoxDecoration(
  //                                         color: Colors.transparent,
  //                                         borderRadius: BorderRadius.circular(35),
  //                                       ),
  //                                       customButton: Container(
  //                                         decoration: BoxDecoration(
  //                                           color: widget.model.accentColor,
  //                                           borderRadius: BorderRadius.circular(35),
  //                                         ),
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(2.5),
  //                                           child: Row(
  //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                             children: [
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 8.0),
  //                                                 child: Text('Groups of ${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 12}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
  //                                               ),
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(right: 8.0),
  //                                                 child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       onChanged: (Object? navItem) {
  //                                       },
  //                                       buttonWidth: 80,
  //                                       buttonHeight: 70,
  //                                       dropdownElevation: 1,
  //                                       dropdownPadding: const EdgeInsets.all(1),
  //                                       dropdownDecoration: BoxDecoration(
  //                                           boxShadow: [BoxShadow(
  //                                               color: Colors.black.withOpacity(0.11),
  //                                               spreadRadius: 1,
  //                                               blurRadius: 15,
  //                                               offset: Offset(0, 2)
  //                                             )
  //                                           ],
  //                                           color: widget.model.cardColor,
  //                                           borderRadius: BorderRadius.circular(14)),
  //                                       itemHeight: 50,
  //                                       // dropdownWidth: (widget.model.mainContentWidth)! - 100,
  //                                       focusColor: Colors.grey.shade100,
  //                                       items: [for(var i=(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.minimumGroupQuantity ?? 0 + 1); i<100; i+=1) i].where((element) => element != 0).map(
  //                                               (e) => DropdownMenuItem<int>(
  //                                               onTap: () {
  //                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMaximumGroupQuantityChanged(e));
  //
  //                                                 if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.passQuantity ?? 0) < e) {
  //                                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesQuantityChanged(e));
  //                                                 }
  //
  //                                               },
  //                                               value: e,
  //                                               child: Text('Groups of $e', style: TextStyle(color: widget.model.disabledTextColor)
  //                                               )
  //                                           )
  //                                       ).toList()
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(height: 10),
  //                           ],
  //                         )
  //                       ),
  //
  //             Visibility(
  //               // visible: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isDayBased ?? false) && !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAttendance.isTicketBased ?? true) || context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
  //               child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //
  //                   SizedBox(height: 20),
  //                   Text('Number of Sessions/Slots For Each ${AppLocalizations.of(context)!.days} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
  //                       color: widget.model.paletteColor,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                   Text(AppLocalizations.of(context)!.activityAttendanceTypeQuantityHint(AppLocalizations.of(context)!.activityAttendanceTypePasses, AppLocalizations.of(context)!.activityAvailabilitySessions), style: TextStyle(color: widget.model.paletteColor)),
  //                   SizedBox(height: 10),
  //
  //                   Container(
  //                     width: 375,
  //                     child: DropdownButtonHideUnderline(
  //                         child: DropdownButton2(
  //                             offset: const Offset(-10,-15),
  //                             isDense: true,
  //                             buttonElevation: 0,
  //                             buttonDecoration: BoxDecoration(
  //                               color: Colors.transparent,
  //                               borderRadius: BorderRadius.circular(35),
  //                             ),
  //                             customButton: Container(
  //                               decoration: BoxDecoration(
  //                                 color: widget.model.accentColor,
  //                                 borderRadius: BorderRadius.circular(35),
  //                               ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(2.5),
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(left: 8.0),
  //                                       child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.passQuantity ?? 20} ${AppLocalizations.of(context)!.profileUserOverviewSlots}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
  //                                     ),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(right: 8.0),
  //                                       child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             onChanged: (Object? navItem) {
  //                             },
  //                             buttonWidth: 80,
  //                             buttonHeight: 70,
  //                             dropdownElevation: 1,
  //                             dropdownPadding: const EdgeInsets.all(1),
  //                             dropdownDecoration: BoxDecoration(
  //                                 boxShadow: [BoxShadow(
  //                                     color: Colors.black.withOpacity(0.11),
  //                                     spreadRadius: 1,
  //                                     blurRadius: 15,
  //                                     offset: Offset(0, 2)
  //                                 )
  //                                 ],
  //                                 color: widget.model.cardColor,
  //                                 borderRadius: BorderRadius.circular(14)),
  //                             itemHeight: 50,
  //                             // dropdownWidth: (widget.model.mainContentWidth)! - 100,
  //                             focusColor: Colors.grey.shade100,
  //                             items: [for(var i=2; i<100; i+=1) i].where((element) => element != 0).map(
  //                                     (e) => DropdownMenuItem<int>(
  //                                     onTap: () {
  //
  //                                       setState(() {
  //                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesQuantityChanged(e));
  //
  //                                         if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 12) > e) {
  //                                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMaximumGroupQuantityChanged(e));
  //                                           if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.minimumGroupQuantity ?? 6) > e) {
  //                                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMinimumGroupQuantityChanged(e - 1));
  //                                           }
  //                                         }
  //                                       });
  //                                     },
  //                                     value: e,
  //                                     child: Text('$e ${AppLocalizations.of(context)!.profileUserOverviewSlots}', style: TextStyle(color: widget.model.disabledTextColor)
  //                               )
  //                             )
  //                           ).toList()
  //                         )
  //                       ),
  //                     ),
  //                   ],
  //               ),
  //             ),
  //
  //             Visibility(
  //                   // visible: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isDayBased ?? true) && !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAttendance.isTicketBased ?? true),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //
  //                       SizedBox(height: 20),
  //                       Visibility(
  //                         // visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isThirtyMinutesPer ?? false,
  //                         child: Text('Number of Sessions/Slots For Each 30 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
  //                             color: widget.model.paletteColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       ),
  //
  //                       Visibility(
  //                         // visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isSixtyMinutesPer ?? false,
  //                         child: Text('Number of Sessions/Slots For Each 60 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
  //                             color: widget.model.paletteColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       ),
  //
  //                       Visibility(
  //                         // visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isTwoHoursPer ?? false,
  //                         child: Text('Number of Sessions/Slots For Each 2 ${AppLocalizations.of(context)!.facilityAvailableSlotHours} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
  //                             color: widget.model.paletteColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       ),
  //
  //                       Text('A Pass can be used to book one session or slot', style: TextStyle(color: widget.model.paletteColor)),
  //                       SizedBox(height: 10),
  //
  //                       Container(
  //                         width: 375,
  //                         child: DropdownButtonHideUnderline(
  //                             child: DropdownButton2(
  //                                 offset: const Offset(-10,-15),
  //                                 isDense: true,
  //                                 buttonElevation: 0,
  //                                 buttonDecoration: BoxDecoration(
  //                                   color: Colors.transparent,
  //                                   borderRadius: BorderRadius.circular(35),
  //                                 ),
  //                                 customButton: Container(
  //                                   decoration: BoxDecoration(
  //                                     color: widget.model.accentColor,
  //                                     borderRadius: BorderRadius.circular(35),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(2.5),
  //                                     child: Row(
  //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(left: 8.0),
  //                                           child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.passQuantity ?? 0} ${AppLocalizations.of(context)!.profileUserOverviewSlots}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
  //                                         ),
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(right: 8.0),
  //                                           child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 onChanged: (Object? navItem) {
  //                                 },
  //                                 buttonWidth: 80,
  //                                 buttonHeight: 70,
  //                                 dropdownElevation: 1,
  //                                 dropdownPadding: const EdgeInsets.all(1),
  //                                 dropdownDecoration: BoxDecoration(
  //                                     boxShadow: [BoxShadow(
  //                                         color: Colors.black.withOpacity(0.11),
  //                                         spreadRadius: 1,
  //                                         blurRadius: 15,
  //                                         offset: Offset(0, 2)
  //                                       )
  //                                     ],
  //                                     color: widget.model.cardColor,
  //                                     borderRadius: BorderRadius.circular(14)),
  //                                 itemHeight: 50,
  //                                 // dropdownWidth: (widget.model.mainContentWidth)! - 100,
  //                                 focusColor: Colors.grey.shade100,
  //                                 items: [for(var i=2; i<100; i+=1) i].where((element) => element != 0).map(
  //                                         (e) => DropdownMenuItem<int>(
  //                                         onTap: () {
  //
  //                                           setState(() {
  //                                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesQuantityChanged(e));
  //
  //                                             if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 12) > e) {
  //                                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMaximumGroupQuantityChanged(e));
  //                                               if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.minimumGroupQuantity ?? 6) > e) {
  //                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMinimumGroupQuantityChanged(e - 1));
  //                                               }
  //                                             }
  //                                           });
  //
  //                                         },
  //                                         value: e,
  //                                         child: Text('$e ${AppLocalizations.of(context)!.profileUserOverviewSlots}', style: TextStyle(color: widget.model.disabledTextColor)
  //                                       )
  //                                     )
  //                                   ).toList()
  //                                 )
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ),
  //
  //                       const SizedBox(height: 15),
  //                       Visibility(
  //                         visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.isAllowedGroupAttendance ?? true),
  //                         child: Container(
  //                             width: 375,
  //                             decoration: BoxDecoration(
  //
  //                               border: Border.all(color: widget.model.paletteColor, width: 2),
  //                               borderRadius: BorderRadius.all(Radius.circular(20)),
  //                             ),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text('Also:', style: TextStyle(color: widget.model.paletteColor)),
  //                                   Text('The Size of ${((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.passQuantity ?? 1).round() / (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 1)).toStringAsFixed(0)} Groups', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))
  //                                 ],
  //                               ),
  //                             )
  //                         ),
  //                       ),
  //
  //
  //                       // Visibility(
  //                       //   visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.sessionType == ActivitySessionType.recurring,
  //                       //   child: Column(
  //                       //     mainAxisAlignment: MainAxisAlignment.start,
  //                       //     crossAxisAlignment: CrossAxisAlignment.start,
  //                       //     children: [
  //                       //       SizedBox(height: 25),
  //                       //       Text('Pass Coverage', style: TextStyle(
  //                       //           color: widget.model.paletteColor,
  //                       //           fontWeight: FontWeight.bold,
  //                       //           fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       //       Text('How many sessions will a pass cover?', style: TextStyle(color: widget.model.paletteColor)),
  //                       //       SizedBox(height: 10),
  //                       //
  //                       //       RadioListTile(
  //                       //         toggleable: true,
  //                       //         value: 'All',
  //                       //         groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.recurringPassAllSession ?? true) ? 'All' : null,
  //                       //         onChanged: (String? value) {
  //                       //
  //                       //           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.recurringPassAllSession ?? true) {
  //                       //             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesCoverAllSessions(false));
  //                       //           } else {
  //                       //             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesCoverAllSessions(true));
  //                       //           }
  //                       //
  //                       //         },
  //                       //         activeColor: widget.model.paletteColor,
  //                       //         title: Text('All Session', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       //       ),
  //                       //     ],
  //                       //   )
  //                       // ),
  //
  //
  //
  //                       Visibility(
  //                         visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? true),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             SizedBox(height: 10),
  //                             Text('How many sessions will a pass cover?', style: TextStyle(color: widget.model.paletteColor)),
  //                             Text('Covers Sessions', style: TextStyle(color: widget.model.paletteColor)),
  //                             SizedBox(height: 10),
  //                             Container(
  //                               width: 375,
  //                               child: DropdownButtonHideUnderline(
  //                                   child: DropdownButton2(
  //                                       offset: const Offset(-10,-15),
  //                                       isDense: true,
  //                                       buttonElevation: 0,
  //                                       buttonDecoration: BoxDecoration(
  //                                         color: Colors.transparent,
  //                                         borderRadius: BorderRadius.circular(35),
  //                                       ),
  //                                       customButton: Container(
  //                                         decoration: BoxDecoration(
  //                                           color: widget.model.accentColor,
  //                                           borderRadius: BorderRadius.circular(35),
  //                                         ),
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(2.5),
  //                                           child: Row(
  //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                             children: [
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 8.0),
  //                                                 child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
  //                                               ),
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(right: 8.0),
  //                                                 child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       onChanged: (Object? navItem) {
  //                                       },
  //                                       buttonWidth: 80,
  //                                       buttonHeight: 70,
  //                                       dropdownElevation: 1,
  //                                       dropdownPadding: const EdgeInsets.all(1),
  //                                       dropdownDecoration: BoxDecoration(
  //                                           boxShadow: [BoxShadow(
  //                                               color: Colors.black.withOpacity(0.11),
  //                                               spreadRadius: 1,
  //                                               blurRadius: 15,
  //                                               offset: Offset(0, 2)
  //                                           )
  //                                           ],
  //                                           color: widget.model.cardColor,
  //                                           borderRadius: BorderRadius.circular(14)),
  //                                       itemHeight: 50,
  //                                       // dropdownWidth: (widget.model.mainContentWidth)! - 100,
  //                                       focusColor: Colors.grey.shade100,
  //                                       items: [for(var i=0; i<100; i+=1) i].where((element) => element != 0).map(
  //                                               (e) => DropdownMenuItem<int>(
  //                                               onTap: () {
  //                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesCoverLimitedSession(e));
  //
  //                                                 if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 0) > e) {
  //                                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.passesMaximumGroupQuantityChanged(e));
  //                                                 }
  //
  //                                               },
  //                                               value: e,
  //                                               child: Text('$e ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(color: widget.model.disabledTextColor)
  //                                     )
  //                                   )
  //                                 ).toList()
  //                               )
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ]
  //               ),
  //                 )
  //             )
  //           ),
  //         );
  //       }
  //     )
  //   );
  // }
}