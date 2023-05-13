import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:check_in_presentation/check_in_presentation.dart';


class ActivitySessionEditorWidget extends StatefulWidget {

  final DashboardModel model;
  final DateTime previousTime;
  final String sessionNumber;
  final AvailabilitySessionOption selectedSession;
  final Function(AvailabilitySessionOption session) saveSession;

  const ActivitySessionEditorWidget({Key? key, required this.model, required this.selectedSession, required this.sessionNumber, required this.previousTime, required this.saveSession}) : super(key: key);

  @override
  State<ActivitySessionEditorWidget> createState() => _ActivitySessionEditorWidgetState();
}


class _ActivitySessionEditorWidgetState extends State<ActivitySessionEditorWidget> {

  AvailabilitySessionOption? currentSession;
  TextEditingController? sessionTitle;
  TextEditingController? sessionDetails;

  @override
  void initState() {
    sessionTitle = TextEditingController();
    sessionDetails = TextEditingController();

    sessionTitle?.text = widget.selectedSession.sessionTitle.value.fold(
            (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f?.maybeMap(isEmpty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
            (r) => r);
    sessionDetails?.text = widget.selectedSession.sessionDescription.value.fold(
            (l) => l.maybeMap(textInputTitleOrDetails: (e) => e.f?.maybeMap(isEmpty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
            (r) => r);

    currentSession = widget.selectedSession;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    sessionTitle?.dispose();
    sessionDetails?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      backgroundColor: widget.model.webBackgroundColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session ${widget.sessionNumber}: Starting ${DateFormat.yMMMMd().format(currentSession?.sessionPeriod.start ?? DateTime.now())}', style: TextStyle(
              color: widget.model.paletteColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize)),
          Text('Select any Day You want to this Session to start', style: TextStyle(
              color: widget.model.paletteColor, fontSize: 13))
        ],
      ),
      actions: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected) &&
              states.contains(MaterialState.pressed) &&
              states.contains(MaterialState.focused)) {
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
            if (currentSession != null) {
              widget.saveSession(currentSession!);
            }
          },
          child: Text(AppLocalizations.of(context)!.save, style: TextStyle(
              color: widget.model.accentColor,
              fontWeight: FontWeight.bold)),
          )
        )
      ],
      content: Container(
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('When Does This Session Start?'),
            Container(
              height: 400,
              width: 500,
              child: SfDateRangePicker(
                initialSelectedDate: widget.selectedSession.sessionPeriod.start,
                navigationMode: DateRangePickerNavigationMode.snap,
                view: DateRangePickerView.month,
                minDate: widget.previousTime,
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

                  setState(() {
                  if (args.value is DateTime) {
                    DateTime dateSelected = args.value;
                    currentSession = currentSession?.copyWith(
                        sessionPeriod: DateTimeRange(start: dateSelected, end: dateSelected.add(Duration(days: 1))));
                    }
                  });
                },
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(AppLocalizations.of(context)!.facilityBackgroundMainTitle, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
            ),
            SizedBox(height: 10),
            Container(
              width: 450,
              child: getDescriptionTextField(
                  context,
                  widget.model,
                  sessionTitle!,
                  '',
                  1,
                  150,
                  updateText: (value) {
                    currentSession = currentSession?.copyWith(
                        sessionTitle: BackgroundInfoTitle(value)
                  );
                }
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(AppLocalizations.of(context)!.facilityBackgroundFacilityTopHeader, style: TextStyle(fontWeight: FontWeight.bold, color: widget.model.paletteColor)),
            ),
            SizedBox(height: 10),
            Container(
              width: 450,
              child: getDescriptionTextField(
                  context,
                  widget.model,
                  sessionDetails!,
                  '',
                  3,
                  150,
                  updateText: (value) {
                    currentSession = currentSession?.copyWith(
                        sessionDescription: BackgroundInfoDescription(value)
                    );
                  }
              ),
            ),


          ],
        )
      ),
    );
  }
}