import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

bool retrieveWeekDayIsBeforeStartDay(DateTime startDate, DayOptionItem e, int currentWeek) {
  return currentWeek == 0 && startDate.weekday > e.dayOfWeek;
}

bool retrieveWeekDayIsAfterEndDay(DateTime endDate, DayOptionItem e,int currentWeek, int lastWeek) {
  return currentWeek == lastWeek && endDate.weekday < e.dayOfWeek;
}

bool retrieveWeekDayIsAfterEndDayForWeekOnly(DateTime startDate, DayOptionItem e, bool isWeekDurationType, int currentWeek, int lastWeek) {
  return currentWeek != 0 && currentWeek == lastWeek && isWeekDurationType && startDate.add(Duration(days: 6)).weekday < e.dayOfWeek;
}


bool isDisabledDay(DateTime startDate, DateTime endDate, DayOptionItem e, int currentWeek, int lastWeek, DurationType durationType ) {
  return (retrieveWeekDayIsBeforeStartDay(startDate, e, currentWeek) || retrieveWeekDayIsAfterEndDay(endDate, e, currentWeek, lastWeek) || retrieveWeekDayIsAfterEndDayForWeekOnly(startDate, e, durationType == DurationType.week, currentWeek, lastWeek));
}


Widget weekdayListOpenHours(BuildContext context, bool isHint, DayOptionItem? selectedItem, {required DashboardModel model, required DateTime startDate, required DateTime endDate, required DurationType durationType, required List<DayOptionItem> hoursPerDay, required int currentWeek, required Function(DayOptionItem) editWeekdays}) {
  hoursPerDay.sort((a,b) => a.dayOfWeek.compareTo(b.dayOfWeek));

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: hoursPerDay.where((element) => element.week == currentWeek).toList().asMap().map(
          (i, e) {

          return MapEntry(i, IgnorePointer(
            // ignoring: isDisabledDay(startDate, endDate, e, currentWeek, hoursPerDay.map((e) => e.week).reduce(max), durationType)
            ignoring: false,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: isHint ? null : 380,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                return model.paletteColor.withOpacity(0.1);
                              }
                              if (states.contains(MaterialState.hovered)) {
                                return model.paletteColor.withOpacity(0.1);
                              }
                              return (e.isClosed) ? model.accentColor : model.paletteColor;
                              // return (e.isClosed) ? model.accentColor : isDisabledDay(startDate, endDate, e, currentWeek, hoursPerDay.map((e) => e.week).reduce(max), durationType) ? model.accentColor : model.paletteColor; // Use the component's default.
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: model.disabledTextColor.withOpacity(0.6)),
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                          )
                        )
                      ),
                      onPressed: () {
                        editWeekdays(e);
                      },
                 child: retrieveDay(context, model, isHint, false, e)
              ),
            ),
          ),
        ),
      );
    }).values.toList(),
  );
}


Widget retrieveDay(BuildContext context, DashboardModel model, bool isHint, bool isDisabledDay, DayOptionItem day) {

  return (isDisabledDay) ?

  Padding(
    padding: isHint ? EdgeInsets.all(6) : EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: Text(dayOfTheWeek(context, day.dayOfWeek), style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.normal, fontSize: model.secondaryQuestionTitleFontSize), overflow: TextOverflow.ellipsis)),
        SizedBox(width: 10),
        Visibility(
          visible: day.isTwentyFourHour,
          child: Align(
              alignment: Alignment.bottomRight,
              child: Text(AppLocalizations.of(context)!.activityAvailabilityHoursOpen, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize))),
        ),
        Visibility(
          visible: !day.isTwentyFourHour && !day.isClosed,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: day.hoursOpen.map(
                    (f) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(f.start), style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold)),
                      Text(' - ', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold)),
                      Text(DateFormat.jm().format(f.end), style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ).toList()
          ),
        ),
        Visibility(
            visible: day.isClosed,
            child: Text(AppLocalizations.of(context)!.closed, style: TextStyle(color: model.disabledTextColor, fontSize: (isHint) ? null : model.secondaryQuestionTitleFontSize))
        ),
      ],
    ),
  ) : Padding(
    padding: isHint ? EdgeInsets.all(6) : EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: Text(dayOfTheWeek(context, day.dayOfWeek), style: TextStyle(color: (day.isClosed) ? model.paletteColor : model.accentColor, fontWeight: (day.isClosed) ? FontWeight.normal : FontWeight.bold, fontSize: (isHint) ? null : model.secondaryQuestionTitleFontSize), overflow: TextOverflow.ellipsis)),
        SizedBox(width: 10),
        Visibility(
          visible: day.isTwentyFourHour,
          child: Align(
              alignment: Alignment.bottomRight,
              child: Text(AppLocalizations.of(context)!.activityAvailabilityHoursOpen, style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize))),
        ),
        Visibility(
          visible: !day.isTwentyFourHour && !day.isClosed,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: day.hoursOpen.map(
                    (f) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(f.start), style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold)),
                      Text(' - ', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold)),
                      Text(DateFormat.jm().format(f.end), style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ).toList()
          ),
        ),
        Visibility(
            visible: day.isClosed,
            child: Text(AppLocalizations.of(context)!.closed, style: TextStyle(color: model.paletteColor, fontSize: (isHint) ? null : model.secondaryQuestionTitleFontSize))
        ),
      ],
    ),
  );

}