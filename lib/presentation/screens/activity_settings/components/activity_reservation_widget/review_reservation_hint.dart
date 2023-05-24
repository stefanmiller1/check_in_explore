import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_presentation/check_in_presentation.dart';

class ActivityAttendeeHintHelper extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;

  const ActivityAttendeeHintHelper({Key? key, required this.model, required this.activityManagerForm}) : super(key: key);

  @override
  State<ActivityAttendeeHintHelper> createState() => _ActivityAttendeeHintHelperState();
}

class _ActivityAttendeeHintHelperState extends State<ActivityAttendeeHintHelper> {

  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
        padding: const EdgeInsets.all(8.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(AppLocalizations.of(context)!.activityAttendanceTypeReview, style: TextStyle(
                  color: widget.model.accentColor,
                  fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Text('${AppLocalizations.of(context)!.facilityAvailableBookingsStarting} ${DateFormat.yMMMMd().format(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.fromStarting)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),

              SizedBox(height: 10),
              Text('Quick Preview', style: TextStyle(color: widget.model.accentColor)),

              Visibility(
                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.isDayBased ?? false,
                child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      // color: Colors.transparent,
                      border: Border.all(color:  widget.model.accentColor, width: 2),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.airplane_ticket_rounded, size: 30, color: widget.model.accentColor),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${5} Tickets Left', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                                  Text('Slot: All Day', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ),

              Visibility(
                // visible: !(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isDayBased ?? true),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    // color: Colors.transparent,
                  border: Border.all(color:  widget.model.accentColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      ...[1,2,3].map(
                              (e) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.model.paletteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.airplane_ticket_rounded, size: 30, color: widget.model.accentColor),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${2 * e} Tickets Left', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                                            Text('Slot: ${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour).add(Duration(hours: e)))}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ),
                          )
                      ).toList(),
                      ...[4,5].map(
                              (e) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.model.accentColor,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(Icons.airplane_ticket_rounded, size: 30, color: widget.model.disabledTextColor.withOpacity(0.65)),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Full', style: TextStyle(color: widget.model.disabledTextColor.withOpacity(0.65), fontWeight: FontWeight.bold)),
                                          Text('Slot: ${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour).add(Duration(hours: e)))}', style: TextStyle(color: widget.model.disabledTextColor.withOpacity(0.65), fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      ).toList(),
                    ]
                  ),
                ),
              )

          ]
        )
      )
    );
  }
}


class ActivityAttendeePassHelper extends StatefulWidget {

  final DashboardModel model;

  const ActivityAttendeePassHelper({Key? key, required this.model}) : super(key: key);

  @override
  State<ActivityAttendeePassHelper> createState() => _ActivityAttendeePassHelperState();
}

class _ActivityAttendeePassHelperState extends State<ActivityAttendeePassHelper> {


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

            Text(AppLocalizations.of(context)!.activityAttendanceTypeReview, style: TextStyle(
                color: widget.model.accentColor,
                fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Text('${AppLocalizations.of(context)!.facilityAvailableBookingsStarting} ${DateFormat.yMMMMd().format(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.fromStarting)}', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),


        ]
      )
    );
  }
}