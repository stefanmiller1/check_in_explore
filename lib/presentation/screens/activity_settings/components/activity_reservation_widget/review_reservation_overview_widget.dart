import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;

class ActivityAttendeeOverviewReview extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivityAttendeeOverviewReview({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  State<ActivityAttendeeOverviewReview> createState() => _ActivityAttendeeOverviewReviewState();
}


class _ActivityAttendeeOverviewReviewState extends State<ActivityAttendeeOverviewReview> {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
      child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
      listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
      listener: (context, state) {

      },
      buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: widget.model.paletteColor,
            title: Text('Review Attendance', style: TextStyle(color: widget.model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Visibility(
                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.sessionType == ActivitySessionType.recurring,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: widget.model.accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Recurring Activity', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      ),
                    ),

                    SizedBox(height: 20),
                    Visibility(
                        visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? true) && !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? true),
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(Icons.crop_free_outlined, color: widget.model.paletteColor, size: 100),
                            ),

                            // Text('For Example: On ${dayOfTheWeek(context, context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).dayOfWeek)}...', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                            Text('You Are Allowing', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.attendanceLimit ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                            Text('Attendees Per Session', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                          ],
                        )
                    ),

                    Visibility(
                        visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(Icons.airplane_ticket_rounded, color: widget.model.paletteColor, size: 100),
                            ),

                            retrieveSessionType(context, false, true),

                            /// handle visibility for day based sessions
                            Visibility(
                                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.isDayBased ?? false,
                                child: Column(
                                  children: [

                                    // Text('1 - ${getNumberOfHoursInRange(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).hoursOpen, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false).isTwentyFourHour)} Hour Session Per Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                                    Text('You Are Creating', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                                    ),
                                    Text('Tickets Per Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                                ],
                              )
                            ),
                            SizedBox(height: 15),
                        ],
                      )
                    ),

                    Visibility(
                        visible: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) && (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('OR', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 45)),
                        )
                    ),

                    Visibility(
                        visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(Icons.credit_card_rounded, color: widget.model.paletteColor, size: 100),
                            ),

                            retrieveSessionType(context, true, false),

                            /// handle visibility for day based sessions
                            Visibility(
                                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.isDayBased ?? false,
                                child: Column(
                                  children: [

                                    // Text('1 - ${getNumberOfHoursInRange(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).hoursOpen, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false).isTwentyFourHour)} Hour Session Per Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                                    Text('A Pass Covers', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                                    Visibility(
                                      visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                                      ),
                                    ),
                                      Visibility(
                                        visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('All', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                                        ),
                                      ),
                                    Text('Sessions', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                                  ],
                                )
                            ),

                        ],
                      )
                    ),

                  ],
                ),
              ),

              Visibility(
                // visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionType == ActivitySessionType.multiDay,
                  child: Column(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Multi-Day Activity', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        ),
                      ),

                      SizedBox(height: 20),

                      Visibility(
                          visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? true) && !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? true),
                          child: Column(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Icon(Icons.crop_free_outlined, color: widget.model.paletteColor, size: 100),
                              ),

                              // Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).length} Days In Sessions - For ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0} Sessions In Total', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                              Text('You Are Allowing', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.attendanceLimit ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                              ),
                              Text('Attendees', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                            ],
                          )
                      ),


                      Visibility(
                        visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(Icons.credit_card_rounded, color: widget.model.paletteColor, size: 100),
                            ),

                            // Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.where((element) => element.isClosed == false).length} Days In Sessions - For ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.sessionDetails?.length ?? 0} Sessions In Total', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                            Text('You Are Making', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                            Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.passQuantity ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            Text('Passes', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
          )
            ),
        );
        }
      )
    );
  }

  retrieveSessionType(BuildContext context, bool isPass, bool isTicket) {
    return Column(
      children: [
        // Text('For Example: On ${dayOfTheWeek(context, context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).dayOfWeek)}...', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
        /// handle visibility for time based sessions ///
        Visibility(
          // visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.a ctivityAvailability.isDayBased ?? false),
          child: Column(
            children: [

              /// half hour based
              Visibility(
                  // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.isThirtyMinutesPer ?? false,
                  child: Column(
                    children: [
                      // Text('${getNumberOfSessionsPerDay(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).hoursOpen, 30, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false).isTwentyFourHour)} - 30 minute Sessions Per Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),

                      if (isTicket) Column(
                        children: [
                          Text('You Are Creating', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                          ),
                          Text('Tickets (For Each 30 Minute Session)', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                        ],
                      ),


                      if (isPass) Column(
                        children: [
                          Text('A Pass Covers', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                          Visibility(
                            visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                          ),
                          Visibility(
                            visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('All', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                          ),
                          Text('Sessions', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                        ],
                      ),


                    ],
                  )),

              /// hour based
              Visibility(
                  // visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isSixtyMinutesPer ?? false,
                  child: Column(
                    children: [
                      // Text('${getNumberOfSessionsPerDay(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).hoursOpen, 60, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false).isTwentyFourHour)} - 60 minute Sessions Per Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),

                      if (isTicket) Column(
                        children: [
                          Text('You Are Creating', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                          ),
                          Text('Tickets (For Each 60 Minute Session)', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                        ],
                      ),

                      if (isPass) Column(
                        children: [
                          Text('A Pass Covers', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                          Visibility(
                            visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                          ),
                          Visibility(
                            // visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('All', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                          ),
                          Text('Sessions', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                        ],
                      ),

                    ],
                  )),

              /// two hour based
              Visibility(
                  // visible: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.isTwoHoursPer ?? false,
                  child: Column(
                    children: [
                      // Text('${getNumberOfSessionsPerDay(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false, orElse: () => DayOptionItem.empty()).hoursOpen, 120, context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.hoursOpen.openHours.firstWhere((element) => element.isClosed == false).isTwentyFourHour)} - 2 hour Sessions Per Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),

                      if (isTicket) Column(
                        children: [
                          Text('You Are Creating', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                          ),
                          Text('Tickets (For Each 2 Hour Session)', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                        ],
                      ),

                      if (isPass) Column(
                        children: [
                          Text('A Pass Covers', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35)),
                          Visibility(
                            visible:  !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringNumberOfSessions ?? 0}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                          ),
                          Visibility(
                            visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityPasses?.recurringPassAllSession ?? false,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('All', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 85)),
                            ),
                          ),
                          Text('Sessions', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.center,),

                        ],
                      ),

                    ],
                  )),

              if (isTicket) Text('go back to Tickets if you want to increase the number of available tickets', style: TextStyle(color: widget.model.paletteColor), textAlign: TextAlign.center),
              if (isPass) Text('go back to Passes if you want to increase the number of available tickets', style: TextStyle(color: widget.model.paletteColor), textAlign: TextAlign.center)

            ],
          ),
        ),
      ],
    );
  }

}


int getNumberOfSessionsPerDay(List<DateTimeRange> timeRanges, int sessionType, bool isAllDay) {
  int numberOfSessionsInRange = 0;

  if (isAllDay) {
      numberOfSessionsInRange = 1440;
  } else {
    for (DateTimeRange range in timeRanges) {
      numberOfSessionsInRange += range.duration.inMinutes;
    }
  }

  return numberOfSessionsInRange ~/ sessionType;
}

int getNumberOfHoursInRange(List<DateTimeRange> timeRanges, bool isAllDay) {
  int numberInRange = 0;

    if (isAllDay) {
      numberInRange = 24;
    } else {
      for (DateTimeRange range in timeRanges) {
        numberInRange += range.duration.inHours;
      }
    }

    return numberInRange;
}

