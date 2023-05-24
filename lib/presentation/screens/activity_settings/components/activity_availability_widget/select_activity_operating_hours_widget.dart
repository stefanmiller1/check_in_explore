import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/activity_hours_filter_widget.dart';
import 'widget/activity_weekday_list_widget.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

// class ActivityOperatingHoursSelection extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivityOperatingHoursSelection({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivityOperatingHoursSelection> createState() => _ActivityOperatingHoursSelectionState();
// }
//
// class _ActivityOperatingHoursSelectionState extends State<ActivityOperatingHoursSelection> {
//
//   PageController? weekDaysPageController;
//   List<int> _selectableWeekDay = [1, 2, 3, 4, 5, 6, 7];
//   List<int> _selectedDates = [];
//   int _selectedWeek = 0;
//
//   @override
//   void initState() {
//     weekDaysPageController = PageController(
//         viewportFraction: 1,
//         initialPage: 0);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     weekDaysPageController?.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Center(
//         child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: SingleChildScrollView(
//           child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Visibility(
//                 visible: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType != DurationType.day && (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.length) >= 6),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Select Any Week You Want', style: TextStyle(
//                         color: widget.model.paletteColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                     SizedBox(height: 25),
//
//                     Container(
//                       height: 80,
//                       width: 395,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//
//                         Padding(
//                           padding: const EdgeInsets.all(3.0),
//                           child: Container(
//                             height: 70,
//                             width: 300,
//                             decoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 border: Border.all(width: 2, color: widget.model.paletteColor),
//                                 borderRadius: BorderRadius.all(Radius.circular(35))
//                             ),
//                           ),
//                         ),
//
//                         Container(
//                             child: Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_back_ios_rounded, color: widget.model.paletteColor, size: 28),
//                                   onPressed: () {
//                                     setState(() {
//                                       weekDaysPageController?.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(width: 310),
//
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_forward_ios, color: widget.model.paletteColor, size: 28),
//                                   onPressed: () {
//                                     setState(() {
//                                       weekDaysPageController?.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//                                     });
//                                   },
//                                 ),
//                               ],
//                             )
//                         ),
//
//                         Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Container(
//                             width: 285,
//                             height: 70,
//                             child: PageView.builder(
//                               controller: weekDaysPageController!,
//                               itemCount: (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.length) ~/ 7,
//                               itemBuilder: (BuildContext context, int index) {
//                                return TextButton(
//                                    style: ButtonStyle(
//                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                                              (Set<MaterialState> states) {
//                                            if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
//                                              return widget.model.paletteColor.withOpacity(0.1);
//                                            }
//                                            if (states.contains(MaterialState.hovered)) {
//                                              return widget.model.paletteColor.withOpacity(0.1);
//                                            }
//                                            return widget.model.accentColor; // Use the component's default.
//                                          },
//                                        ),
//                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                            RoundedRectangleBorder(
//                                              borderRadius: const BorderRadius.all(Radius.circular(35)),
//                                            )
//                                        )
//                                    ),
//                                    onPressed: () {
//
//                                    },
//                                    child: Text('Week ${[for(var i=0; i<(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.length); i+=1) i][index] + 1}', style: TextStyle(color: widget.model.paletteColor))
//                                  );
//                               },
//                               onPageChanged: (page) {
//                                 setState(() {
//                                   _selectedWeek = [for(var i=0; i<(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.length); i+=1) i][page];
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             ),
//
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 15),
//                   Text(AppLocalizations.of(context)!.activityAvailabilityDateRecurringNotAvailableTitle, style: TextStyle(
//                       color: widget.model.paletteColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                   SizedBox(height: 25),
//                   weekdayListOpenHours(
//                       context,
//                       false,
//                       null,
//                       model: widget.model,
//                       startDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                       endDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding,
//                       durationType: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.durationType ?? DurationType.day,
//                       currentWeek: _selectedWeek,
//                       hoursPerDay: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours,
//                       editWeekdays: (day) {
//                         _selectedDates.clear();
//                         _selectedDates.add(day.dayOfWeek);
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext contexts) {
//                             return ActivityHoursFilterWidget(
//                                     model: widget.model,
//                                     selectableWeeks: [for(var i=0; i<((context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.length)/7); i+=1) i],
//                                     endDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding,
//                                     startDate: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting,
//                                     selectableWeekDay: _selectableWeekDay,
//                                     selectedDayOption: day,
//                                     isClosed: false,
//                                     saveOptions: (List<DayOptionItem> savedList, bool isTwentyFour, bool isClosed) {
//
//                                       for (DayOptionItem dayOption in savedList) {
//                                         int index = context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.indexWhere((element) => element.dayOfWeek == dayOption.dayOfWeek && element.week == dayOption.week);
//                                         context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.replaceRange(index, index+1, [dayOption]);
//                                       }
//
//                                       setState(() {
//                                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.openHoursChanged(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours));
//                                         Navigator.of(contexts).pop();
//                               });
//                             },
//                           );
//                         }
//                       );
//                     }
//                   ),
//
//                 ],
//               )
//             ]
//           ),
//         )
//         )
//     );
//   }
// }