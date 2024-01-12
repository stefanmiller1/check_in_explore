import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dart;

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// class ActivityAddClassBackgroundInfo extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityManagerForm activityManagerForm;
//   final ReservationItem reservation;
//
//   const ActivityAddClassBackgroundInfo({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);
//
//   @override
//   State<ActivityAddClassBackgroundInfo> createState() => _ActivityAddClassBackgroundInfoState();
// }
//
// class _ActivityAddClassBackgroundInfoState extends State<ActivityAddClassBackgroundInfo> {
//
//   TextEditingController? nameOfAccolade;
//   bool _isShow = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
//       child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//       listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
//       listener: (context, state) {
//
//     },
//     buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
//     builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: widget.model.paletteColor,
//             title: Text('Details About Instructors', style: TextStyle(color: widget.model.accentColor)),
//             actions: [
//
//             ],
//           ),
//           body: Center(
//             child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
//                       ),
//                       SizedBox(height: 20),
//                       Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreYears, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreYearsSub, style: TextStyle(color: widget.model.paletteColor)),
//                       SizedBox(height: 10),
//                       ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.classActivityBackground?.map(
//                         (classes) => Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                     decoration: BoxDecoration(
//                                         color: widget.model.accentColor,
//                                         borderRadius: BorderRadius.all(Radius.circular(12))
//                                     ),
//                                     height: 35,
//                                     width: 60,
//                                     child: Center(
//                                       child: Text(classes.numberOfYearsInExperience.toString() ?? '1', style: TextStyle(color: widget.model.disabledTextColor)
//                                       ),
//                                     )
//                                 ),
//                                 QuantityButtons(
//                                     model: widget.model,
//                                     initNumber: classes.numberOfYearsInExperience,
//                                     counterCallback: (int v) {
//                                       setState(() {
//
//                                       });
//                                     }
//                                 ),
//                                 Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceYears,
//                                     style: TextStyle(
//                                         color: widget.model.paletteColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ],
//                             ),
//
//                             SizedBox(height: 50),
//                             Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreTitle, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                             SizedBox(height: 20),
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: widget.model.accentColor.withOpacity(0.3),
//                                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                                   border: Border(
//                                       top: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
//                                       left: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
//                                       right: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
//                                       bottom: BorderSide(width: 0.5, color: widget.model.disabledTextColor)
//                                   )
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(height: 15),
//                                     Container(
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: 230,
//                                             child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreYearTerm, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                           ),
//                                           Expanded(
//                                             child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreExperienceName, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//
//                                     SizedBox(height: 20),
//                                     ...classes.experience.asMap().map((i, e) {
//                                       TextEditingController experienceTextController = TextEditingController();
//                                       DateRangePickerController dateController = DateRangePickerController();
//
//                                       if (experienceTextController.text.isEmpty) {
//                                         experienceTextController.text = classes.experience[i].experienceTitle.value.fold(
//                                                 (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
//                                                 (r) => r) ?? '';
//                                       }
//
//                                       return MapEntry(i, Container(
//                                         child: Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                               child: Column(
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Container(
//                                                         width: 95,
//                                                         child: Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             Text(AppLocalizations.of(context)!.facilityAvailableBookingsStarting, style: TextStyle(color: widget.model.paletteColor)),
//                                                             SizedBox(height: 5),
//                                                             Container(
//                                                               height: 50,
//                                                               child: TextButton(
//                                                                 style: ButtonStyle(
//                                                                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                                           (Set<MaterialState> states) {
//                                                                         if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                                           return widget.model.paletteColor.withOpacity(0.1);
//                                                                         }
//                                                                         if (states.contains(MaterialState.hovered)) {
//                                                                           return widget.model.paletteColor.withOpacity(0.1);
//                                                                         }
//                                                                         return widget.model.accentColor; // Use the component's default.
//                                                                       },
//                                                                     ),
//                                                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                                         RoundedRectangleBorder(
//                                                                           borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                                         )
//                                                                     )
//                                                                 ),
//                                                                 onPressed: () {
//                                                                   setState(() {
//                                                                     showDialog(
//                                                                         barrierDismissible: true,
//                                                                         context: context,
//                                                                         barrierColor: widget.model.disabledTextColor.withOpacity(0.3),
//                                                                         builder: (BuildContext contexts) {
//                                                                           return AlertDialog(
//                                                                             elevation: 0,
//                                                                             shape: RoundedRectangleBorder(
//                                                                               borderRadius: const BorderRadius.all(Radius.circular(25)),
//                                                                             ),
//                                                                             backgroundColor: widget.model.webBackgroundColor,
//                                                                             content: Container(
//                                                                               height: 500,
//                                                                               width: 500,
//                                                                               child: SfDateRangePicker(
//                                                                                 initialSelectedRange: PickerDateRange(classes.experience[i].experiencePeriod.start, classes.experience[i].experiencePeriod.end),
//                                                                                 navigationMode: DateRangePickerNavigationMode.snap,
//                                                                                 view: DateRangePickerView.decade,
//                                                                                 allowViewNavigation: false,
//                                                                                 enableMultiView: true,
//                                                                                 enablePastDates: true,
//                                                                                 showNavigationArrow: true,
//                                                                                 showTodayButton: true,
//                                                                                 selectionMode: DateRangePickerSelectionMode.range,
//                                                                                 todayHighlightColor: widget.model.paletteColor,
//                                                                                 rangeTextStyle: TextStyle(
//                                                                                     color: widget.model.paletteColor.withOpacity(0.7)),
//                                                                                 selectionTextStyle: TextStyle(
//                                                                                     color: widget.model.accentColor,
//                                                                                     fontWeight: FontWeight.bold),
//                                                                                 onSelectionChanged: (
//                                                                                     DateRangePickerSelectionChangedArgs args) {
//
//                                                                                   if (args.value is PickerDateRange) {
//                                                                                     final DateTime rangeStartDate = args.value.startDate;
//                                                                                     final DateTime rangeEndDate = args.value.endDate;
//
//                                                                                     setState(() {
//                                                                                       // classes.experience[i] = classes.experience[i].copyWith(
//                                                                                       //     experiencePeriod: DateTimeRange(start: rangeStartDate, end: rangeEndDate));
//                                                                                       // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classExperienceChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience ?? []));
//                                                                                     });
//
//                                                                                   }
//                                                                                 },
//                                                                               ),
//                                                                             ),
//                                                                           );
//                                                                         });
//                                                                   });
//                                                                 },
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Expanded(child: Text(DateFormat.y().format(classes.experience[i].experiencePeriod.start), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                                                     Icon(Icons.calendar_today_rounded, color: widget.model.paletteColor),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       SizedBox(width: 15),
//                                                       Container(
//                                                         width: 95,
//                                                         child: Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             Text(AppLocalizations.of(context)!.facilityAvailableBookingsEnding, style: TextStyle(color: widget.model.paletteColor)),
//                                                             SizedBox(height: 5),
//                                                             Container(
//                                                               height: 50,
//                                                               child: TextButton(
//                                                                 style: ButtonStyle(
//                                                                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                                           (Set<MaterialState> states) {
//                                                                         if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                                           return widget.model.paletteColor.withOpacity(0.1);
//                                                                         }
//                                                                         if (states.contains(MaterialState.hovered)) {
//                                                                           return widget.model.paletteColor.withOpacity(0.1);
//                                                                         }
//                                                                         return widget.model.accentColor; // Use the component's default.
//                                                                       },
//                                                                     ),
//                                                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                                         RoundedRectangleBorder(
//                                                                           borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                                         )
//                                                                     )
//                                                                 ),
//                                                                 onPressed: () {
//                                                                   setState(() {
//
//                                                                     showDialog(
//                                                                         context: context,
//                                                                         barrierColor: widget.model.disabledTextColor.withOpacity(0.3),
//                                                                         builder: (BuildContext contexts) {
//                                                                           return AlertDialog(
//                                                                             elevation: 0,
//                                                                             shape: RoundedRectangleBorder(
//                                                                               borderRadius: const BorderRadius.all(Radius.circular(25)),
//                                                                             ),
//                                                                             backgroundColor: widget.model.webBackgroundColor,
//                                                                             content: Container(
//                                                                               height: 500,
//                                                                               width: 500,
//                                                                               child: SfDateRangePicker(
//                                                                                 initialSelectedRange: PickerDateRange(classes.experience[i].experiencePeriod.start, classes.experience[i].experiencePeriod.end),
//                                                                                 navigationMode: DateRangePickerNavigationMode.snap,
//                                                                                 view: DateRangePickerView.decade,
//                                                                                 allowViewNavigation: false,
//                                                                                 enableMultiView: true,
//                                                                                 enablePastDates: true,
//                                                                                 showNavigationArrow: true,
//                                                                                 showTodayButton: true,
//                                                                                 selectionMode: DateRangePickerSelectionMode.range,
//                                                                                 todayHighlightColor: widget.model.paletteColor,
//                                                                                 rangeTextStyle: TextStyle(color: widget.model.paletteColor.withOpacity(0.7)),
//                                                                                 selectionTextStyle: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold),
//                                                                                 onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//
//                                                                                   if (args.value is PickerDateRange) {
//                                                                                     final DateTime rangeStartDate = args.value.startDate;
//                                                                                     final DateTime rangeEndDate = args.value.endDate;
//
//                                                                                     setState(() {
//                                                                                       // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground!.experience[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground!.experience[i].copyWith(
//                                                                                       //     experiencePeriod: DateTimeRange(start: rangeStartDate, end: rangeEndDate));
//                                                                                       // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classExperienceChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience ?? []));
//                                                                                     });
//
//                                                                                   }
//                                                                                 },
//                                                                               ),
//                                                                             ),
//                                                                           );
//                                                                         });
//
//                                                                   });
//                                                                 },
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Expanded(child: Text(DateFormat.y().format(classes.experience[i].experiencePeriod.end), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                                                     Icon(Icons.calendar_today_rounded, color: widget.model.paletteColor),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(width: 10),
//                                             Expanded(
//                                               child: Column(
//                                                 children: [
//                                                   SizedBox(height: 20),
//                                                   getDescriptionTextField(
//                                                       context,
//                                                       widget.model,
//                                                       experienceTextController,
//                                                       '',
//                                                       1,
//                                                       32,
//                                                       updateText: (value) {
//                                                         // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground!.experience[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground!.experience[i].copyWith(
//                                                         //     experienceTitle: FirstLastName(value));
//                                                         // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classExperienceChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience ?? []));
//
//                                                       }
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Visibility(
//                                               visible: i >= 1,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Column(
//                                                   children: [
//                                                     SizedBox(height: 15),
//                                                     IconButton(
//                                                       padding: EdgeInsets.zero,
//                                                       icon: Icon(Icons.clear, size: 35, color: widget.model.paletteColor),
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience.removeAt(i);
//                                                           // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classExperienceChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience ?? []));
//
//                                                         });
//                                                       },
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       );
//                                     }
//                                     ).values.toList() ?? [],
//                                     SizedBox(height: 10),
//                                     Visibility(
//                                       visible: ((classes.experience.length ?? 1) < 5),
//                                       child: TextButton(
//                                         style: ButtonStyle(
//                                             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                   (Set<MaterialState> states) {
//                                                 if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                   return widget.model.paletteColor.withOpacity(0.1);
//                                                 }
//                                                 if (states.contains(MaterialState.hovered)) {
//                                                   return widget.model.paletteColor.withOpacity(0.1);
//                                                 }
//                                                 return widget.model.paletteColor; // Use the component's default.
//                                               },
//                                             ),
//                                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                 RoundedRectangleBorder(
//                                                   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                 )
//                                             )
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience.add(ExperienceOption(experiencePeriod: DateTimeRange(start: DateTime.now().subtract(Duration(days: 365)), end: DateTime.now()), experienceTitle: FirstLastName('')));
//                                             // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classExperienceChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.experience ?? []));
//                                           });
//                                         },
//                                         child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                                       child: Divider(
//                                         thickness: 0.35,
//                                         color: widget.model.disabledTextColor,
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//
//                                     Container(
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: 230,
//                                             child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreType, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                           ),
//                                           Expanded(
//                                             child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreCertificateSub, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     ...classes.certificates.toList().asMap().map((i, value) {
//                                       TextEditingController certificateTextController = TextEditingController();
//
//                                       if (certificateTextController.text.isEmpty) {
//                                         certificateTextController.text = classes.certificates[i].certificateTitle.value.fold(
//                                                 (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
//                                                 (r) => r) ?? '';
//                                       }
//
//                                       return MapEntry(i,
//                                           Container(
//                                             child: Row(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Container(
//                                                   width: 210,
//                                                   child: DropdownButtonHideUnderline(
//                                                       child: DropdownButton2(
//                                                           offset: const Offset(-10,-15),
//                                                           isDense: true,
//                                                           buttonElevation: 0,
//                                                           buttonDecoration: BoxDecoration(
//                                                             color: Colors.transparent,
//                                                             borderRadius: BorderRadius.circular(35),
//                                                           ),
//                                                           customButton: Container(
//                                                             decoration: BoxDecoration(
//                                                               color: widget.model.accentColor,
//                                                               borderRadius: BorderRadius.circular(35),
//                                                             ),
//                                                             child: Padding(
//                                                               padding: const EdgeInsets.all(2.5),
//                                                               child: Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                 children: [
//                                                                   Padding(
//                                                                     padding: const EdgeInsets.only(left: 8.0),
//                                                                     child: Text(getCertificateName(context, classes.certificates[i].certificateType), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                                                   ),
//                                                                   Padding(
//                                                                     padding: const EdgeInsets.only(right: 8.0),
//                                                                     child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           onChanged: (Object? navItem) {
//                                                           },
//                                                           buttonWidth: 80,
//                                                           buttonHeight: 70,
//                                                           dropdownElevation: 1,
//                                                           dropdownPadding: const EdgeInsets.all(1),
//                                                           dropdownDecoration: BoxDecoration(
//                                                               boxShadow: [BoxShadow(
//                                                                   color: Colors.black.withOpacity(0.11),
//                                                                   spreadRadius: 1,
//                                                                   blurRadius: 15,
//                                                                   offset: Offset(0, 2)
//                                                               )
//                                                               ],
//                                                               color: widget.model.cardColor,
//                                                               borderRadius: BorderRadius.circular(14)),
//                                                           itemHeight: 50,
//                                                           dropdownWidth: MediaQuery.of(context).size.width,
//                                                           focusColor: Colors.grey.shade100,
//                                                           items: CertificateType.values.map(
//                                                                   (e) => DropdownMenuItem<CertificateType>(
//                                                                   onTap: () {
//                                                                     setState(() {
//                                                                       // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground!.certificates[i].copyWith(certificateType: e);
//                                                                       // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classCertificatesChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates ?? []));
//                                                                     });
//                                                                   },
//                                                                   value: e,
//                                                                   child: Text(getCertificateName(context, e), style: TextStyle(color: widget.model.disabledTextColor)
//                                                                   )
//                                                               )
//                                                           ).toList()
//                                                       )
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 15),
//                                                 Expanded(
//                                                   child: getDescriptionTextField(
//                                                       context,
//                                                       widget.model,
//                                                       certificateTextController,
//                                                       '',
//                                                       1,
//                                                       32,
//                                                       updateText: (value) {
//
//                                                         // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates[i] = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground!.certificates[i].copyWith(
//                                                         //     certificateTitle: FirstLastName(value));
//                                                         // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classCertificatesChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates ?? []));
//                                                       }
//                                                   ),
//                                                 ),
//                                                 Visibility(
//                                                   visible: i >= 1,
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.all(8.0),
//                                                     child: IconButton(
//                                                       padding: EdgeInsets.zero,
//                                                       icon: Icon(Icons.clear, size: 35, color: widget.model.paletteColor),
//                                                       onPressed: () {
//                                                         setState(() {
//
//                                                           // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates.removeAt(i);
//                                                           // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classCertificatesChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates ?? []));
//
//
//                                                         });
//                                                       },
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                       );
//                                     }).values.toList() ?? [],
//                                     SizedBox(height: 10),
//                                     Visibility(
//                                       visible: ((classes.certificates.length ?? 1) < 5),
//                                       child: TextButton(
//                                         style: ButtonStyle(
//                                             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                                   (Set<MaterialState> states) {
//                                                 if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                                   return widget.model.paletteColor.withOpacity(0.1);
//                                                 }
//                                                 if (states.contains(MaterialState.hovered)) {
//                                                   return widget.model.paletteColor.withOpacity(0.1);
//                                                 }
//                                                 return widget.model.paletteColor; // Use the component's default.
//                                               },
//                                             ),
//                                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                 RoundedRectangleBorder(
//                                                   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                                                 )
//                                             )
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             // context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates.add(CertificateOption(certificateType: CertificateType.Professional, dateReceived: DateTime.now(), certificateTitle: FirstLastName('')));
//                                             // context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.classCertificatesChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityBackground.classActivityBackground?.certificates ?? []));
//                                           });
//                                         },
//                                         child: Text(AppLocalizations.of(context)!.add, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       ),
//                                     ),
//                                     SizedBox(width: 15),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                           ],
//                         )
//                       ) ?? [],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       )
//     );
//   }
// }