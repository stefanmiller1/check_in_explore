import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservationActivityInfoWidget extends StatelessWidget {

  final DashboardModel model;
  final ActivityManagerForm activityForm;
  final ReservationItem reservation;
  final UserProfileModel? activityOwner;

  const ReservationActivityInfoWidget({super.key,
    required this.model,
    required this.activityForm,
    required this.activityOwner,
    required this.reservation
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        /// background info of activity ///
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: getActivityBackgroundColumn(
              context,
              model,
              activityForm,
              activityOwner,
              getPartnerAttendees(model, activityForm, didSelectAttendee: (attendee) {}),
              getInstructorAttendees(model, activityForm, didSelectAttendee: (attendee) {})
          ),
        ),

        /// activity type ///
        /// ---------------------------------------------------- ///
        const SizedBox(height: 5),
        Divider(color: model.paletteColor),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ListTile(
              title: Text(getTitleForActivityOption(context, activityForm.activityType.activityId) ?? '', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
              leading: getActivityFromReservationId(
                  context,
                  model,
                  25,
                  reservation
              )
          ),
        ),

        /// activity requirements
        /// ---------------------------------------------------- ///
        const SizedBox(height: 5),
        Divider(color: model.paletteColor),
        const SizedBox(height: 5),
        getActivityRequirementsColumn(
            context,
            model,
          activityOwner,
            activityForm,
            getVendorAttendees(
                model,
                activityForm,
                didSelectAttendee: (attendee) {

                }
            ),
        ),
        const SizedBox(height: 8),

        /// activity report
        /// ---------------------------------------------------- ///
        const SizedBox(height: 5),
        Divider(color: model.paletteColor),
        const SizedBox(height: 5),
        flagOrReportActivityColumn(
            model,
            didSelectReport: () {

          }
        ),
        const SizedBox(height: 80),
      ],
    );
  }



}