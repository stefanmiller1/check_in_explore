import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReservationActivityInfoWidget extends StatelessWidget {

  final DashboardModel model;
  final ActivityManagerForm activityForm;
  final ReservationItem reservation;
  final UserProfileModel? activityOwner;
  final ListingManagerForm listing;
  final List<AttendeeItem> allAttendees;
  final Function(ActivityTicketOption) didSelectActivityTicket;

  const ReservationActivityInfoWidget({super.key,
    required this.model,
    required this.activityForm,
    required this.activityOwner,
    required this.reservation,
    required this.listing,
    required this.didSelectActivityTicket,
    required this.allAttendees
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb) const SizedBox(height: 80),
        if (!(kIsWeb)) const SizedBox(height: 155),
        SizedBox(
          height: 285,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: PageView.builder(
                itemCount: activityForm.profileService.activityBackground.activityProfileImages?.length ?? 1,
                itemBuilder: (context, index) {
                  final String activityImage = activityForm.profileService.activityBackground.activityProfileImages?[index].uriPath ?? '';
                  if (activityImage != '') {
                    return Image.network(activityImage, fit: BoxFit.cover);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: getActivityTypeTabOption(
                        context,
                        model,
                        200,
                        false,
                        getActivityOptions().firstWhere((element) => element.activityId == reservation.reservationSlotItem.first.selectedActivityType)
                    ),
                  );
                }
            ),
          ),
        ),
        const SizedBox(height: 8),
        /// background info of activity ///
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: getActivityBackgroundColumn(
              context,
              model,
              activityForm,
              activityOwner,
              getPartnerAttendees(context, model, activityForm, allAttendees.where((element) => element.attendeeType == AttendeeType.partner && element.contactStatus == ContactStatus.joined).toList(), didSelectAttendee: (attendee) {}),
              getInstructorAttendees(context, model, activityForm, allAttendees.where((element) => element.attendeeType == AttendeeType.instructor && element.contactStatus == ContactStatus.joined).toList(), didSelectAttendee: (attendee) {}),
              reservation
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
              title: Text(getTitleForActivityOption(context, activityForm.activityType.activityId) ?? 'To Rent', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: getActivityRequirementsColumn(
              context,
              model,
              activityOwner,
              activityForm,
              getVendorAttendees(
                  context,
                  model,
                  activityForm,
                  allAttendees.where((element) => element.attendeeType == AttendeeType.vendor && element.contactStatus == ContactStatus.joined).toList(),
                  didSelectAttendee: (attendee) {

                  }
              ),
          ),
        ),

        if (activityForm.activityAttendance.isTicketBased == true) Column(
          children: [
            const SizedBox(height: 5),
            Divider(color: model.paletteColor),
            const SizedBox(height: 5),
            Row(
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: getActivityTicketOptionsColumn(
                        context,
                        model,
                        reservation,
                        activityForm,
                        didSelectTicketOption: (e) {
                          didSelectActivityTicket(e);
                        },
                        true && (Responsive.isDesktop(context) == true),
                        null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

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
        const SizedBox(height: 100),
      ],
    );
  }



}