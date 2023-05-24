import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/activity_pricing_per_hour_widget.dart';
import 'package:dartz/dartz.dart' as dart;

// class ActivityAddPricingRequirement extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivityAddPricingRequirement({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivityAddPricingRequirement> createState() => _ActivityAddPricingRequirementState();
// }
//
// class _ActivityAddPricingRequirementState extends State<ActivityAddPricingRequirement> {
//
//   TextEditingController? ticketBasedSlot;
//   TextEditingController? singlePassBasedSlot;
//   TextEditingController? groupPassBasedSlot;
//   List<CostPerHourSettingOption> savedRecurringCostSettings = [];
//   // List<List<FeeRangeItem>> savedFeeRanges = [];
//   // List<int> filteredWeekDays = [];
//   List<FeeRangeItem> feeItem = [];
//
//   @override
//   void initState() {
//
//     ticketBasedSlot = TextEditingController();
//     singlePassBasedSlot = TextEditingController();
//     groupPassBasedSlot = TextEditingController();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//
//     ticketBasedSlot?.dispose();
//     singlePassBasedSlot?.dispose();
//     groupPassBasedSlot?.dispose();
//
//     super.dispose();
//   }
//
//   void rebuild(BuildContext context) {
//     if (ticketBasedSlot?.text != context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.defaultFeeTickets) {
//       ticketBasedSlot?.text = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.defaultFeeTickets ?? '';
//     }
//
//     if (singlePassBasedSlot?.text != context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.defaultFeePasses) {
//       singlePassBasedSlot?.text = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.defaultFeePasses ?? '';
//     }
//
//     if (groupPassBasedSlot?.text != context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.defaultFeeGroupPasses) {
//       groupPassBasedSlot?.text = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.defaultFeeGroupPasses ?? '';
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//         // rebuild(context);
//
//         return Scaffold(
//               appBar: AppBar(
//               elevation: 0,
//               backgroundColor: widget.model.paletteColor,
//               title: Text('Pricing', style: TextStyle(color: widget.model.accentColor)),
//               actions: [
//
//               ],
//             ),
//           body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Visibility(
//               visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.recurring,
//               child: getContainerForRecurringEvent(context)
//             ),
//
//             Visibility(
//               visible:  context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
//               child: getContainerForMultiDayEvent(context),
//             )
//
//
//                 ]
//               )
//             ),
//           );
//         }
//       )
//     );
//   }
//
//   Widget getContainerForRecurringEvent(BuildContext context) {
//
//     // if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityCost.costSettingsRecurring.isEmpty) {
//     //   for (int openDays in context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).map((e) => e.dayOfWeek)) {
//     //       context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityCost.costSettingsRecurring.add(CostPerHourSettingOption(dayOfWeek: openDays, feeDuringHourRange: []));
//     //       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeRecurringSettingsChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityCost.costSettingsRecurring));
//     //   }
//     // }
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: widget.model.accentColor,
//               borderRadius: BorderRadius.all(Radius.circular(20))
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Text('Recurring Activity', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//           ),
//         ),
//         SizedBox(height: 20),
//
//         Text(AppLocalizations.of(context)!.activityPaymentRecurringDynamicTitle, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//         SizedBox(height: 10),
//
//         RadioListTile(
//           toggleable: true,
//           value: 'Fixed',
//           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isFixedHours ?? false) ? 'Fixed' : null,
//           onChanged: (String? value) {
//
//             setState(() {
//               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isFixedHours ?? false) {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(false));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(false));
//               } else {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(true));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(false));
//               }
//             });
//
//           },
//           activeColor: widget.model.paletteColor,
//           title: Text(AppLocalizations.of(context)!.activityPaymentRecurringStatic, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//         ),
//
//         RadioListTile(
//           toggleable: true,
//           value: 'Dynamic',
//           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false) ? 'Dynamic' : null,
//           onChanged: (String? value) {
//
//             setState(() {
//
//               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false) {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(false));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(false));
//               } else {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(true));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(false));
//               }
//
//             });
//
//           },
//           activeColor: widget.model.paletteColor,
//           title: Text(AppLocalizations.of(context)!.activityPaymentRecurringDynamic, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//         ),
//
//         SizedBox(height: 25),
//
//         Center(
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               Text(AppLocalizations.of(context)!.activityPaymentRecurringDynamicChange, style: TextStyle(color: widget.model.paletteColor)),
//             ],
//           ),
//         ),
//
//         SizedBox(height: 30),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   border: Border.all(width: 2, color: widget.model.paletteColor),
//                   borderRadius: BorderRadius.all(Radius.circular(35))
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Text('Default Ticket', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//
//                     Container(
//                       // width: (widget.model.mainContentWidth)! - 100,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                         child: getTimeSlotAmount(
//                             AppLocalizations.of(context)!.facilityCostingTimeSlot('0'),
//                             AppLocalizations.of(context)!.facilityCostingPerSlot,
//                             AppLocalizations.of(context)!.facilityCostingEstimate('${(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 1) * 15 * 8}'),
//                             context,
//                             true,
//                             false,
//                             widget.model,
//                             ticketBasedSlot!,
//                             updateTextNow: (String e) {
//                               if (e == "\$0.00") {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultTicketChanged(''));
//                               } else {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultTicketChanged(e));
//                             }
//                           }
//                         ),
//                       ),
//                     ),
//
//                     Text('We Estimate \$${(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 1) * 15} Per Hour', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                     Text('Up to ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 0} Attendees', style: TextStyle(color: widget.model.paletteColor)),
//
//                     SizedBox(height: 20),
//                     Visibility(
//                       visible: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false),
//                       child: Container(
//                         height: 40,
//                         child: TextButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                   (Set<MaterialState> states) {
//                                 if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                   return widget.model.paletteColor.withOpacity(0.1);
//                                 }
//                                 if (states.contains(MaterialState.hovered)) {
//                                   return widget.model.paletteColor.withOpacity(0.1);
//                                 }
//                                 return widget.model.accentColor; // Use the component's default.
//                               },
//                             ),
//                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   side: BorderSide(width: 1, color: widget.model.disabledTextColor),
//                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
//                               )
//                             ),
//                           ),
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext contexts) {
//                                   return ActivityPricingPerHourFilterWidget(
//                                     model: widget.model,
//                                     selectedDayOfWeek: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed != true).map((e) => e.dayOfWeek).first,
//                                     selectableWeekDay: [1,2,3,4,5,6,7],
//                                     disabledWeekDays: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed != true).map((e) => e.dayOfWeek).toList(),
//                                     selectedFeeOption: [],
//                                     isSingleTicketBased: true,
//                                     isSinglePassBased: false,
//                                     isGroupPassBased: false,
//                                     saveOptions: (List<CostPerHourSettingOption> savedList) {
//                                       feeItem.clear();
//
//                                       for (CostPerHourSettingOption weekDays in savedList) {
//                                         feeItem.addAll(weekDays.feeDuringHourRange);
//                                         int index = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.indexWhere((element) => element.dayOfWeek == weekDays.dayOfWeek);
//                                         context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.replaceRange(index, index+1, [CostPerHourSettingOption(dayOfWeek: weekDays.dayOfWeek, feeDuringHourRange: feeItem.toSet().toList())]);
//                                       }
//
//                                       setState(() {
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeRecurringSettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.toSet().toList()));
//                                         Navigator.pop(contexts);
//                                       });
//
//
//                                   },
//                                 );
//                               }
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                             child: Text('Dynamic Tickets', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                       ),
//                     ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(height: 10),
//
//         Visibility(
//           visible: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false),
//           child: Column(
//             children: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.asMap().map(
//                       (i, e) {
//                     if (e.feeDuringHourRange.isNotEmpty) {
//                       return MapEntry(i, Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                   (Set<MaterialState> states) {
//                                 if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                   return widget.model.paletteColor.withOpacity(0.1);
//                                 }
//                                 if (states.contains(MaterialState.hovered)) {
//                                   return widget.model.paletteColor.withOpacity(0.1);
//                                 }
//                                 return widget.model.accentColor; // Use the component's default.
//                               },
//                             ),
//                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: const BorderRadius.all(Radius.circular(35)),
//                                 )
//                             ),
//                           ),
//                           onPressed: () {
//
//                             print(e.feeDuringHourRange);
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext contexts) {
//                                   return ActivityPricingPerHourFilterWidget(
//                                     model: widget.model,
//                                     selectedDayOfWeek: e.dayOfWeek,
//                                     selectableWeekDay: [1,2,3,4,5,6,7],
//                                     disabledWeekDays: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed != true).map((e) => e.dayOfWeek).toList(),
//                                     selectedFeeOption: e.feeDuringHourRange,
//                                     isSingleTicketBased: true,
//                                     isSinglePassBased: false,
//                                     isGroupPassBased: false,
//                                     saveOptions: (List<CostPerHourSettingOption> savedList) {
//                                       feeItem.clear();
//
//                                       for (CostPerHourSettingOption weekDays in savedList) {
//                                         feeItem.addAll(weekDays.feeDuringHourRange);
//                                         int index = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.indexWhere((element) => element.dayOfWeek == weekDays.dayOfWeek);
//                                         context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.replaceRange(index, index+1, [CostPerHourSettingOption(dayOfWeek: weekDays.dayOfWeek, feeDuringHourRange: feeItem.toSet().toList())]);
//                                       }
//
//                                       setState(() {
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeRecurringSettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsRecurring.toSet().toList()));
//                                         Navigator.pop(contexts);
//                                       });
//
//
//                                     },
//                                   );
//                                 }
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
//                             child: Container(
//                               width: 425,
//                               decoration: BoxDecoration(
//                                   color: widget.model.paletteColor,
//                                   border: Border.all(width: 2, color: widget.model.accentColor),
//                                   borderRadius: BorderRadius.all(Radius.circular(35))
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     Text(dayOfTheWeek(context, e.dayOfWeek), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                     Text('Additional Fee Settings', style: TextStyle(color: widget.model.accentColor)),
//                                     ...e.feeDuringHourRange.map(
//                                             (f) => Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             children: [
//                                               SizedBox(height: 2),
//                                               Visibility(
//                                                 visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? false,
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text('Fee For Time Based Ticket ${DateFormat.jm().format(f.period.start)} - ${DateFormat.jm().format(f.period.end)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                                     Container(
//                                                         child: Text('${f.feeBasedOnTicketType ?? ''} Per Day', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                                   ],
//                                                 ),
//                                               ),
//
//                                               Visibility(
//                                                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isThirtyMinutesPer ?? false,
//                                                   child: Column(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text('Fee For Time Based Ticket ${DateFormat.jm().format(f.period.start)} - ${DateFormat.jm().format(f.period.end)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                                       Container(
//                                                           child: Text('${f.feeBasedOnTicketType ?? ''} Per 30 minutes', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                                     ],
//                                                   )
//                                               ),
//
//                                               Visibility(
//                                                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false,
//                                                   child: Column(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text('Fee For Time Based Ticket ${DateFormat.jm().format(f.period.start)} - ${DateFormat.jm().format(f.period.end)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                                       Container(
//                                                           child: Text('${f.feeBasedOnTicketType ?? ''} Per 60 minutes', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                                     ],
//                                                   )
//                                               ),
//
//                                               Visibility(
//                                                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false,
//                                                   child: Column(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text('Fee For Time Based Ticket ${DateFormat.jm().format(f.period.start)} - ${DateFormat.jm().format(f.period.end)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                                       Container(
//                                                           child: Text('${f.feeBasedOnTicketType ?? ''} Per 2 hours', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                                     ],
//                                                   )
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                     ).toList()
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       );
//                     } else {
//                     return MapEntry(i, Container());
//                   }
//                 }
//               ).values.toList(),
//           ),
//         ),
//             SizedBox(height: 15),
//             Divider(thickness: 1, color: widget.model.paletteColor),
//         ],
//           ),
//
//
//         SizedBox(height: 15),
//         Visibility(
//           visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.isPassBased ?? false,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(AppLocalizations.of(context)!.activityPaymentRecurringSinglePassesTimeBased, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//               Text('Covers ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0} Sessions', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//
//               SizedBox(height: 7),
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     border: Border.all(width: 2, color: widget.model.paletteColor),
//                     borderRadius: BorderRadius.all(Radius.circular(35))
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//
//                     children: [
//                       Text('Default Fee For Single Passes', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                       Container(
//                         // width: (widget.model.mainContentWidth)! - 100,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                           child: getTimeSlotAmount(
//                               AppLocalizations.of(context)!.facilityCostingTimeSlot('60'),
//                               AppLocalizations.of(context)!.facilityCostingPerSlot,
//                               AppLocalizations.of(context)!.facilityCostingEstimate('100'),
//                               context,
//                               true,
//                               false,
//                               widget.model,
//                               singlePassBasedSlot!,
//                               updateTextNow: (String e) {
//                                 if (e == "\$0.00") {
//                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultPassesChanged(''));
//                                 } else {
//                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultPassesChanged(e));
//                               }
//                             }
//                           ),
//                         ),
//                       ),
//
//                       Text('We Estimate \$${(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 1) * 15} Per Hour', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                       Text('Up to ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 0} Attendees', style: TextStyle(color: widget.model.paletteColor)),
//
//                       SizedBox(height: 8),
//
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               /// list for single passes ///
//
//               SizedBox(height: 15),
//               Divider(thickness: 1, color: widget.model.paletteColor),
//             ],
//           )
//         ),
//
//
//         SizedBox(height: 15),
//         Visibility(
//           visible: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.isPassBased ?? false) && (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.isAllowedGroupAttendance ?? false),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Set Fee For Group Passes', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//               Text('${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.minimumGroupQuantity ?? 0} Attendees Min Per Group - ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 0} Attendees Max Per Group', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//               Text('Covers ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0} Sessions', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//               SizedBox(height: 7),
//
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   border: Border.all(width: 2, color: widget.model.paletteColor),
//                   borderRadius: BorderRadius.all(Radius.circular(35))
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Text('Default Fee For Group Passes', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//
//                     Container(
//                       // width: (widget.model.mainContentWidth)! - 100,
//                       child: Padding(
//                         padding:const EdgeInsets.only(left: 30.0, right: 30.0),
//                         child: getTimeSlotAmount(
//                             AppLocalizations.of(context)!.facilityCostingTimeSlot('120'),
//                             AppLocalizations.of(context)!.facilityCostingPerSlot,
//                             AppLocalizations.of(context)!.facilityCostingEstimate('${(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 1) * 30}'),
//                             context,
//                             true,
//                             false,
//                             widget.model,
//                             groupPassBasedSlot!,
//                             updateTextNow: (String e) {
//                               if (e == "\$0.00") {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultGroupPassesChanged(''));
//                               } else {
//                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultGroupPassesChanged(e));
//                               }
//                             }
//                           ),
//                         ),
//                       ),
//
//                       Text('We Estimate \$${(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 1) * 15} Per Hour', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                       Text('Up to ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityTickets?.ticketQuantity ?? 0} Attendees', style: TextStyle(color: widget.model.paletteColor)),
//
//                       SizedBox(height: 8),
//
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// list for group passes ///
//               SizedBox(height: 10),
//
//             ],
//           )
//         ),
//       ],
//     );
//   }
//
//   Widget getContainerForMultiDayEvent(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         Container(
//           decoration: BoxDecoration(
//               color: widget.model.accentColor,
//               borderRadius: BorderRadius.all(Radius.circular(20))
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Text('Multi or Single Day Activity', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//           ),
//         ),
//         SizedBox(height: 20),
//
//         Text(AppLocalizations.of(context)!.activityPaymentMultiDayDynamicTitle, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//         SizedBox(height: 10),
//
//         RadioListTile(
//           toggleable: true,
//           value: 'Fixed',
//           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isFixedHours ?? false) ? 'Fixed' : null,
//           onChanged: (String? value) {
//
//             setState(() {
//               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isFixedHours ?? false) {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(false));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(false));
//               } else {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(true));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(false));
//               }
//             });
//
//           },
//           activeColor: widget.model.paletteColor,
//           title: Text(AppLocalizations.of(context)!.activityPaymentRecurringStatic, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//         ),
//
//         RadioListTile(
//           toggleable: true,
//           value: 'Dynamic',
//           groupValue: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false) ? 'Dynamic' : null,
//           onChanged: (String? value) {
//
//             setState(() {
//
//               if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false) {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(false));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(false));
//               } else {
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsDynamicChanged(true));
//                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeIsStaticChanged(false));
//               }
//
//             });
//
//           },
//           activeColor: widget.model.paletteColor,
//           title: Text(AppLocalizations.of(context)!.activityPaymentMultiDayIsDynamic, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//         ),
//
//         SizedBox(height: 25),
//         Text('${AppLocalizations.of(context)!.facilityAvailableBookingsStarting}: ${DateFormat.yMMMMd().format(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting)}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
//
//         Text('${(DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding).duration.inDays/7).ceil()} Week ${getActivityOptions(context).where((element) => element.activity == context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityType.activity).first.title} Session', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
//         SizedBox(height: 10),
//
//         Container(
//             decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 border: Border.all(width: 2, color: widget.model.paletteColor),
//                 borderRadius: BorderRadius.all(Radius.circular(35))
//             ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.asMap().map(
//                       (i , value) => MapEntry(i, Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: Container(
//                               decoration: BoxDecoration(
//                                   color: widget.model.disabledTextColor.withOpacity(0.1),
//                                   borderRadius: BorderRadius.all(Radius.circular(35))
//                               ),
//                               child: Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: Row(
//                                 children: [
//                                   SizedBox(width: 10),
//                                   Icon(Icons.credit_card_sharp, size: 30, color: widget.model.paletteColor),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text('${DateFormat.MMMMd().format(value.sessionPeriod.start)} - ${DateFormat.MMMMd().format(value.sessionPeriod.end)}', style: TextStyle(color: widget.model.paletteColor)),
//                                         Text(value.sessionDescription.value.fold((l) => '', (r) => r), style: TextStyle(color: widget.model.paletteColor)),
//                                         SizedBox(height: 4),
//                                         Text('Session ${i+1}: ${value.sessionTitle.value.fold((l) => '', (r) => r)}', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//                                 ],
//                               )
//                             ),
//                           ],
//                         )
//                       )
//                     ),
//                   ),
//                 )
//               ).values.toList() ?? [],
//             )
//           )
//         ),
//
//         SizedBox(height: 10),
//         Center(child: Text('${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0} Sessions', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 60))),
//         SizedBox(height: 10),
//
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('You can set different fees based on the number of days before the activity starts, you may want to increase the price as the activity gets closer to the start date', style: TextStyle(color: widget.model.paletteColor, )),
//         ),
//
//         Center(
//           child: Column(
//             children: [
//               Text(AppLocalizations.of(context)!.activityPaymentMultiDaySingleDayPass, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//               Text('Default Fee For a Single Pass', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//               SizedBox(height: 7),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   // width: (widget.model.mainContentWidth)! - 100,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                     child: getTimeSlotAmount(
//                         AppLocalizations.of(context)!.facilityCostingTimeSlot('60'),
//                         AppLocalizations.of(context)!.facilityCostingPerSlot,
//                         '100',
//                         context,
//                         true,
//                         false,
//                         widget.model,
//                         singlePassBasedSlot!,
//                         updateTextNow: (String e) {
//                           if (e == "\$0.00") {
//                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultPassesChanged(''));
//                           } else {
//                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultPassesChanged(e));
//                         }
//                       }
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 15),
//               Visibility(
//                 visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false,
//                 child: Column(
//                   children: [
//
//                     ...context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti.asMap().map((i, value) {
//
//                       final TextEditingController feeTextEditor = TextEditingController();
//
//                       if (feeTextEditor.text != value.feeBasedOnPass) {
//                         feeTextEditor.text = value.feeBasedOnPass;
//                       }
//
//                       if (value.isSinglePass) {
//                         return MapEntry(
//                             i, Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(width: 10),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(AppLocalizations.of(context)!.activityPaymentMultiDaySingleDayBefore, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                                     SizedBox(height: 4),
//                                     Container(
//                                       width: 130,
//                                       child: DropdownButtonHideUnderline(
//                                           child: DropdownButton2(
//                                               offset: const Offset(-10,-15),
//                                               isDense: true,
//                                               buttonElevation: 0,
//                                               buttonDecoration: BoxDecoration(
//                                                 color: Colors.transparent,
//                                                 borderRadius: BorderRadius.circular(35),
//                                               ),
//                                               customButton: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: widget.model.accentColor,
//                                                   borderRadius: BorderRadius.circular(35),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(2.5),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(left: 8.0),
//                                                         child: (i == 0) ? Text('${value.daysBeforeStartDate} ${AppLocalizations.of(context)!.days}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)) : Text('${value.daysBeforeStartDate} ${AppLocalizations.of(context)!.days}s', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(right: 8.0),
//                                                         child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               onChanged: (Object? navItem) {
//                                               },
//                                               buttonWidth: 80,
//                                               buttonHeight: 70,
//                                               dropdownElevation: 1,
//                                               dropdownPadding: const EdgeInsets.all(1),
//                                               dropdownDecoration: BoxDecoration(
//                                                   boxShadow: [BoxShadow(
//                                                       color: Colors.black.withOpacity(0.11),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 15,
//                                                       offset: Offset(0, 2)
//                                                   )
//                                                   ],
//                                                   color: widget.model.cardColor,
//                                                   borderRadius: BorderRadius.circular(14)),
//                                               itemHeight: 50,
//                                               // dropdownWidth: (widget.model.mainContentWidth)! - 100,
//                                               focusColor: Colors.grey.shade100,
//                                               items: [for(var i=1; i<100; i+=1) i].where((element) => element != 0).map(
//                                                       (e) => DropdownMenuItem<int>(
//                                                       onTap: () {
//                                                         setState(() {
//
//                                                           context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i].copyWith(
//                                                               daysBeforeStartDate: e
//                                                           );
//                                                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//
//                                                         });
//                                                       },
//                                                       value: e,
//                                                       child: (i == 0) ? Text('$e ${AppLocalizations.of(context)!.days}', style: TextStyle(color: widget.model.disabledTextColor)) : Text('$e ${AppLocalizations.of(context)!.days}s', style: TextStyle(color: widget.model.disabledTextColor)
//                                                       )
//                                                   )
//                                               ).toList()
//                                           )
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 25.0),
//                                         child: Text(AppLocalizations.of(context)!.activityPaymentMultiDaySingleDayPass, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                                       ),
//                                       SizedBox(height: 4),
//                                       Container(
//                                         // width: (widget.model.mainContentWidth)! - 100,
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                                           child: getTimeSlotAmount(
//                                               AppLocalizations.of(context)!.facilityCostingTimeSlot('60'),
//                                               AppLocalizations.of(context)!.facilityCostingPerSlot,
//                                               AppLocalizations.of(context)!.facilityCostingEstimate('100'),
//                                               context,
//                                               true,
//                                               false,
//                                               widget.model,
//                                               feeTextEditor,
//                                               updateTextNow: (String e) {
//
//                                                 if (e == "\$0.00") {
//                                                   context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i].copyWith(
//                                                       feeBasedOnPass: e
//                                                   );
//                                                 } else {
//                                                   context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i].copyWith(
//                                                       feeBasedOnPass: e
//                                                   );
//                                                 }
//                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//
//                                               }
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Padding(
//                                     padding: const EdgeInsets.only(right: 8.0),
//                                     child: IconButton(
//                                         padding: EdgeInsets.zero,
//                                         icon: Icon(Icons.clear, size: 21, color: widget.model.paletteColor),
//                                         onPressed: () {
//                                           setState(() {
//                                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti.removeAt(i);
//                                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//                                         });
//                                       }
//                                     )
//                                   )
//                                 ],
//                               ),
//                             ),
//                           )
//                         );
//                       } else {
//                         return MapEntry(i, Container());
//                         }
//                       }
//                     ).values.toList(),
//                     SizedBox(height: 15),
//
//                     TextButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                               (Set<MaterialState> states) {
//                             if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                               return widget.model.paletteColor.withOpacity(0.1);
//                             }
//                             if (states.contains(MaterialState.hovered)) {
//                               return widget.model.paletteColor.withOpacity(0.1);
//                             }
//                             return widget.model.accentColor; // Use the component's default.
//                           },
//                         ),
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               side: BorderSide(width: 1, color: widget.model.disabledTextColor),
//                               borderRadius: const BorderRadius.all(Radius.circular(50)),
//                             )
//                         ),
//                       ),
//                       onPressed: () {
//
//                         setState(() {
//                           context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti.add(CostPerMultiDaySettingOption(daysBeforeStartDate: 10, feeBasedOnPass: '', isSinglePass: true, isGroupPass: false));
//                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//                         });
//
//                       }, child: Padding(
//                       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                       child: Text("Dynamic Passes", style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//
//                   ],
//                 )
//               ),
//
//
//             ],
//           ),
//         ),
//
//
//         Visibility(
//           visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.isAllowedGroupAttendance ?? false) && (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.isPassBased ?? false)),
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: 30),
//                 Text(AppLocalizations.of(context)!.activityPaymentMultiDaySingleDayGroupPass, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                 Text('${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.minimumGroupQuantity ?? 0} Attendees Min Per Group - ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.activityPasses?.maximumGroupQuantity ?? 0} Attendees Max Per Group', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 7),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     // width: (widget.model.mainContentWidth)! - 100,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                       child: getTimeSlotAmount(
//                           AppLocalizations.of(context)!.facilityCostingTimeSlot('60'),
//                           AppLocalizations.of(context)!.facilityCostingPerSlot,
//                           AppLocalizations.of(context)!.facilityCostingEstimate('100'),
//                           context,
//                           true,
//                           false,
//                           widget.model,
//                           groupPassBasedSlot!,
//                           updateTextNow: (String e) {
//                             if (e == "\$0.00") {
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultGroupPassesChanged(''));
//                             } else {
//                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeDefaultGroupPassesChanged(e));
//                             }
//                           }
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 15),
//                 ...context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti.asMap().map((i, value) {
//
//                   final TextEditingController feeTextEditor = TextEditingController();
//
//                   if (feeTextEditor.text != value.feeBasedOnPass) {
//                     feeTextEditor.text = value.feeBasedOnPass;
//                   }
//
//                   if (value.isGroupPass) {
//                     return MapEntry(
//                       i, Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(width: 10),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(AppLocalizations.of(context)!.activityPaymentMultiDaySingleDayBefore, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                               SizedBox(height: 4),
//                               Container(
//                                 width: 130,
//                                 child: DropdownButtonHideUnderline(
//                                     child: DropdownButton2(
//                                         offset: const Offset(-10,-15),
//                                         isDense: true,
//                                         buttonElevation: 0,
//                                         buttonDecoration: BoxDecoration(
//                                           color: Colors.transparent,
//                                           borderRadius: BorderRadius.circular(35),
//                                         ),
//                                         customButton: Container(
//                                           decoration: BoxDecoration(
//                                             color: widget.model.accentColor,
//                                             borderRadius: BorderRadius.circular(35),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(2.5),
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 8.0),
//                                                   child: (i == 0) ? Text('${value.daysBeforeStartDate} ${AppLocalizations.of(context)!.days}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)) : Text('${value.daysBeforeStartDate} ${AppLocalizations.of(context)!.days}s', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(right: 8.0),
//                                                   child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         onChanged: (Object? navItem) {
//                                         },
//                                         buttonWidth: 80,
//                                         buttonHeight: 70,
//                                         dropdownElevation: 1,
//                                         dropdownPadding: const EdgeInsets.all(1),
//                                         dropdownDecoration: BoxDecoration(
//                                             boxShadow: [BoxShadow(
//                                                 color: Colors.black.withOpacity(0.11),
//                                                 spreadRadius: 1,
//                                                 blurRadius: 15,
//                                                 offset: Offset(0, 2)
//                                             )
//                                             ],
//                                             color: widget.model.cardColor,
//                                             borderRadius: BorderRadius.circular(14)),
//                                         itemHeight: 50,
//                                         // dropdownWidth: (widget.model.mainContentWidth)! - 100,
//                                         focusColor: Colors.grey.shade100,
//                                         items: [for(var i=1; i<100; i+=1) i].where((element) => element != 0).map(
//                                                 (e) => DropdownMenuItem<int>(
//                                                 onTap: () {
//                                                   setState(() {
//
//                                                     context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i].copyWith(
//                                                         daysBeforeStartDate: e
//                                                     );
//                                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//
//                                                   });
//                                                 },
//                                                 value: e,
//                                                 child: (i == 0) ? Text('$e ${AppLocalizations.of(context)!.days}', style: TextStyle(color: widget.model.disabledTextColor)) : Text('$e ${AppLocalizations.of(context)!.days}s', style: TextStyle(color: widget.model.disabledTextColor)
//                                                 )
//                                             )
//                                         ).toList()
//                                     )
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 25.0),
//                                   child: Text(AppLocalizations.of(context)!.activityPaymentRecurringSinglePassesTimeBasedGroup, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Container(
//                                   // width: (widget.model.mainContentWidth)! - 100,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//                                     child: getTimeSlotAmount(
//                                         AppLocalizations.of(context)!.facilityCostingTimeSlot('60'),
//                                         AppLocalizations.of(context)!.facilityCostingPerSlot,
//                                         AppLocalizations.of(context)!.facilityCostingEstimate('100'),
//                                         context,
//                                         true,
//                                         false,
//                                         widget.model,
//                                         feeTextEditor,
//                                         updateTextNow: (String e) {
//
//                                           if (e == "\$0.00") {
//                                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i].copyWith(
//                                                 feeBasedOnPass: e
//                                             );
//                                           } else {
//                                             context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti[i].copyWith(
//                                                 feeBasedOnPass: e
//                                             );
//                                           }
//                                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//
//                                         }
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: IconButton(
//                                   padding: EdgeInsets.zero,
//                                   icon: Icon(Icons.clear, size: 21, color: widget.model.paletteColor),
//                                   onPressed: () {
//                                     setState(() {
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti.removeAt(i);
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//                                     });
//                                   }
//                               )
//                           )
//                         ],
//                       ),
//                     ),
//                     )
//                   ); } else {
//                     return MapEntry(i, Container());
//                     }
//                   }
//                 ).values.toList(),
//
//                 SizedBox(height: 15),
//                 Visibility(
//                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.isDynamicHours ?? false,
//                   child: TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                             (Set<MaterialState> states) {
//                           if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                             return widget.model.paletteColor.withOpacity(0.1);
//                           }
//                           if (states.contains(MaterialState.hovered)) {
//                             return widget.model.paletteColor.withOpacity(0.1);
//                           }
//                           return widget.model.accentColor; // Use the component's default.
//                         },
//                       ),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             side: BorderSide(width: 1, color: widget.model.disabledTextColor),
//                             borderRadius: const BorderRadius.all(Radius.circular(50)),
//                           )
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti.add(CostPerMultiDaySettingOption(daysBeforeStartDate: 10, feeBasedOnPass: '', isSinglePass: false, isGroupPass: true));
//                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.feeMultiDaySettingsChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCost.costSettingsMulti));
//                       });
//
//                     }, child: Padding(
//                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                     child: Text('Dynamic Group Passes', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 ),
//
//
//
//
//               ],
//             ),
//           ),
//         )
//
//         // Visibility(
//         //   visible: false,
//         // )
//
//       ],
//     );
//   }
//
// }