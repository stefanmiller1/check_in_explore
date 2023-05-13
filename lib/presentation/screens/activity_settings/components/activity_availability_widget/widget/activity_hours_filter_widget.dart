import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

class ActivityHoursFilterWidget extends StatefulWidget {

  final DashboardModel model;
  final List<int> selectableWeekDay;
  final List<int> selectableWeeks;
  final DayOptionItem selectedDayOption;
  final DateTime endDate;
  final DateTime startDate;
  final bool isClosed;
  final Function(List<DayOptionItem> savedList, bool isTwentyFour, bool isClosed) saveOptions;

  const ActivityHoursFilterWidget({Key? key, required this.model, required this.selectableWeekDay, required this.selectedDayOption, required this.isClosed, required this.saveOptions, required this.selectableWeeks, required this.endDate, required this.startDate}) : super(key: key);

  @override
  State<ActivityHoursFilterWidget> createState() => _ActivityHoursFilterWidgetState();
}

class _ActivityHoursFilterWidgetState extends State<ActivityHoursFilterWidget> {

  ScrollController? _scrollController;
  List<DateTimeRange> _createdDayOption = [];
  List<DayOptionItem> _dayOptions = [];
  List<int> _selectedDate = [];
  List<int> _selectedWeek = [];
  String? _selectedAllDay;
  String? _selectedClosed;

  @override
  void initState() {
     _scrollController = ScrollController();
     _selectedWeek.add(widget.selectedDayOption.week);
     _selectedDate.add(widget.selectedDayOption.dayOfWeek);
     _createdDayOption.addAll(widget.selectedDayOption.hoursOpen);

     if (widget.selectedDayOption.isTwentyFourHour) {
       _selectedAllDay = 'AllDay';
      }

     if (widget.selectedDayOption.isClosed) {
       _selectedClosed = 'Closed';
     }

    super.initState();
  }

