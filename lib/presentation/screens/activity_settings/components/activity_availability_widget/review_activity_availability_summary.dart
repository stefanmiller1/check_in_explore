import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'activity_duration_helper.dart';

class ActivityAvailabilitySummary extends StatefulWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityAvailabilitySummary({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  State<ActivityAvailabilitySummary> createState() => _ActivityAvailabilitySummaryState();
}

class _ActivityAvailabilitySummaryState extends State<ActivityAvailabilitySummary> {

  DateRangePickerController? dateController;

  @override
  void initState() {
    dateController = DateRangePickerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('REVIEW'),
              SizedBox(height: 20),
              Visibility(
                visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.sessionType == ActivitySessionType.recurring,
                child: Container(
                  height: 400,
                  width: 500,
                  child: SfDateRangePicker(
                    navigationMode: DateRangePickerNavigationMode.snap,
                    view: DateRangePickerView.month,
                    minDate: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromStarting,
                    maxDate: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromEnding,
                    initialSelectedRange: PickerDateRange(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromStarting, context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromEnding),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      specialDates: retrieveDatesFromSelectedWeekday(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours, context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromStarting),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      specialDatesDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: widget.model.paletteColor),
                          color: widget.model.paletteColor.withOpacity(0.10)),
                      specialDatesTextStyle: TextStyle(color: widget.model.paletteColor),
                    ),
                    allowViewNavigation: false,
                    enableMultiView: false,
                    enablePastDates: false,
                    showNavigationArrow: true,
                    showTodayButton: true,
                    headerHeight: 70,
                    headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)
                    ),
                    selectionMode: DateRangePickerSelectionMode.single,
                    todayHighlightColor: widget.model.paletteColor,
                    rangeTextStyle: TextStyle(
                        color: widget.model.paletteColor.withOpacity(0.7)),
                    selectionTextStyle:  TextStyle(
                        color: widget.model.accentColor,
                        fontWeight: FontWeight.bold),
                    onSelectionChanged: (
                        DateRangePickerSelectionChangedArgs args) {

                    },
                  ),
                ),
              ),


              if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.sessionType == ActivitySessionType.multiDay) Visibility(
                visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
                child: Container(
                  height: 400,
                  width: 500,
                  child: SfDateRangePicker(
                    navigationMode: DateRangePickerNavigationMode.snap,
                    view: DateRangePickerView.month,
                    minDate: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromStarting,
                    maxDate: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromEnding,
                    allowViewNavigation: false,
                    enableMultiView: false,
                    enablePastDates: false,
                    showNavigationArrow: true,
                    showTodayButton: true,
                    headerHeight: 70,
                    headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)
                    ),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      // blackoutDates: getDaysInBetween(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromStarting, context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromEnding),
                      specialDates: retrieveDatesFromSelectedWeekday(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.hoursOpen.openHours, context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.fromStarting),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      blackoutDatesDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.model.paletteColor),
                      blackoutDateTextStyle: TextStyle(color: widget.model.accentColor),
                      specialDatesDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: widget.model.paletteColor),
                          color: widget.model.paletteColor.withOpacity(0.10)),
                      specialDatesTextStyle: TextStyle(color: widget.model.paletteColor),
                    ),
                    selectionMode: DateRangePickerSelectionMode.multiRange,
                    todayHighlightColor: widget.model.paletteColor,
                    rangeTextStyle: TextStyle(
                        color: widget.model.paletteColor.withOpacity(0.7)),
                    selectionTextStyle:  TextStyle(
                        color: widget.model.accentColor,
                        fontWeight: FontWeight.bold),
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {

                    },

                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}