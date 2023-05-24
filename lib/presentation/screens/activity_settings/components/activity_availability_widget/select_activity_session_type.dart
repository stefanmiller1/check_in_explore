import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import 'activity_duration_helper.dart';
import 'widget/activity_session_editor_widget.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

//
// class ActivitySessionTypeSelection extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivitySessionTypeSelection({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivitySessionTypeSelection> createState() => _ActivitySessionTypeSelectionState();
// }
//
// class _ActivitySessionTypeSelectionState extends State<ActivitySessionTypeSelection> {
//
//   String? _sessionAmount;
//   AvailabilitySessionOption? _selectedSessionOption;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0) >= 2)) {
//       _sessionAmount = 'MultiSession';
//     }
//
//     return Center(
//         child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: SingleChildScrollView(
//           child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//               Text(AppLocalizations.of(context)!.activityAvailabilitySessionsTitle, style: TextStyle(
//                   color: widget.model.paletteColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: widget.model.secondaryQuestionTitleFontSize)),
//               const SizedBox(height: 10),
//               Container(
//                 width: 375,
//                 child: DropdownButtonHideUnderline(
//                     child: DropdownButton2(
//                         offset: const Offset(-10,-15),
//                         isDense: true,
//                         buttonElevation: 0,
//                         buttonDecoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(35),
//                         ),
//                         customButton: Container(
//                           decoration: BoxDecoration(
//                             color: widget.model.accentColor,
//                             borderRadius: BorderRadius.circular(35),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 8.0),
//                                   child: Text((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == null) ? AppLocalizations.of(context)!.facilitiesSelect : getSessionTypeName(context, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType ?? ActivitySessionType.recurring), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         onChanged: (Object? navItem) {
//                         },
//                         buttonWidth: 80,
//                         buttonHeight: 70,
//                         dropdownElevation: 1,
//                         dropdownPadding: const EdgeInsets.all(1),
//                         dropdownDecoration: BoxDecoration(
//                             boxShadow: [BoxShadow(
//                                 color: Colors.black.withOpacity(0.11),
//                                 spreadRadius: 1,
//                                 blurRadius: 15,
//                                 offset: Offset(0, 2)
//                             )
//                             ],
//                             color: widget.model.cardColor,
//                             borderRadius: BorderRadius.circular(14)),
//                             itemHeight: 50,
//                             dropdownWidth: (widget.model.mainContentWidth)! - 100,
//                             focusColor: Colors.grey.shade100,
//                             items: ActivitySessionType.values.map(
//                                 (e) => DropdownMenuItem<ActivitySessionType>(
//                                 onTap: () {
//                                   setState(() {
//                                     context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activitySessionTypeChanged(e));
//                                   });
//                                 },
//                                 value: e,
//                                 child: Text(getSessionTypeName(context, e), style: TextStyle(color: widget.model.disabledTextColor)
//                         )
//                       )
//                     ).toList()
//                   )
//                 ),
//               ),
//               SizedBox(height: 15),
//               Visibility(
//                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(AppLocalizations.of(context)!.activityAvailabilitySessionsMultiDays, style: TextStyle(
//                             color: widget.model.paletteColor,
//                             fontWeight: FontWeight.bold)),
//                         Text(AppLocalizations.of(context)!.activityAvailabilitySessionsMultiDaysHint, style: TextStyle(
//                             color: widget.model.paletteColor)),
//                       ]
//                   )
//               ),
//               Visibility(
//                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.recurring,
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(AppLocalizations.of(context)!.activityAvailabilitySessionsRecurring, style: TextStyle(
//                             color: widget.model.paletteColor,
//                             fontWeight: FontWeight.bold)),
//                         Text(AppLocalizations.of(context)!.activityAvailabilitySessionsRecurringHint, style: TextStyle(
//                             color: widget.model.paletteColor)),
//                       ]
//                   )
//               ),
//
//
//               SizedBox(height: 15),
//               Visibility(
//                 visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.recurring,
//                 child: Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'DayBased',
//                         groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? false) ? 'DayBased' : null,
//                         onChanged: (String? value) {
//
//                           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? false) {
//                             context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isDayBasedChanged(false));
//                           } else {
//                             context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isDayBasedChanged(true));
//                           }
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(AppLocalizations.of(context)!.activityAvailabilitySessionsAmountDayBased, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                             Text(AppLocalizations.of(context)!.activityAvailabilitySessionsAmountDayBasedHint, style: TextStyle(color: widget.model.paletteColor)),
//                           ],
//                         ),
//                       ),
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'TimeBased',
//                         groupValue: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? true) ? 'TimeBased' : null,
//                         onChanged: (String? value) {
//
//                           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? true) {
//                             context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isDayBasedChanged(false));
//                           } else {
//                             context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isDayBasedChanged(true));
//                           }
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(AppLocalizations.of(context)!.activityAvailabilitySessionsAmountTimeBased, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                             Text(AppLocalizations.of(context)!.activityAvailabilitySessionsAmountTimeBasedHint, style: TextStyle(color: widget.model.paletteColor)),
//                           ],
//                         ),
//                       ),
//
//
//                     ],
//                   ),
//                 ),
//               ),
//
//
//               Visibility(
//                 visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
//                 child: Container(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'Single',
//                         groupValue: _sessionAmount,
//                         onChanged: (String? value) {
//
//                           setState(() {
//                             if (_sessionAmount == 'Single') {
//                               _sessionAmount = null;
//                             } else {
//                               _sessionAmount = 'Single';
//                               context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.clear();
//                               AvailabilitySessionOption session = AvailabilitySessionOption(sessionPeriod: DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding), sessionTitle: BackgroundInfoTitle(''), sessionDescription: BackgroundInfoDescription(''));
//                               context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.sessionsDetailsChanged([session]));
//                             }
//                           });
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Text('1 ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       ),
//                       RadioListTile(
//                         toggleable: true,
//                         value: 'MultiSession',
//                         groupValue: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0) >= 2) ? 'MultiSession' : _sessionAmount,
//                         onChanged: (String? value) {
//
//                           setState(() {
//                             if (_sessionAmount == 'MultiSession') {
//                               _sessionAmount = null;
//                             } else {
//                               _sessionAmount = 'MultiSession';
//                             }
//                           });
//
//                         },
//                         activeColor: widget.model.paletteColor,
//                         title: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(AppLocalizations.of(context)!.activityAvailabilitySessionsMulti, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                             Text(AppLocalizations.of(context)!.activityAvailabilitySessionsMultiHint, style: TextStyle(color: widget.model.paletteColor)),
//                           ],
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//
//               Visibility(
//                 visible:  _sessionAmount == 'MultiSession' && context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 15),
//                     Text(AppLocalizations.of(context)!.facilityAvailableHoursFrom, style: TextStyle(color: widget.model.paletteColor)),
//                     SizedBox(height: 5),
//                     Container(
//                       width: 375,
//                       child: DropdownButtonHideUnderline(
//                           child: DropdownButton2(
//                               offset: const Offset(-10,-15),
//                               isDense: true,
//                               buttonElevation: 0,
//                               buttonDecoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 borderRadius: BorderRadius.circular(35),
//                               ),
//                               customButton: Container(
//                                 decoration: BoxDecoration(
//                                   color: widget.model.accentColor,
//                                   borderRadius: BorderRadius.circular(35),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(2.5),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 8.0),
//                                         child: Text('${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0} ${AppLocalizations.of(context)!.profileEventsActivityTableSessions}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 8.0),
//                                         child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               onChanged: (Object? navItem) {
//                               },
//                               buttonWidth: 80,
//                               buttonHeight: 70,
//                               dropdownElevation: 1,
//                               dropdownPadding: const EdgeInsets.all(1),
//                               dropdownDecoration: BoxDecoration(
//                                   boxShadow: [BoxShadow(
//                                       color: Colors.black.withOpacity(0.11),
//                                       spreadRadius: 1,
//                                       blurRadius: 15,
//                                       offset: Offset(0, 2)
//                                   )
//                                   ],
//                                   color: widget.model.cardColor,
//                                   borderRadius: BorderRadius.circular(14)),
//                               itemHeight: 50,
//                               dropdownWidth: (widget.model.mainContentWidth)! - 100,
//                               focusColor: Colors.grey.shade100,
//                               items: [for(var i=0; i<(DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays + 1); i+=1) i].where((element) => element != 0).map(
//                                       (e) => DropdownMenuItem<int>(
//                                       onTap: () {
//
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.clear();
//
//                                       setState(() {
//                                        for (int day in [for (var f=0; f<e; f+=1) f]) {
//
//                                          if (day == 0) {
//
//                                           AvailabilitySessionOption session = AvailabilitySessionOption(
//                                               sessionPeriod: DateTimeRange(
//                                                   start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                                                   end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(
//                                                       days: getNumberOfRangeSessionsToAdd(e, DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays))
//                                           )), sessionTitle: BackgroundInfoTitle(''), sessionDescription: BackgroundInfoDescription(''));
//                                           context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.add(session);
//
//                                           } else if (day >= 1 && day <= [for (var f=0; f<e; f+=1) f].length - 2) {
//
//                                            AvailabilitySessionOption session = AvailabilitySessionOption(
//                                                sessionPeriod: DateTimeRange(
//                                                    start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(
//                                                        days: day * getNumberOfRangeSessionsToAdd(e, DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays))),
//                                                    end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(
//                                                        days: (day * getNumberOfRangeSessionsToAdd(e, DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays)) + getNumberOfRangeSessionsToAdd(e, DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays))
//                                                    )), sessionTitle: BackgroundInfoTitle(''), sessionDescription: BackgroundInfoDescription(''));
//
//                                            context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.add(session);
//
//                                           } else if (day >= [for (var f=0; f<e; f+=1) f].length - 2) {
//
//                                            AvailabilitySessionOption session = AvailabilitySessionOption(
//                                                sessionPeriod: DateTimeRange(
//                                                    start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(
//                                                        days: day * getNumberOfRangeSessionsToAdd(e, DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays))),
//                                                    end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding),
//                                                sessionTitle: BackgroundInfoTitle(''), sessionDescription: BackgroundInfoDescription(''));
//
//                                            context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.add(session);
//
//                                           }
//                                         }
//
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.sessionsDetailsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails ?? []));
//                                         });
//                                       },
//                                       value: e,
//                                       child: Text('$e ${AppLocalizations.of(context)!.profileEventsActivityTableSessions}', style: TextStyle(color: widget.model.disabledTextColor)
//                                       )
//                               )
//                             ).toList()
//                           )
//                         ),
//                       ),
//                     // profileEventsActivityTableSessions
//                   ],
//                 )
//               ),
//
//               Visibility(
//                 visible: (((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0) >= 1) && context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 15),
//
//                     Text('Create A Program For Each Session', style: TextStyle(color: widget.model.paletteColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                     Text('Design How You Want To Organize Your Activity. Give A Breakdown of Exactly What you are Planning To Offer - Treat Multi-Day Sessions Like A Opportunity To Offer a well delivered multi day event package so everyone can know the ride they will be joining.', style: TextStyle(
//                         color: widget.model.paletteColor
//                     )),
//
//                     SizedBox(height: 25),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border.all(width: 1, color: widget.model.paletteColor),
//                         borderRadius: BorderRadius.all(Radius.circular(35)),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.asMap().map(
//                               (i, value) {
//                             return MapEntry(i, Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: TextButton(
//                                 style: ButtonStyle(
//                                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                           (Set<MaterialState> states) {
//                                         if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                           return widget.model.paletteColor.withOpacity(0.1);
//                                         }
//                                         if (states.contains(MaterialState.hovered)) {
//                                           return widget.model.paletteColor.withOpacity(0.1);
//                                         }
//                                         return widget.model.accentColor.withOpacity(0.6); // Use the component's default.
//                                       },
//                                     ),
//                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                           side: (_selectedSessionOption == value) ? BorderSide(width: 2, color: widget.model.paletteColor) : BorderSide(width: 2, color: Colors.transparent),
//                                           borderRadius: const BorderRadius.all(Radius.circular(30)),
//                                         )
//                                     )
//                                 ),
//                                 onPressed: () {
//
//                                     showDialog(
//                                         context: context,
//                                         builder: (BuildContext contexts) {
//                                           return ActivitySessionEditorWidget(
//                                             model: widget.model,
//                                             selectedSession: value,
//                                             sessionNumber: '${i+1}',
//                                             previousTime: (i != 0) ? (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?[i - 1].sessionPeriod.start.add(Duration(days: 1)) ?? DateTime.now()) : (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?[i].sessionPeriod.start ?? DateTime.now()),
//                                             saveSession: (AvailabilitySessionOption session) {
//
//                                               context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.replaceRange(i, i+1, [session]);
//
//                                               setState(() {
//                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.sessionsDetailsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails ?? []));
//                                                 Navigator.of(contexts).pop();
//                                               });
//
//                                         },
//                                       );
//                                     }
//                                   );
//                                 },
//                                 child: Container(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.end,
//                                           mainAxisAlignment: MainAxisAlignment.end,
//                                           children: [
//                                             SizedBox(width: 10),
//                                             Text('Session ${i+1}:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//                                             SizedBox(width: 10),
//                                             Expanded(
//                                               child: Column(
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       color: (i == 0) ? widget.model.disabledTextColor.withOpacity(0.1) : ((0.15 * i) <= 1) ? widget.model.paletteColor.withOpacity(0.15 * i) : widget.model.paletteColor,
//                                                       borderRadius: BorderRadius.circular(35),
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Row(
//                                                         children: [
//                                                           SizedBox(width: 10),
//                                                           Icon(Icons.calendar_today, size: 30, color: (i == 0) ? widget.model.disabledTextColor : widget.model.accentColor),
//                                                           SizedBox(width: 10),
//                                                           Expanded(
//                                                             child: Column(
//                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                               children: [
//                                                                 Text('${DateFormat.MMMMd().format(value.sessionPeriod.start)} - ${DateFormat.MMMMd().format(value.sessionPeriod.end)}', style: TextStyle(color: (i == 0) ? widget.model.disabledTextColor : widget.model.accentColor)),
//                                                                 Text('${DateFormat.EEEE().format(value.sessionPeriod.start)} - ${DateFormat.EEEE().format(value.sessionPeriod.end)}', style: TextStyle(color: (i == 0) ? widget.model.disabledTextColor : widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                                               ],
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 5),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.transparent,
//                                                       border: Border.all(width: 1, color: widget.model.accentColor),
//                                                       borderRadius: BorderRadius.all(Radius.circular(35)),
//                                                     ),
//                                                     child: !(value.sessionTitle.isValid()) ? Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text('Name', style: TextStyle(color: widget.model.paletteColor)),
//                                                     ) : Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text(value.sessionTitle.getOrCrash(), style: TextStyle(color: widget.model.paletteColor, )),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 5),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.transparent,
//                                                       border: Border.all(width: 1, color: widget.model.accentColor),
//                                                       borderRadius: BorderRadius.all(Radius.circular(35)),
//                                                     ),
//                                                     child: !(value.sessionDescription.isValid()) ? Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text('Description: This Session Will Focus On... ', style: TextStyle(color: widget.model.paletteColor)),
//                                                     ) : Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Text(value.sessionDescription.getOrCrash(), style: TextStyle(color: widget.model.paletteColor)),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             )
//                                           ]
//                                         ),
//                                       )
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).values.toList() ?? []
//                         ),
//                       ),
//                     ),
//                   ]
//                 )
//               ),
//
//
//               Visibility(
//                 visible: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? true) && context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.recurring,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 25.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 15),
//                         Text(AppLocalizations.of(context)!.facilityAvailableSlots, style: TextStyle(
//                             color: widget.model.paletteColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                         Text(AppLocalizations.of(context)!.activityAvailabilitySessionsAmountTimeBasedDescription, style: TextStyle(
//                             color: widget.model.paletteColor)),
//                         SizedBox(height: 10),
//
//                         RadioListTile(
//                           toggleable: true,
//                           value: '30Min',
//                           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isThirtyMinutesPer ?? false) ? '30Min' : null,
//                           onChanged: (String? value) {
//
//                             setState(() {
//                               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isThirtyMinutesPer ?? false) {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isThirtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSixtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTwoHoursPerChanged(false));
//                               } else {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isThirtyMinutesPerChanged(true));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSixtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTwoHoursPerChanged(false));
//                               }
//                             });
//
//                           },
//                           activeColor: widget.model.paletteColor,
//                           title: Text('30 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                         ),
//
//                         RadioListTile(
//                           toggleable: true,
//                           value: '60Min',
//                           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false) ? '60Min' : null,
//                           onChanged: (String? value) {
//
//                             setState(() {
//                               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false) {
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isThirtyMinutesPerChanged(false));
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSixtyMinutesPerChanged(false));
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTwoHoursPerChanged(false));
//                               } else {
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isThirtyMinutesPerChanged(false));
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSixtyMinutesPerChanged(true));
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTwoHoursPerChanged(false));
//                               }
//                             });
//
//                           },
//                           activeColor: widget.model.paletteColor,
//                           title: Text('60 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                         ),
//
//
//                         RadioListTile(
//                           toggleable: true,
//                           value: '2Hours',
//                           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false) ? '2Hours' : null,
//                           onChanged: (String? value) {
//
//                             setState(() {
//                               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false) {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isThirtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSixtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTwoHoursPerChanged(false));
//                               } else {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isThirtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSixtyMinutesPerChanged(false));
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTwoHoursPerChanged(true));
//                               }
//                             });
//
//                           },
//                           activeColor: widget.model.paletteColor,
//                           title: Text('2 ${AppLocalizations.of(context)!.facilityAvailableSlotHours}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                         ),
//
//                     ],
//                   ),
//                 )
//               )
//             ]
//           ),
//         )
//         )
//     );
//   }
// }