  @override
  void dispose() {
    _selectedDate.clear();
    _dayOptions.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      scrollable: true,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      )
                  )
              ),
            onPressed: () {

                if (widget.selectableWeeks.length >= 1) {
                  for (int week in _selectedWeek) {
                    for (int day in _selectedDate) {

                        _dayOptions.add(DayOptionItem(week: week, month: widget.startDate.month, dayOfWeek: day, isClosed: _selectedClosed == 'Closed', isTwentyFourHour: _selectedAllDay == 'AllDay', hoursOpen: _createdDayOption));


                        if (week == 0 && widget.startDate.weekday > day) {
                          final int index = _dayOptions.indexWhere((element) => element.week == week && element.dayOfWeek == day);
                          _dayOptions.replaceRange(index, index + 1, [(DayOptionItem(week: week, month: widget.startDate.month, dayOfWeek: day, isClosed: true, isTwentyFourHour: false, hoursOpen: []))]);
                        } else if (week == widget.selectableWeeks.last && widget.endDate.weekday < day) {
                          final int index = _dayOptions.indexWhere((element) => element.week == week && element.dayOfWeek == day);
                          _dayOptions.replaceRange(index, index + 1, [(DayOptionItem(week: week, month: widget.startDate.month, dayOfWeek: day, isClosed: true, isTwentyFourHour: false, hoursOpen: []))]);
                      }
                    }
                  }
                } else {
                  for (int day in _selectedDate) {
                    _dayOptions.add(DayOptionItem(week: 0, month: widget.startDate.month, dayOfWeek: day, isClosed: _selectedClosed == 'Closed', isTwentyFourHour: _selectedAllDay == 'AllDay', hoursOpen: _createdDayOption));
                  }
                }


              widget.saveOptions(
                  _dayOptions,
                  _selectedAllDay == 'AllDay',
                  _selectedClosed == 'Closed',
              );


            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.save, style: TextStyle(
              color: widget.model.accentColor,
              fontWeight: FontWeight.bold)),
            )
          ),
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      backgroundColor: widget.model.webBackgroundColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.activityAvailabilityDateRecurringNotAvailableTitle, style: TextStyle(
              color: widget.model.paletteColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize)),
          Text('Select any Week or Day You want to Change', style: TextStyle(
          color: widget.model.paletteColor, fontSize: 13))
        ],
      ),

      content: Container(
        height: 600,
        width: 500,
        child: Column(
          children: [

            Align(alignment: Alignment.centerRight,
              child: Container(
                height: 40,
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
                              side: BorderSide(width: 1, color: widget.model.paletteColor.withOpacity(0.6)),
                              borderRadius: const BorderRadius.all(Radius.circular(50)),

                            )
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDate.clear();
                        _selectedDate.addAll([1,2,3,4,5,6,7]);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Select All', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                    )
                ),
              ),
            ),
            // if (widget.selectableWeeks.length >= 6) Container(
            //   height: 80,
            //   width: 490,
            //   child: SingleChildScrollView(
            //     controller: _scrollController!,
            //     scrollDirection: Axis.horizontal,
            //     child: Container(
            //       height: 80,
            //       child: Row(
            //         children: widget.selectableWeeks.asMap().map(
            //                 (i, value) {
            //               return MapEntry(i, Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Container(
            //                     height: 45,
            //                     child: TextButton(
            //                         style: ButtonStyle(
            //                             backgroundColor: MaterialStateProperty.resolveWith<Color>(
            //                                   (Set<MaterialState> states) {
            //
            //                                 if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
            //                                   return widget.model.paletteColor.withOpacity(0.1);
            //                                 }
            //                                 if (states.contains(MaterialState.hovered)) {
            //                                   return widget.model.paletteColor.withOpacity(0.1);
            //                                 }
            //                                 return _selectedWeek.contains(value) ? widget.model.paletteColor : widget.model.accentColor; // Use the component's default.
            //                               },
            //                             ),
            //                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                                 RoundedRectangleBorder(
            //                                   side: BorderSide(width: 1, color: widget.model.paletteColor),
            //                                   borderRadius: const BorderRadius.all(Radius.circular(35)),
            //                                 )
            //                             )
            //                         ),
            //                         onPressed: () {
            //                           setState(() {
            //                             if (_selectedWeek.contains(value)) {
            //                               _selectedWeek.remove(value);
            //                             } else {
            //                               _selectedWeek.add(value);
            //                             }
            //                           });
            //                         },
            //                         child: Center(
            //                           child: Text(' Week ${i + 1} ', style: TextStyle(color: _selectedWeek.contains(value) ? widget.model.accentColor : widget.model.paletteColor, fontSize: 12),
            //                           ),
            //                         )
            //                     )
            //                 ),
            //               )
            //             );
            //           }
            //         ).values.toList(),
            //       ),
            //     ),
            //   ),
            // ),
            //
            // if (widget.selectableWeeks.length <= 5) Container(
            //   height: 80,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: widget.selectableWeeks.asMap().map(
            //           (i, value) {
            //             return MapEntry(i, Expanded(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Container(
            //                   height: 45,
            //                   child: TextButton(
            //                     style: ButtonStyle(
            //                         backgroundColor: MaterialStateProperty.resolveWith<Color>(
            //                               (Set<MaterialState> states) {
            //
            //                             if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
            //                               return widget.model.paletteColor.withOpacity(0.1);
            //                             }
            //                             if (states.contains(MaterialState.hovered)) {
            //                               return widget.model.paletteColor.withOpacity(0.1);
            //                             }
            //                             return _selectedWeek.contains(value) ? widget.model.paletteColor : widget.model.accentColor; // Use the component's default.
            //                           },
            //                         ),
            //                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                             RoundedRectangleBorder(
            //                               side: BorderSide(width: 1, color: widget.model.paletteColor),
            //                               borderRadius: const BorderRadius.all(Radius.circular(35)),
            //                             )
            //                         )
            //                     ),
            //                     onPressed: () {
            //                       setState(() {
            //                         if (_selectedWeek.contains(value)) {
            //                           _selectedWeek.remove(value);
            //                         } else {
            //                           _selectedWeek.add(value);
            //                         }
            //                       });
            //                     },
            //                     child: Center(
            //                       child: Text(' Week ${i + 1} ', style: TextStyle(color: _selectedWeek.contains(value) ? widget.model.accentColor : widget.model.paletteColor, fontSize: 12),
            //                     ),
            //                   )
            //                 )
            //               ),
            //             ),
            //           )
            //         );
            //       }
            //     ).values.toList(),
            //   )
            // ),
            // Text('The Month of - Starting on ${}'),
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: (widget.selectableWeekDay.length == 1) ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.selectableWeekDay.asMap().map(
                        (i, e) {
                      return MapEntry(i, isDisabledWeekDay(widget.selectableWeeks, _selectedWeek, e) ?
                      IgnorePointer(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 45,
                            width: 45,
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
                                      return widget.model.accentColor; // Use the component's default.
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: widget.model.disabledTextColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                      )
                                  )
                              ),
                              onPressed: () {

                              },
                              child: Center(child: Text(dayOfTheWeek(context, e)[0].toUpperCase(), style: TextStyle(color: widget.model.disabledTextColor, fontSize: 20))),
                            ),
                          ),
                        ),
                      ) :
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 45,
                          width: 45,
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
                                    return _selectedDate.contains(e) ? widget.model.paletteColor : widget.model.accentColor; // Use the component's default.
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: widget.model.paletteColor),
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),

                                    )
                                )
                            ),
                            onPressed: () {
                              setState(() {
                                if (_selectedDate.contains(e)) {
                                  _selectedDate.remove(e);
                                } else {
                                  _selectedDate.add(e);
                                }
                              });
                            },
                            child: Center(
                              child: Text(dayOfTheWeek(context, e)[0].toUpperCase(), style: TextStyle(color: _selectedDate.contains(e) ? widget.model.accentColor : widget.model.paletteColor, fontSize: 20)
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ).values.toList(),
              ),
            ),


            Container(
              height: 70,
              child: Row(
                children: [

                  Expanded(
                    child: RadioListTile(
                      toggleable: true,
                      value: 'AllDay',
                      groupValue: _selectedAllDay,
                      onChanged: (String? value) {

                       setState(() {
                          if (_selectedAllDay == null) {
                            _selectedAllDay = 'AllDay';
                            _selectedClosed = null;
                          } else {
                            _selectedAllDay = null;
                            _selectedClosed = null;
                          }
                        });
                      },
                      activeColor: widget.model.paletteColor,
                      title: Text(AppLocalizations.of(context)!.activityAvailabilityHoursAll, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  Expanded(
                    child: RadioListTile(
                      toggleable: true,
                      value: 'Closed',
                      groupValue: _selectedClosed,
                      onChanged: (String? value) {

                        setState(() {
                        if (_selectedClosed == null) {
                          _selectedClosed = 'Closed';
                          _selectedAllDay = null;
                        } else {
                          _selectedClosed = null;
                          _selectedAllDay = null;
                        }
                        });

                      },
                      activeColor: widget.model.paletteColor,
                      title: Text('Closed', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: _selectedClosed == null && _selectedAllDay == null,
              child: Container(
                child: Column(
                  children: _createdDayOption.asMap().map(
                      (i, e) => MapEntry(i, Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                            offset: const Offset(-10,-15),
                                            isDense: true,
                                            buttonElevation: 0,
                                            buttonDecoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(35),
                                            ),
                                            customButton: Container(
                                              decoration: BoxDecoration(
                                                color: widget.model.accentColor,
                                                borderRadius: BorderRadius.circular(35),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(DateFormat.jm().format(e.start), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onChanged: (Object? navItem) {
                                            },
                                            buttonWidth: 80,
                                            buttonHeight: 70,
                                            dropdownElevation: 1,
                                            dropdownPadding: const EdgeInsets.all(1),
                                            dropdownDecoration: BoxDecoration(
                                                boxShadow: [BoxShadow(
                                                    color: Colors.black.withOpacity(0.11),
                                                    spreadRadius: 1,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 2)
                                                )
                                                ],
                                                color: widget.model.cardColor,
                                                borderRadius: BorderRadius.circular(14)),
                                            itemHeight: 50,
                                            dropdownWidth: (widget.model.mainContentWidth)! - 100,
                                            focusColor: Colors.grey.shade100,
                                            items:
                                            (i == 0) ? twentyFourHourInterval(TimeOfDay(hour: e.start.hour, minute: 0)).map(
                                                    (f) => DropdownMenuItem<TimeOfDay>(
                                                    onTap: () {
                                                      setState(() {
                                                        _createdDayOption[i] = DateTimeRange(start: DateTime(e.start.year, e.start.month, e.start.day, f.hour, f.minute), end: e.end);
                                                      });
                                                    },
                                                    value: f,
                                                    child: Text(f.format(context), style: TextStyle(color: (f.hour > e.end.hour) ? widget.model.disabledTextColor : widget.model.paletteColor, fontWeight: (f.hour > e.end.hour) ? FontWeight.normal : FontWeight.bold)
                                                )
                                              )
                                            ).toList() :
                                            timeIntervalFromStartToTwelve(TimeOfDay(hour: _createdDayOption[i - 1].end.hour, minute: 0)).map(
                                                    (f) => DropdownMenuItem<TimeOfDay>(
                                                    onTap: () {
                                                      setState(() {
                                                        _createdDayOption[i] = DateTimeRange(start: DateTime(e.start.year, e.start.month, e.start.day, f.hour, f.minute), end: e.end);
                                                      });
                                                    },
                                                    value: f,
                                                    child: Text(f.format(context), style: TextStyle(color: (f.hour > e.end.hour) ? widget.model.disabledTextColor : widget.model.paletteColor, fontWeight: (f.hour > e.end.hour) ? FontWeight.normal : FontWeight.bold)
                                            )
                                          )
                                        ).toList()
                                      )
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                            offset: const Offset(-10,-15),
                                            isDense: true,
                                            buttonElevation: 0,
                                            buttonDecoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(35),
                                            ),
                                            customButton: Container(
                                              decoration: BoxDecoration(
                                                color: widget.model.accentColor,
                                                borderRadius: BorderRadius.circular(35),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(DateFormat.jm().format(e.end), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onChanged: (Object? navItem) {
                                            },
                                            buttonWidth: 80,
                                            buttonHeight: 70,
                                            dropdownElevation: 1,
                                            dropdownPadding: const EdgeInsets.all(1),
                                            dropdownDecoration: BoxDecoration(
                                                boxShadow: [BoxShadow(
                                                    color: Colors.black.withOpacity(0.11),
                                                    spreadRadius: 1,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 2)
                                                )
                                                ],
                                                color: widget.model.cardColor,
                                                borderRadius: BorderRadius.circular(14)),
                                            itemHeight: 50,
                                            dropdownWidth: (widget.model.mainContentWidth)! - 100,
                                            focusColor: Colors.grey.shade100,
                                            items: (i == 0) ? timeIntervalFromStartToTwelve(TimeOfDay(hour: e.start.hour, minute: 0)).map(
                                                    (f) => DropdownMenuItem<TimeOfDay>(
                                                    onTap: () {
                                                      setState(() {
                                                        _createdDayOption[i] = DateTimeRange(start: e.start, end: DateTime(e.start.year, e.start.month, e.start.day, f.hour, f.minute));
                                                      });
                                                    },
                                                    value: f,
                                                    child: Text(f.format(context), style: TextStyle(color: ((_createdDayOption.length) >= 2 && (f.hour > (_createdDayOption[i + 1].start.hour))) ? widget.model.disabledTextColor : widget.model.paletteColor, fontWeight: ((_createdDayOption.length) >= 2 && (f.hour > (_createdDayOption[i + 1].start.hour))) ? FontWeight.normal : FontWeight.bold)
                                            )
                                          )
                                        ).toList() : timeIntervalFromStartToTwelve(TimeOfDay(hour: e.start.hour, minute: 0)).where((element) => element.hour > e.start.hour).map(
                                                    (f) => DropdownMenuItem<TimeOfDay>(
                                                    onTap: () {
                                                      setState(() {
                                                        _createdDayOption[i] = DateTimeRange(start: e.start, end:  DateTime(e.start.year, e.start.month, e.start.day, f.hour, f.minute));
                                                      });
                                                    },
                                                    value: f,
                                                    child: Text(f.format(context), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)
                                            )
                                          )
                                        ).toList()
                                      )
                                    ),
                                  ),

                                    Visibility(
                                      visible: i >= 1,
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.clear, size: 35, color: widget.model.paletteColor),
                                      onPressed: () {
                                        setState(() {
                                          _createdDayOption.removeAt(i);
                                        });
                                      }
                                    )
                                  )
                                )

                            ],
                          ),
                        ),
                      ),
                    )
                  ).values.toList(),
                ),
              ),
            ),

            SizedBox(height: 20),
            Visibility(
              visible: _selectedClosed == 'Closed' || _selectedAllDay == 'AllDay',
              child: Container(
                height: 40,
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
                            side: BorderSide(width: 1, color: widget.model.paletteColor.withOpacity(0.6)),
                            borderRadius: const BorderRadius.all(Radius.circular(50)),

                      )
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      
                      _selectedClosed = null;
                      _selectedAllDay = null;
                      
                      if (_createdDayOption.isEmpty) {
                      _createdDayOption.add(DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16)));
                      }

                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(AppLocalizations.of(context)!.activityAvailabilityPeriodAdd, style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _selectedClosed == null && _selectedAllDay == null && (_createdDayOption.length) < 4,
              child: Container(
                height: 40,
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
                          return widget.model.accentColor; // Use the component's default.
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: widget.model.disabledTextColor),
                            borderRadius: const BorderRadius.all(Radius.circular(50)),

                      )
                    )
                  ),
                  onPressed: () {
                    setState(() {

                      if ((_createdDayOption.length) >= 1) {
                        _createdDayOption.add(DateTimeRange(start: _createdDayOption[(_createdDayOption.length) - 1].end, end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23)));
                      } else {
                        _createdDayOption.add(DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16)));
                      }

                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(AppLocalizations.of(context)!.activityAvailabilityPeriodAdd, style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isDisabledWeekDay(List<int> selectableWeeks, List<int> selectedWeeks, int selectedWeek) {
    return  selectableWeeks.length >= 1 && selectedWeeks.isNotEmpty && selectableWeeks.length != selectedWeeks.length && !selectedWeeks.contains(1) && !selectedWeeks.contains(2) && !selectedWeeks.contains(3) && !selectedWeeks.contains(4) && selectableWeeks.first == selectedWeeks.first && (widget.startDate.weekday > selectedWeek) ||
        selectableWeeks.length >= 1 && selectedWeeks.isNotEmpty && selectableWeeks.last == selectedWeeks.last && widget.endDate.weekday <= selectedWeek && selectableWeeks.length != selectedWeeks.length;
  }

}

