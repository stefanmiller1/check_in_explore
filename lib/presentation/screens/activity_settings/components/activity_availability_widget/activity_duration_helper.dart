import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

Widget customCalendarType(BuildContext context, DashboardModel model, DateRangePickerController dController, {required Function(DateTimeRange) updateDate}) {
  return Container(
    height: 500,
    width: 500,
    child: SfDateRangePicker(
      // initialSelectedRange: PickerDateRange(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromStarting, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.fromEnding),
      navigationMode: DateRangePickerNavigationMode.snap,
      controller: dController,
      view: DateRangePickerView.month,
      allowViewNavigation: false,
      enableMultiView: false,
      enablePastDates: false,
      showNavigationArrow: true,
      showTodayButton: true,
      monthViewSettings: DateRangePickerMonthViewSettings(
      firstDayOfWeek: 1,
      ),
      headerHeight: 70,
      headerStyle: DateRangePickerHeaderStyle(
          textStyle: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)
      ),
      selectionMode: DateRangePickerSelectionMode.extendableRange,
      todayHighlightColor: model.paletteColor,
      rangeTextStyle: TextStyle(
          color: model.paletteColor.withOpacity(0.7)),
      selectionTextStyle:  TextStyle(
          color: model.accentColor,
          fontWeight: FontWeight.bold),
      onSelectionChanged: (
          DateRangePickerSelectionChangedArgs args) {

        if (args.value is PickerDateRange) {
          final DateTime rangeStartDate = args.value.startDate;
          final DateTime rangeEndDate = args.value.endDate;

          updateDate(DateTimeRange(start: rangeStartDate, end: rangeEndDate));

        }
      },
    ),
  );
}

int getNumberOfMinutesInListOfHours(int durationType, List<DateTimeRange> hours) {
  int? totalCount;
  totalCount = 0;

  totalCount = hours.map((e) => e.duration.inMinutes).fold(0, (p, c) => p+c);
  totalCount = (totalCount ~/ durationType).toInt();

  return totalCount;
}

List<DateTime> retrieveDatesFromSelectedWeekday(List<DayOptionItem> hoursList, DateTime startingDate) {
  List<DateTime> listToCreate = [];

  print(hoursList.map((e) => e));

  for (DayOptionItem dayOption in hoursList) {
    if (dayOption.hoursOpen.isNotEmpty && !dayOption.isClosed || dayOption.isTwentyFourHour) {
      final int daysTillEndOfWeek = 7 - startingDate.weekday;
      print('till weeks over $daysTillEndOfWeek');
      print('week ${dayOption.week}');
      print('day of the week ${dayOption.dayOfWeek}');
      print('starting day ${startingDate.weekday}');

      if (dayOption.week == 0) {

        listToCreate.add(startingDate.add(Duration(days:  dayOption.dayOfWeek - startingDate.weekday)));
      } else if (dayOption.week == 1) {

        listToCreate.add(startingDate.add(Duration(days: daysTillEndOfWeek + dayOption.dayOfWeek)));
      } else if (dayOption.week == 2) {

        listToCreate.add(startingDate.add(Duration(days: daysTillEndOfWeek + (7) + dayOption.dayOfWeek)));
      } else {

        listToCreate.add(startingDate.add(Duration(days: daysTillEndOfWeek + (7 * (dayOption.week - 1)) + dayOption.dayOfWeek)));
      }
    }
  }

  print(listToCreate);
  return listToCreate;
}


int getNumberOfRangeSessionsToAdd(int selectedSession, int totalDaysInDuration) {
  return (totalDaysInDuration/selectedSession).round();
}


int subtractFromStartingWeekDay(int weekDay) {

  if (weekDay == 1) {
    return 0;
  }

  if (weekDay == 2) {
    return 1;
  }

  if (weekDay == 3) {
    return 2;
  }

  if (weekDay == 4) {
    return 3;
  }

  if (weekDay == 5) {
    return 4;
  }

  if (weekDay == 6) {
    return 5;
  }

  if (weekDay == 7) {
    return 6;
  }

  return 0;
}