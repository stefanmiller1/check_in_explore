import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'activity_duration_helper.dart';
import 'widget/activity_hours_filter_widget.dart';
import 'widget/activity_weekday_list_widget.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

// class ActivityDurationSelection extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivityDurationSelection({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivityDurationSelection> createState() => _ActivityDurationSelectionState();
// }
//
// class _ActivityDurationSelectionState extends State<ActivityDurationSelection> {
//
//   bool _isShow = false;
//   DateRangePickerController? dateController;
//   List<DayOptionItem> dayOption = [];
//
//   @override
//   void initState() {
//     dateController = DateRangePickerController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     dayOption.clear();
//     dateController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityCreatorForm))),
//     child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//     listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
//     listener: (context, state) {
//
//     },
//     buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityManagerForm != c.activityManagerForm,
//     builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: widget.model.paletteColor,
//             title: Text('The Calendar', style: TextStyle(color: widget.model.accentColor)),
//             actions: [
//
//             ],
//           ),
//           body: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: SingleChildScrollView(
//             child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//                       Text(AppLocalizations.of(context)!.activityAvailabilityDuration, style: TextStyle(
//                           color: widget.model.paletteColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: widget.model.questionTitleFontSize)),
//                       SizedBox(height: 10),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(AppLocalizations.of(context)!.activityAvailabilityPeriodTitle, style: TextStyle(
//                               color: widget.model.paletteColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                           Text(AppLocalizations.of(context)!.activityAvailabilityPeriodSubTitle, style: TextStyle(
//                               color: widget.model.paletteColor)),
//                         ],
//                       ),
//
//                       SizedBox(height: 25),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: widget.model.accentColor,
//                               borderRadius: BorderRadius.all(Radius.circular(20))
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Text(AppLocalizations.of(context)!.facilitiesSelect, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Container(
//                           decoration: BoxDecoration(
//                               color: widget.model.accentColor.withOpacity(0.3),
//                               borderRadius: BorderRadius.all(Radius.circular(20)),
//                               border: Border(
//                                   top: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
//                                   left: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
//                                   right: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
//                                   bottom: BorderSide(width: 0.5, color: widget.model.disabledTextColor)
//                               )
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: DurationType.values.map(
//                                   (e) => Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Container(
//                                     width: 380,
//                                     height: 40,
//                                     child: TextButton(
//                                       style: ButtonStyle(
//                                         backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                               (Set<MaterialState> states) {
//                                             if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                               return widget.model.paletteColor.withOpacity(0.1);
//                                             }
//                                             if (states.contains(MaterialState.hovered)) {
//                                               return (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == e) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.1);
//                                             }
//                                             return (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == e) ? widget.model.paletteColor : Colors.transparent; // Use the component's default.
//                                           },
//                                         ),
//                                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                             RoundedRectangleBorder(
//                                               borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                             )
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         setState(() {
//                                           context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.durationTypeChanged(e));
//
//                                           switch (e) {
//
//                                              case DurationType.day:
//                                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 1))));
//                                                context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//                                                context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(AvailabilityHoursSettingOption.empty().openHours);
//                                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//                                                break;
//                                              case DurationType.week:
//
//                                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 14))));
//                                               dayOption.clear();
//                                               context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//
//
//                                               for (int week in [for(var i=0; i<((DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 14))).duration.inDays/7)); i+=1) i]) {
//
//                                                 dayOption.addAll([
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                 ]);
//                                               }
//
//                                               context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//                                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//
//                                               break;
//                                              case DurationType.month:
//
//                                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 29))));
//
//                                                dayOption.clear();
//                                                context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//
//
//                                                for (int week in [for(var i=0; i<((DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 29))).duration.inDays/7)); i+=1) i]) {
//
//                                                  dayOption.addAll([
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                  ]);
//                                                }
//
//                                                context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//                                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//
//                                                break;
//                                              case DurationType.seasonal:
//                                                dayOption.clear();
//                                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 119))));
//                                                context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//
//
//                                                for (int week in [for(var i=0; i<((DateTimeRange(start: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, end: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 119))).duration.inDays/7)); i+=1) i]) {
//                                                  dayOption.addAll([
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                    DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                  ]);
//
//                                                }
//                                                context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//                                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//
//                                                break;
//                                             case DurationType.custom:
//
//                                               dayOption.clear();
//                                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 30))));
//                                               context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//                                               DateTime startTime = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting;
//                                               DateTime endTime = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 29));
//
//                                               for (int week in [for(var i=0; i<((((DateTimeRange(start: startTime, end: endTime).duration.inDays) - subtractFromStartingWeekDay(startTime.weekday) + (endTime.weekday) + (7 - endTime.weekday))/7)); i+=1) i]) {
//
//                                                 dayOption.addAll([
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                   DayOptionItem(month: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                                 ]);
//
//                                               }
//
//                                               context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//                                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//                                               break;
//                                            }
//                                            _isShow = false;
//
//                                         });
//                                       },
//                                       child: Text(getDurationTypeName(context, e), style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == e) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == e) ? FontWeight.bold : FontWeight.normal)),
//                                 )
//                               ),
//                             ),
//                           ).toList(),
//                         )
//                       ),
//                       const SizedBox(height: 20),
//
//                       Text(AppLocalizations.of(context)!.activityAvailabilityDateRanges, style: TextStyle(
//                           color: widget.model.paletteColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                      const SizedBox(height: 10),
//                      Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                               Text(AppLocalizations.of(context)!.facilityAvailableBookingsStarting, style: TextStyle(color: widget.model.paletteColor)),
//                               SizedBox(height: 5),
//                               Container(
//                                   height: 50,
//                                   child: TextButton(
//                                   style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                   (Set<MaterialState> states) {
//                                     if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                       return widget.model.paletteColor.withOpacity(0.1);
//                                     }
//                                     if (states.contains(MaterialState.hovered)) {
//                                       return widget.model.paletteColor.withOpacity(0.1);
//                                     }
//                                     return widget.model.accentColor; // Use the component's default.
//                                   },
//                                 ),
//                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                         )
//                                       )
//                                     ),
//                                     onPressed: () {
//                                     setState(() {
//                                       if (_isShow) {
//                                         _isShow = false;
//                                       } else {
//                                         _isShow = true;
//                                       }});
//                                     },
//                                     child: Row(
//                                       children: [
//                                         Expanded(child: Text(DateFormat.yMMMMd().format(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                         Icon(Icons.calendar_today_rounded, color: widget.model.paletteColor),
//                                             ],
//                                           ),
//                                         )
//                                       )
//                                     ]
//                                   ),
//                         ),
//
//                             SizedBox(width: 15),
//                             Expanded(
//                               child: Visibility(
//                                 visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType != DurationType.day,
//                                 child: IgnorePointer(
//                                   ignoring: true,
//                                   child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(AppLocalizations.of(context)!.facilityAvailableBookingsEnding, style: TextStyle(color: widget.model.paletteColor)),
//                                         SizedBox(height: 5),
//                                         Container(
//                                             height: 50,
//                                             child: TextButton(
//                                               style: ButtonStyle(
//                                                   backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                         (Set<MaterialState> states) {
//                                                       if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                         return widget.model.paletteColor.withOpacity(0.1);
//                                                       }
//                                                       if (states.contains(MaterialState.hovered)) {
//                                                         return widget.model.paletteColor.withOpacity(0.1);
//                                                       }
//                                                       return widget.model.accentColor; // Use the component's default.
//                                                     },
//                                                   ),
//                                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                       RoundedRectangleBorder(
//                                                         borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                       )
//                                                   )
//                                               ),
//                                               onPressed: () {
//
//                                               },
//                                               child: Row(
//                                                 children: [
//                                                   Expanded(child: Text(DateFormat.yMMMMd().format(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize), maxLines: 1, overflow: TextOverflow.ellipsis,)),
//                                                   Icon(Icons.calendar_today_rounded, color: widget.model.paletteColor),
//                                             ],
//                                           ),
//                                         )
//                                       ),
//
//                                     ]
//                                   ),
//                                   ),
//                                 ),
//                             ),
//                             ]
//                           ),
//
//                           /// Calendar Edits ///
//                           SizedBox(height: 25),
//                           Visibility(
//                             visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.custom && _isShow,
//                               child: customCalendarType(
//                                   context,
//                                   widget.model,
//                                   dateController!,
//                                   updateDate: (e) {
//                                   setState(() {
//
//                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(e.start));
//                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(e.end));
//
//                                     dayOption.clear();
//                                     context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//
//                                     if ((e.end.weekday < e.start.weekday) && (DateTimeRange(start: e.start, end: e.end).duration.inDays) <= 6) {
//
//                                       for (int week in [for(var i=0; i<(14/7); i+=1) i]) {
//                                         dayOption.addAll([
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         ]);
//                                       }
//                                     } else if ((DateTimeRange(start: e.start, end: e.end).duration.inDays) <= 7 && e.start.weekday < e.end.weekday) {
//
//                                       dayOption.addAll([
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: e.start.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                       ]);
//
//                                     } else {
//
//                                       for (int week in [for(var i=0; i<((((DateTimeRange(start: e.start, end: e.end).duration.inDays + 1) + subtractFromStartingWeekDay(e.start.weekday) + (7 - e.end.weekday))/7)); i+=1) i]) {
//                                         dayOption.addAll([
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: e.start.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           ]);
//                                         }
//                                       }
//
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//
//                                 });
//                               }
//                             )
//                           ),
//
//
//                           Visibility(
//                             visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.week && _isShow,
//                             child: Container(
//                               height: 500,
//                               width: MediaQuery.of(context).size.width,
//                               child: SfDateRangePicker(
//                                 initialSelectedDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                                 navigationMode: DateRangePickerNavigationMode.snap,
//                                 // controller: dateController!,
//                                 view: DateRangePickerView.month,
//                                 allowViewNavigation: false,
//                                 enableMultiView: false,
//                                 enablePastDates: false,
//                                 showNavigationArrow: true,
//                                 showTodayButton: true,
//                                 selectionMode: DateRangePickerSelectionMode.single,
//                                 todayHighlightColor: widget.model.paletteColor,
//                                 rangeTextStyle: TextStyle(
//                                     color: widget.model.paletteColor.withOpacity(0.7)),
//                                 selectionTextStyle:  TextStyle(
//                                     color: widget.model.accentColor,
//                                     fontWeight: FontWeight.bold),
//                                 headerHeight: 70,
//                                 headerStyle: DateRangePickerHeaderStyle(
//                                     textStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)
//                                 ),
//                                 monthViewSettings: DateRangePickerMonthViewSettings(
//                                   firstDayOfWeek: 1,
//                                   specialDates: getDaysInBetween(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 6))),
//                                   blackoutDates: [getDaysInBetween(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.add(Duration(days: 6))).last]
//                                 ),
//                                 monthCellStyle: DateRangePickerMonthCellStyle(
//                                   blackoutDatesDecoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: widget.model.paletteColor),
//                                   blackoutDateTextStyle: TextStyle(color: widget.model.accentColor),
//                                   specialDatesDecoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       border: Border.all(width: 1, color: widget.model.paletteColor),
//                                       color: widget.model.paletteColor.withOpacity(0.10)),
//                                   specialDatesTextStyle: TextStyle(color: widget.model.paletteColor),
//                                 ),
//                                 onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//                                   setState(() {
//                                   if (args.value is DateTime) {
//
//
//                                     final DateTime selectedStartDate = args.value;
//                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(selectedStartDate));
//                                     context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//                                     dayOption.clear();
//
//
//                                     if (selectedStartDate.add(Duration(days: 6)).weekday < selectedStartDate.weekday) {
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(selectedStartDate.add(Duration(days: 14))));
//
//                                       for (int week in [for(var i=0; i<(14/7); i+=1) i]) {
//                                         dayOption.addAll([
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                           DayOptionItem(month: selectedStartDate.month, week: week, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//
//                                         ]);
//                                       }
//
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//
//                                     } else {
//
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(selectedStartDate.add(Duration(days: 7))));
//
//                                       dayOption.addAll([
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[0].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[0].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[1].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[1].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[2].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[2].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[3].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[3].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[4].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[4].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[5].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[5].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                         DayOptionItem(month: selectedStartDate.month, week: 0, dayOfWeek: AvailabilityHoursSettingOption.empty().openHours[6].dayOfWeek, isClosed: AvailabilityHoursSettingOption.empty().openHours[6].isClosed, isTwentyFourHour: AvailabilityHoursSettingOption.empty().openHours[0].isTwentyFourHour, hoursOpen: []),
//                                       ]);
//
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(dayOption);
//
//                                     }
//
//                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//
//
//                                     }
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//
//                           Visibility(
//                             visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.month && _isShow || context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.seasonal && _isShow,
//                             child: Container(
//                               height: 500,
//                               width: 500,
//                               child: SfDateRangePicker(
//                                 initialSelectedRange: PickerDateRange(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding),
//                                 navigationMode: DateRangePickerNavigationMode.snap,
//                                 view: DateRangePickerView.year,
//                                 allowViewNavigation: false,
//                                 enableMultiView: false,
//                                 enablePastDates: false,
//                                 showNavigationArrow: true,
//                                 showTodayButton: true,
//                                 monthViewSettings: DateRangePickerMonthViewSettings(
//                                   firstDayOfWeek: 1,
//                                 ),
//                                 headerHeight: 70,
//                                 headerStyle: DateRangePickerHeaderStyle(
//                                     textStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)
//                                 ),
//                                 selectionMode: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.month) ? DateRangePickerSelectionMode.single : DateRangePickerSelectionMode.range,
//                                 todayHighlightColor: widget.model.paletteColor,
//                                 rangeTextStyle: TextStyle(
//                                     color: widget.model.paletteColor.withOpacity(0.7)),
//                                 selectionTextStyle:  TextStyle(
//                                     color: widget.model.accentColor,
//                                     fontWeight: FontWeight.bold),
//                                 onSelectionChanged: (
//                                     DateRangePickerSelectionChangedArgs args) {
//
//                                   if (args.value is DateTime) {
//                                     final DateTime selectedMonth = args.value;
//
//                                     if (DateTime.now().month == selectedMonth.month) {
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(DateTime.now()));
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(DateTime.utc(selectedMonth.year,selectedMonth.month+1,).subtract(Duration(days: 1))));
//
//                                     } else {
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(selectedMonth));
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(DateTime.utc(selectedMonth.year,selectedMonth.month+1,).subtract(Duration(days: 1))));
//                                     }
//                                   }
//
//                                   if (args.value is PickerDateRange) {
//                                     final DateTime rangeStartDate = args.value.startDate;
//                                     final DateTime rangeEndDate = args.value.endDate;
//
//                                     setState(() {
//
//                                       if (DateTime.now().month == rangeStartDate.month) {
//
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(DateTime.now()));
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(rangeEndDate));
//
//                                       } else {
//
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(rangeStartDate));
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(rangeEndDate));
//
//                                       }
//
//                                     });
//
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//
//                           Visibility(
//                             visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.day && _isShow,
//                             child: Container(
//                               height: 500,
//                               width: MediaQuery.of(context).size.width,
//                               child: SfDateRangePicker(
//                                 initialSelectedDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                                 navigationMode: DateRangePickerNavigationMode.snap,
//                                 view: DateRangePickerView.month,
//                                 allowViewNavigation: false,
//                                 enableMultiView: false,
//                                 enablePastDates: false,
//                                 showNavigationArrow: true,
//                                 showTodayButton: true,
//                                 monthViewSettings: DateRangePickerMonthViewSettings(
//                                   firstDayOfWeek: 1,
//                                 ),
//                                 headerHeight: 70,
//                                 headerStyle: DateRangePickerHeaderStyle(
//                                     textStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)
//                                 ),
//                                 selectionMode: DateRangePickerSelectionMode.single,
//                                 todayHighlightColor: widget.model.paletteColor,
//                                 rangeTextStyle: TextStyle(
//                                     color: widget.model.paletteColor.withOpacity(0.7)),
//                                 selectionTextStyle:  TextStyle(
//                                     color: widget.model.accentColor,
//                                     fontWeight: FontWeight.bold),
//                                 onSelectionChanged: (
//                                     DateRangePickerSelectionChangedArgs args) {
//
//                                   if (args.value is DateTime) {
//                                     DateTime dateSelected = args.value;
//                                     setState(() {
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.startingDateChanged(dateSelected));
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.endingDateChanged(dateSelected.add(Duration(days: 1))));
//
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.clear();
//                                       context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.addAll(AvailabilityHoursSettingOption.empty().openHours);
//                                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//                                     });
//
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//
//
//                         /// *** time edits *** ///
//                         Visibility(
//                           visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType == DurationType.day,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 20),
//                               Text('What About the Time your Activity Starts and Ends?', style: TextStyle(
//                                   color: widget.model.paletteColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               Text('Select to Edit Activity Start and End Times', style: TextStyle(
//                                   color: widget.model.paletteColor)),
//                               const SizedBox(height: 15),
//
//                               weekdayListOpenHours(
//                                   context,
//                                   false,
//                                   null,
//                                   model: widget.model,
//                                   startDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                                   endDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding,
//                                   durationType: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType ?? DurationType.day,
//                                   currentWeek: 0,
//                                   hoursPerDay: [context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => (element.dayOfWeek) == (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.weekday))],
//                                   editWeekdays: (day) {
//                                     showDialog(
//                                         context: context,
//                                         builder: (BuildContext contexts) {
//
//                                           return ActivityHoursFilterWidget(
//                                             model: widget.model,
//                                             selectableWeeks: [],
//                                             selectableWeekDay: [context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting.weekday],
//                                             endDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding,
//                                             startDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                                             selectedDayOption: day,
//                                             isClosed: false,
//                                             saveOptions: (List<DayOptionItem> savedList, bool isTwentyFour, bool isClosed) {
//
//                                               for (DayOptionItem dayOption in savedList) {
//                                                 int index = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.indexWhere((element) => element.dayOfWeek == dayOption.dayOfWeek);
//                                                 context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.replaceRange(index, index+1, [dayOption]);
//                                               }
//
//                                               setState(() {
//                                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//                                                 Navigator.of(contexts).pop();
//                                               });
//
//                                     },
//                                   );
//                                 }
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 50),
//                   ]
//                 ),
//               )
//             ),
//         );
//         }
//       )
//     );
//   }
//
//   bool isSameDate(DateTime date, DateTime dateTime) {
//     if (date.year == dateTime.year &&
//         date.month == dateTime.month &&
//         date.day == dateTime.day) {
//       return true;
//     }
//
//     return false;
//   }
//
//
//
//
// }