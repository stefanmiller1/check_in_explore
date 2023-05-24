import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'activity_duration_helper.dart';


// class ActivityAvailabilityHintHelper extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivityAvailabilityHintHelper({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivityAvailabilityHintHelper> createState() => _ActivityAvailabilityHintHelperState();
// }
//
// class _ActivityAvailabilityHintHelperState extends State<ActivityAvailabilityHintHelper> {
//
//   ScrollController? _scrollController;
//   DayOptionItem? _selectedDateToFilter;
//   PageController? weekDaysPageController;
//
//   @override
//   void initState() {
//     _selectedDateToFilter = (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).isNotEmpty) ? context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[0] : null;
//     _scrollController = ScrollController();
//     weekDaysPageController = PageController(
//         viewportFraction: 0.9,
//         initialPage: 0);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     weekDaysPageController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return SingleChildScrollView(
//       controller: _scrollController,
//       child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         Text(AppLocalizations.of(context)!.activityAvailabilityHoursAvailableReview, style: TextStyle(
//             color: widget.model.accentColor,
//             fontWeight: FontWeight.bold)),
//         SizedBox(height: 10),
//         Container(
//           height: 55,
//           decoration: BoxDecoration(
//               color: widget.model.accentColor,
//               borderRadius: BorderRadius.all(Radius.circular(27))
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(child: Text(getDurationTypeName(context, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize),)),
//             ),
//           ),
//           SizedBox(height: 15),
//           Text('${AppLocalizations.of(context)!.facilityAvailableBookingsStarting} ${DateFormat.yMMMMd().format(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
//
//       Visibility(
//         visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType != DurationType.day && context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
//         child: Container(
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               border: Border.all(width: 2, color: widget.model.accentColor),
//               borderRadius: BorderRadius.all(Radius.circular(35)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text('Joining Means Access to All ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0} Unique Sessions:', style: TextStyle(
//                       color: widget.model.accentColor,
//                       fontWeight: FontWeight.bold)),
//                     ),
//                     SizedBox(height: 10),
//                      Container(
//                        decoration: BoxDecoration(
//                          color: widget.model.accentColor,
//                          borderRadius: BorderRadius.all(Radius.circular(30)),
//                        ),
//                        child: Padding(
//                          padding: const EdgeInsets.all(4.0),
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0, top: 4.0),
//                               child: Text('Activity Lasts ${DateFormat.MMMMd().format(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting)} - ${DateFormat.MMMMd().format(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding)}', style: TextStyle(
//                                  color: widget.model.paletteColor,
//                                  fontWeight: FontWeight.bold)),
//                             ),
//                              ...context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.asMap().map((i, e) =>
//                                  MapEntry(i, Padding(
//                                      padding: const EdgeInsets.all(4.0),
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                          border: Border.all(width: 1, color: widget.model.disabledTextColor.withOpacity(0.4)),
//                                          color: widget.model.accentColor.withOpacity(0.4),
//                                          borderRadius: BorderRadius.all(Radius.circular(20)),
//                                        ),
//                                        child: Padding(
//                                          padding: const EdgeInsets.all(4.0),
//                                          child: Row(
//                                            mainAxisAlignment: MainAxisAlignment.start,
//                                            crossAxisAlignment: CrossAxisAlignment.start,
//                                            children: [
//                                              SizedBox(width: 10),
//                                              Icon(Icons.calendar_today, size: 30, color: widget.model.paletteColor),
//                                              SizedBox(width: 10),
//                                              Expanded(
//                                                child: Column(
//                                                  mainAxisAlignment: MainAxisAlignment.start,
//                                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                                  children: [
//                                                    Text('Description: What this Session focuses on...', style: TextStyle(color: widget.model.paletteColor)),
//                                                    Text('Session: ${i + 1}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                                  ],
//                                                ),
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                              ).values.toList() ?? [],
//                            ]
//                          ),
//                        ),
//                      ),
//
//                 ]
//               ),
//             )
//           ),
//         ),
//
//           Visibility(
//             visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType != DurationType.day && ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).length) >= 1) && context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.recurring,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   height: 155,
//                 ),
//                 Positioned(
//                   top: 10,
//                   left: 0,
//                   child: Text('Available Days & Hours:', style: TextStyle(
//                       color: widget.model.accentColor,
//                       fontWeight: FontWeight.bold)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(3.0),
//                   child: Container(
//                     height: 75,
//                     decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border.all(width: 2, color: widget.model.accentColor),
//                         borderRadius: BorderRadius.all(Radius.circular(35))
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     child: Row(
//                       children: [
//
//                         IconButton(
//                           icon: Container(
//                               height: 70,
//                               width: 70,
//                               decoration: BoxDecoration(
//                                   color: widget.model.accentColor,
//                                   borderRadius: BorderRadius.all(Radius.circular(35))
//                               ),
//                               child: Icon(Icons.arrow_back_ios_rounded, color: widget.model.paletteColor, size: 18)),
//                           onPressed: () {
//                             setState(() {
//                               weekDaysPageController?.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//
//                             });
//                           },
//                         ),
//                         SizedBox(width: 175),
//
//                         IconButton(
//                           icon: Container(
//                               height: 70,
//                               width: 70,
//                               decoration: BoxDecoration(
//                                   color: widget.model.accentColor,
//                                   borderRadius: BorderRadius.all(Radius.circular(35))
//                               ),
//                               child: Icon(Icons.arrow_forward_ios, color: widget.model.paletteColor, size: 18)),
//                           onPressed: () {
//                             setState(() {
//                               weekDaysPageController?.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//                             });
//                           },
//                         ),
//                       ],
//                     )
//                   ),
//                 ),
//
//                 Container(
//                   height: 60,
//                   child: PageView.builder(
//                       controller: weekDaysPageController!,
//                       itemCount: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             height: 60,
//                             child: TextButton(
//                                 style: ButtonStyle(
//                                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                           (Set<MaterialState> states) {
//                                         if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                           return widget.model.paletteColor.withOpacity(0.1);
//                                         }
//                                         if (states.contains(MaterialState.hovered)) {
//                                           return widget.model.paletteColor.withOpacity(0.1);
//                                         }
//                                         return widget.model.paletteColor; // Use the component's default.
//                                       },
//                                     ),
//                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                           borderRadius: const BorderRadius.all(Radius.circular(50)),
//                                         )
//                                     )
//                                 ),
//                                 onPressed: () {
//
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.all(6),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//
//                                       Expanded(child: Text(dayOfTheWeek(context, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[index].dayOfWeek), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
//                                       SizedBox(width: 10),
//                                       Visibility(
//                                         visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[index].isTwentyFourHour,
//                                         child: Align(
//                                             alignment: Alignment.bottomRight,
//                                             child: Text(AppLocalizations.of(context)!.activityAvailabilityHoursOpen, style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
//                                       ),
//                                       // Visibility(
//                                       //   visible: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[index].isTwentyFourHour),
//                                       //   child: Column(
//                                       //       mainAxisAlignment: MainAxisAlignment.end,
//                                       //       crossAxisAlignment: CrossAxisAlignment.end,
//                                       //       children: ((context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[index].hoursOpen.length) >= 2) ?
//                                       //       context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[index].hoursOpen.slice(0, 2).map(
//                                       //             (f) => Padding(
//                                       //           padding: const EdgeInsets.only(top: 4.0),
//                                       //           child: Row(
//                                       //             children: [
//                                       //               Text(DateFormat.jm().format(f.start), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       //               Text(' - ', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       //               Text(DateFormat.jm().format(f.end), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       //             ],
//                                       //           ),
//                                       //         ),
//                                       //       ).toList() :
//                                       //       context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[index].hoursOpen.map(
//                                       //             (f) => Padding(
//                                       //           padding: const EdgeInsets.only(top: 4.0),
//                                       //           child: Row(
//                                       //             children: [
//                                       //               Text(DateFormat.jm().format(f.start), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       //               Text(' - ', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       //               Text(DateFormat.jm().format(f.end), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                       //             ],
//                                       //           ),
//                                       //         ),
//                                       //       ).toList()
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                 )
//                             ),
//                           ),
//                         );
//                       },
//                       onPageChanged: (p) {
//                         setState(() {
//                         _selectedDateToFilter = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList()[p];
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Visibility(
//             visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.recurring,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 25),
//                 Text('What New Attendees Will See:', style: TextStyle(
//                     color: widget.model.accentColor,
//                     fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 Container(
//                     decoration: BoxDecoration(
//                         color: widget.model.accentColor,
//                         borderRadius: BorderRadius.all(Radius.circular(27))
//                     ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 4),
//                         Text('Example:', style: TextStyle(
//                             color: widget.model.paletteColor,
//                             fontWeight: FontWeight.bold)),
//                         SizedBox(height: 4),
//                         Visibility(
//                           visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? false,
//                           child: Column(
//                             children: [
//                               Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).toList().length).toString(), 'Full Day', AppLocalizations.of(context)!.week), style: TextStyle(
//                                   color: widget.model.paletteColor,
//                                   fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                             ],
//                           ),
//                         ),
//                         Visibility(
//                           visible: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? true),
//                           child: Column(
//                             children: [
//                               Visibility(
//                                 visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isThirtyMinutesPer ?? false) && !(_selectedDateToFilter?.isTwentyFourHour ?? true)),
//                                 child: Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown(getNumberOfMinutesInListOfHours(30, _selectedDateToFilter?.hoursOpen ?? []).toString(), '30 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes}', AppLocalizations.of(context)!.days), style: TextStyle(
//                                     color: widget.model.paletteColor,
//                                     fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ),
//                               Visibility(
//                                 visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false) && !(_selectedDateToFilter?.isTwentyFourHour ?? true)),
//                                 child: Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown(getNumberOfMinutesInListOfHours(60, _selectedDateToFilter?.hoursOpen ?? []).toString(), '60 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes}', AppLocalizations.of(context)!.days), style: TextStyle(
//                                     color: widget.model.paletteColor,
//                                     fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ),
//                               Visibility(
//                                 visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false) && !(_selectedDateToFilter?.isTwentyFourHour ?? true)),
//                                 child: Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown(getNumberOfMinutesInListOfHours(120, _selectedDateToFilter?.hoursOpen ?? []).toString(), '2 ${AppLocalizations.of(context)!.facilityAvailableSlotHours}', AppLocalizations.of(context)!.days), style: TextStyle(
//                                     color: widget.model.paletteColor,
//                                     fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ),
//                               Visibility(
//                               visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isThirtyMinutesPer ?? false) && (_selectedDateToFilter?.isTwentyFourHour ?? false)),
//                                 child: Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown('48','30 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes}', AppLocalizations.of(context)!.days), style: TextStyle(
//                                   color: widget.model.paletteColor,
//                                   fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ),
//                               Visibility(
//                                 visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false) && (_selectedDateToFilter?.isTwentyFourHour ?? false)),
//                                 child: Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown('24', '60 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes}', AppLocalizations.of(context)!.days), style: TextStyle(
//                                     color: widget.model.paletteColor,
//                                     fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ),
//                               Visibility(
//                                 visible: ((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false) && (_selectedDateToFilter?.isTwentyFourHour ?? false)),
//                                 child: Text(AppLocalizations.of(context)!.activityAvailabilitySessionsBreakdown('12','2 ${AppLocalizations.of(context)!.facilityAvailableSlotHours}', AppLocalizations.of(context)!.days), style: TextStyle(
//                                     color: widget.model.paletteColor,
//                                     fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ),
//
//                 SizedBox(height: 10),
//                 Visibility(
//                   visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? false,
//                   child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border.all(width: 2, color: widget.model.accentColor),
//                         borderRadius: BorderRadius.all(Radius.circular(35)),
//                       ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: widget.model.paletteColor,
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(width: 10),
//                               Icon(Icons.calendar_today, size: 30, color: widget.model.accentColor),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(dayOfTheWeek(context, _selectedDateToFilter?.dayOfWeek ?? 0), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                     Text('Slot: All Day', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ),
//
//                 Visibility(
//                   visible: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? true),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border.all(width: 2, color: widget.model.accentColor),
//                         borderRadius: BorderRadius.all(Radius.circular(35)),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Column(
//                         children: (_selectedDateToFilter?.isTwentyFourHour ?? false) ? [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: widget.model.paletteColor,
//                                 borderRadius: BorderRadius.all(Radius.circular(20)),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(width: 10),
//                                     Icon(Icons.calendar_today, size: 30, color: widget.model.accentColor),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(dayOfTheWeek(context, _selectedDateToFilter?.dayOfWeek ?? 0), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                           Text('Slot: All Day', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           )
//                         ] : [0,1,2].map(
//                                 (e) => Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: widget.model.paletteColor,
//                                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(4.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(width: 10),
//                                           Icon(Icons.calendar_today, size: 30, color: widget.model.accentColor),
//                                           SizedBox(width: 10),
//                                           Expanded(
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 if ((_selectedDateToFilter?.hoursOpen.isNotEmpty ?? false) && !(_selectedDateToFilter?.isTwentyFourHour ?? true)) Text(dayOfTheWeek(context, _selectedDateToFilter?.dayOfWeek ?? 0), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
//                                                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isThirtyMinutesPer ?? false) Text('Slot: ${DateFormat.jm().format(_selectedDateToFilter?.hoursOpen.first.start.add(Duration(minutes: (30 * e))) ?? DateTime.now())}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false) Text('Slot: ${DateFormat.jm().format(_selectedDateToFilter?.hoursOpen.first.start.add(Duration(minutes: (60 * e))) ?? DateTime.now())}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false) Text('Slot: ${DateFormat.jm().format(_selectedDateToFilter?.hoursOpen.first.start.add(Duration(minutes: (120 * e))) ?? DateTime.now())}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                         ).toList(),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ),
//          ]
//         )
//       ),
//     );
//   }
// }