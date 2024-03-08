import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

class ActivityPricingPerHourFilterWidget extends StatefulWidget {

  final DashboardModel model;
  final int selectedDayOfWeek;
  final List<int> selectableWeekDay;
  final List<int> disabledWeekDays;
  final List<FeeRangeItem> selectedFeeOption;
  final bool isSingleTicketBased;
  final bool isSinglePassBased;
  final bool isGroupPassBased;
  final Function(List<CostPerHourSettingOption> savedList) saveOptions;

  const ActivityPricingPerHourFilterWidget({Key? key, required this.model, required this.selectedDayOfWeek, required this.selectableWeekDay, required this.selectedFeeOption, required this.isSingleTicketBased, required this.isSinglePassBased, required this.saveOptions, required this.disabledWeekDays, required this.isGroupPassBased}) : super(key: key);

  @override
  State<ActivityPricingPerHourFilterWidget> createState() => _ActivityPricingPerHourFilterWidgetState();
}

class _ActivityPricingPerHourFilterWidgetState extends State<ActivityPricingPerHourFilterWidget> {

  ScrollController? _scrollController;
  List<FeeRangeItem> _createdDayFeeOption = [];
  List<int> _selectedWeekDay = [];


  @override
  void initState() {
    _scrollController = ScrollController();
    _selectedWeekDay.add(widget.selectedDayOfWeek);

    if (widget.selectedFeeOption.isEmpty) {
    _createdDayFeeOption.add(FeeRangeItem(period: DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16))));
    } else {
      _createdDayFeeOption.addAll(widget.selectedFeeOption);
    }

    super.initState();
  }


  @override
  void dispose() {
    _createdDayFeeOption.clear();
    _selectedWeekDay.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      elevation: 0,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Visibility(
          visible: _createdDayFeeOption.length <= 4,
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
                  if ((_createdDayFeeOption.length) >= 1) {
                    _createdDayFeeOption.add(FeeRangeItem(period: DateTimeRange(start: _createdDayFeeOption[(_createdDayFeeOption.length) - 1].period.end, end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23))));
                  } else {
                    _createdDayFeeOption.add(FeeRangeItem(period: DateTimeRange(start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16))));
                  }

                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(AppLocalizations.of(context)!.activityAvailabilityPeriodAdd, style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
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

                List<CostPerHourSettingOption> advancedCostSetting = [];

                for (int day in _selectedWeekDay) {
                  advancedCostSetting.add(CostPerHourSettingOption(dayOfWeek: day, feeDuringHourRange: _createdDayFeeOption));
                }

                widget.saveOptions(
                  advancedCostSetting,
                );

              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!.save, style: TextStyle(
                    color: widget.model.accentColor,
                    fontWeight: FontWeight.bold)),
            ),
          ),
        ),


      ],
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      backgroundColor: widget.model.webBackgroundColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.activityPaymentRecurringDynamicChange, style: TextStyle(
              color: widget.model.paletteColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize)),
          Text('Select any Week or Day you want to Change', style: TextStyle(
              color: widget.model.paletteColor, fontSize: 13)),
        ],
      ),
      content: Container(
        width: 500,
        height: 600,
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight,
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

                  },
                  child: Text('Select All', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))
              ),
            ),

            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: (widget.selectableWeekDay.length == 1) ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.selectableWeekDay.asMap().map(
                        (i, e) {
                      return MapEntry(i, !widget.disabledWeekDays.contains(e) ?
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
                                    return _selectedWeekDay.contains(e) ? widget.model.paletteColor : widget.model.accentColor; // Use the component's default.
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
                                  if (_selectedWeekDay.contains(e)) {
                                    _selectedWeekDay.remove(e);
                                  } else {
                                    _selectedWeekDay.add(e);
                                  }
                                });
                              },
                              child: Center(
                                child: Text(dayOfTheWeek(context, e)[0].toUpperCase(), style: TextStyle(color: _selectedWeekDay.contains(e) ? widget.model.accentColor : widget.model.paletteColor, fontSize: 20)
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
              height: 420,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: _createdDayFeeOption.asMap().map(
                          (i, e) {

                            final TextEditingController ticketFeeController = TextEditingController();

                            if (widget.isSingleTicketBased) {
                              if (ticketFeeController.text != _createdDayFeeOption[i].feeBasedOnTicketType) {
                                ticketFeeController.text = _createdDayFeeOption[i].feeBasedOnTicketType ?? '';
                              }
                            }

                            if (widget.isSinglePassBased) {
                              if (ticketFeeController.text != _createdDayFeeOption[i].feeBasedOnGroupTicketType) {
                                ticketFeeController.text = _createdDayFeeOption[i].feeBasedOnGroupTicketType ?? '';
                              }
                            }

                            if (widget.isGroupPassBased) {
                              if (ticketFeeController.text != _createdDayFeeOption[i].feeBasedOnPerPlayerGroupTicketType) {
                                ticketFeeController.text = _createdDayFeeOption[i].feeBasedOnPerPlayerGroupTicketType ?? '';
                              }
                            }

                            return MapEntry(i, Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(width: 0.75, color: widget.model.paletteColor),
                                  borderRadius: BorderRadius.all(Radius.circular(35))
                              ),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tickets Sold Between: ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                                    Visibility(
                                        visible: i >= 1,
                                        child: Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(Icons.clear, size: 21, color: widget.model.paletteColor),
                                                onPressed: () {
                                                  setState(() {
                                                    _createdDayFeeOption.removeAt(i);
                                                  });
                                                }
                                            )
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                              // offset: const Offset(-10,-15),
                                              isDense: true,
                                              // buttonElevation: 0,
                                              // buttonDecoration: BoxDecoration(
                                              //   color: Colors.transparent,
                                              //   borderRadius: BorderRadius.circular(35),
                                              // ),
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
                                                        child: Text(DateFormat.jm().format(e.period.start), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
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
                                              // buttonWidth: 80,
                                              // buttonHeight: 70,
                                              // dropdownElevation: 1,
                                              // dropdownPadding: const EdgeInsets.all(1),
                                              // dropdownDecoration: BoxDecoration(
                                              //     boxShadow: [BoxShadow(
                                              //         color: Colors.black.withOpacity(0.11),
                                              //         spreadRadius: 1,
                                              //         blurRadius: 15,
                                              //         offset: Offset(0, 2)
                                              //     )
                                              //     ],
                                              //     color: widget.model.cardColor,
                                                  // borderRadius: BorderRadius.circular(14)),
                                              // itemHeight: 50,
                                              // dropdownWidth: (widget.model.mainContentWidth)! - 100,
                                              // focusColor: Colors.grey.shade100,
                                              items:
                                              (i == 0) ? twentyFourHourInterval(TimeOfDay(hour: e.period.start.hour, minute: 0)).map(
                                                      (f) => DropdownMenuItem<TimeOfDay>(
                                                      onTap: () {
                                                        setState(() {
                                                          _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                           period: DateTimeRange(start: DateTime(e.period.start.year, e.period.start.month, e.period.start.day, f.hour, f.minute), end: e.period.end)
                                                          );
                                                        });
                                                      },
                                                      value: f,
                                                      child: Text(f.format(context), style: TextStyle(color: (f.hour > e.period.end.hour) ? widget.model.disabledTextColor : widget.model.paletteColor, fontWeight: (f.hour > e.period.end.hour) ? FontWeight.normal : FontWeight.bold)
                                                      )
                                                  )
                                              ).toList() :
                                              timeIntervalFromStartToTwelve(TimeOfDay(hour: _createdDayFeeOption[i - 1].period.end.hour, minute: 0)).map(
                                                      (f) => DropdownMenuItem<TimeOfDay>(
                                                      onTap: () {
                                                        setState(() {
                                                          _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                            period: DateTimeRange(start: DateTime(e.period.start.year, e.period.start.month, e.period.start.day, f.hour, f.minute), end: e.period.end)
                                                          );
                                                        });
                                                      },
                                                      value: f,
                                                      child: Text(f.format(context), style: TextStyle(color: (f.hour > e.period.end.hour) ? widget.model.disabledTextColor : widget.model.paletteColor, fontWeight: (f.hour > e.period.end.hour) ? FontWeight.normal : FontWeight.bold)
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
                                              // offset: const Offset(-10,-15),
                                              isDense: true,
                                              // buttonElevation: 0,
                                              // buttonDecoration: BoxDecoration(
                                              //   color: Colors.transparent,
                                              //   borderRadius: BorderRadius.circular(35),
                                              // ),
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
                                                        child: Text(DateFormat.jm().format(e.period.end), style: TextStyle(color: widget.model.paletteColor, fontWeight:  FontWeight.normal, fontSize: 13.5 ),),
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
                                              // buttonWidth: 80,
                                              // buttonHeight: 70,
                                              // dropdownElevation: 1,
                                              // dropdownPadding: const EdgeInsets.all(1),
                                              // dropdownDecoration: BoxDecoration(
                                              //     boxShadow: [BoxShadow(
                                              //         color: Colors.black.withOpacity(0.11),
                                              //         spreadRadius: 1,
                                              //         blurRadius: 15,
                                              //         offset: Offset(0, 2)
                                              //     )
                                              //     ],
                                              //     color: widget.model.cardColor,
                                              //     borderRadius: BorderRadius.circular(14)),
                                              // itemHeight: 50,
                                              // dropdownWidth: (widget.model.mainContentWidth)! - 100,
                                              // focusColor: Colors.grey.shade100,
                                              items: (i == 0) ? timeIntervalFromStartToTwelve(TimeOfDay(hour: e.period.start.hour, minute: 0)).map(
                                                      (f) => DropdownMenuItem<TimeOfDay>(
                                                      onTap: () {
                                                        setState(() {
                                                          _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                            period: DateTimeRange(start: e.period.start, end: DateTime(e.period.start.year, e.period.start.month, e.period.start.day, f.hour, f.minute))
                                                          );
                                                        });
                                                      },
                                                      value: f,
                                                      child: Text(f.format(context), style: TextStyle(color: ((_createdDayFeeOption.length) >= 2 && (f.hour > (_createdDayFeeOption[i + 1].period.start.hour))) ? widget.model.disabledTextColor : widget.model.paletteColor, fontWeight: ((_createdDayFeeOption.length) >= 2 && (f.hour > (_createdDayFeeOption[i + 1].period.start.hour))) ? FontWeight.normal : FontWeight.bold)
                                                      )
                                                  )
                                              ).toList() : timeIntervalFromStartToTwelve(TimeOfDay(hour: e.period.start.hour, minute: 0)).where((element) => element.hour > e.period.start.hour).map(
                                                      (f) => DropdownMenuItem<TimeOfDay>(
                                                      onTap: () {
                                                        setState(() {
                                                          _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                            period: DateTimeRange(start: e.period.start, end:  DateTime(e.period.start.year, e.period.start.month, e.period.start.day, f.hour, f.minute))
                                                          );
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

                                  ],
                                ),

                                SizedBox(height: 15),
                                Text('Set Your Ticket Fee', style: TextStyle(color: widget.model.paletteColor)),
                                Container(
                                  width: 350,
                                  child: getTimeSlotAmount(
                                      AppLocalizations.of(context)!.facilityCostingTimeSlot('60'),
                                      AppLocalizations.of(context)!.facilityCostingPerSlot,
                                      AppLocalizations.of(context)!.facilityCostingEstimate('100'),
                                      context,
                                      true,
                                      false,
                                      widget.model,
                                      ticketFeeController,
                                      updateTextNow: (String e) {

                                        if (e == "\$0.00") {

                                          if (widget.isSingleTicketBased) {
                                            _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                feeBasedOnTicketType: '');
                                          }

                                          if (widget.isSinglePassBased) {
                                            _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                feeBasedOnGroupTicketType: '');
                                          }

                                          if (widget.isGroupPassBased) {
                                            _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                feeBasedOnPerPlayerGroupTicketType: '');
                                          }

                                        } else {

                                          if (widget.isSingleTicketBased) {
                                            _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                feeBasedOnTicketType: e);
                                          }

                                          if (widget.isSinglePassBased) {
                                            _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                feeBasedOnGroupTicketType: e);
                                          }

                                          if (widget.isGroupPassBased) {
                                            _createdDayFeeOption[i] = _createdDayFeeOption[i].copyWith(
                                                feeBasedOnPerPlayerGroupTicketType: e);
                                          }


                                        }
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      );
                    }
                  ).values.toList(),
                )
              ),
            ),

            Divider(thickness: 1, color: widget.model.paletteColor),
            SizedBox(height: 10),
            Text('${_createdDayFeeOption.length}/5', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize, fontWeight: FontWeight.bold))


          ],
        )
      )
    );
  }
}