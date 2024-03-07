import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/components/background_images_pageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class ReservationActivityInfoWidget extends StatelessWidget {

  final DashboardModel model;
  final bool showSuggestions;
  final bool isOwner;
  final bool activitySetupComplete;
  final ActivityManagerForm activityForm;
  final ReservationItem reservation;
  final UserProfileModel? activityOwner;
  final List<AttendeeItem> allAttendees;
  final List<UniqueId> linkedCommunities;
  final Function(ActivityTicketOption) didSelectActivityTicket;

  const ReservationActivityInfoWidget({super.key,
    required this.model,
    required this.activityForm,
    required this.activityOwner,
    required this.reservation,
    required this.didSelectActivityTicket,
    required this.allAttendees,
    required this.showSuggestions,
    required this.isOwner,
    required this.activitySetupComplete,
    required this.linkedCommunities
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb) const SizedBox(height: 80),
        if (!(kIsWeb)) const SizedBox(height: 155),
        Stack(
          children: [
             Visibility(
              visible: activitySetupComplete == false,
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  height: 285,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: model.disabledTextColor.withOpacity(0.25),
                      border: Border.all(color: model.disabledTextColor)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: model.disabledTextColor)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo_outlined, color: model.disabledTextColor),
                                    const SizedBox(height: 8),
                                    Text('Add Photos', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 8),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20),
                          //       border: Border.all(color: model.disabledTextColor)
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Icon(Icons.video_camera_front_outlined, color: model.disabledTextColor),
                          //         const SizedBox(height: 8),
                          //         Text('Add Short Video', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: activitySetupComplete,
              child: ActivityBackgroundImagePreview(
                activityForm: activityForm,
                model: model,
                reservation: reservation,
              ),
            ),
            /// show options to add image (6) or video (1)
            Positioned(
              left: 20,
              bottom: 20,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: showSuggestions ? 1 : 0,
                child: Chip(
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: model.mobileBackgroundColor,
                  avatar: Icon(Icons.photo_camera_outlined, color: model.disabledTextColor),
                  label: Text('Add Photos (a max. of 6)', style: TextStyle(color: model.disabledTextColor)),
                ),
              )
            ),
          ],
        ),

        const SizedBox(height: 8),
        /// background info of activity ///
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: getActivityBackgroundColumn(
              context,
              model,
              activitySetupComplete,
              showSuggestions,
              isOwner,
              activityForm,
              activityOwner,
              getPartnerAttendees(context, model, activityForm, allAttendees.where((element) => element.attendeeType == AttendeeType.partner && element.contactStatus == ContactStatus.joined).toList(), didSelectAttendee: (attendee) {}),
              getInstructorAttendees(context, model, activityForm, allAttendees.where((element) => element.attendeeType == AttendeeType.instructor && element.contactStatus == ContactStatus.joined).toList(), didSelectAttendee: (attendee) {}),
              linkedCommunities,
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
        if (Responsive.isDesktop(context)) if (activityOwner != null) if (activityForm.profileService.isActivityPost == false) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SizedBox(
              width: 400,
              child: getHostColumn(context, activityOwner!, true, model)),
        ),
        if (Responsive.isMobile(context) || Responsive.isTablet(context)) if (activityOwner != null) if (activityForm.profileService.isActivityPost == false) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: getHostColumn(context, activityOwner!, true, model),
        ),

        if (Responsive.isDesktop(context))
        if (activityForm.profileService.isActivityPost == true && activityOwner != null || activityForm.profileService.isActivityPost == null && activityOwner != null) Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
                width: 400,
                child: getPostedOnBehalfColumn(context, model, activityOwner!, activityForm))
            /// claim activity as organizer
          ],
        ),

        if (Responsive.isMobile(context) || Responsive.isTablet(context))
        if (activityForm.profileService.isActivityPost == true && activityOwner != null || activityForm.profileService.isActivityPost == null && activityOwner != null) Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
                width: 400,
                child: getPostedOnBehalfColumn(context, model, activityOwner!, activityForm))
            /// claim activity as organizer
          ],
        ),

        getActivityRequirementsColumn(
            context,
            model,
            showSuggestions,
            Responsive.isDesktop(context),
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

        Visibility(
          visible: activityForm.activityAttendance.isTicketBased == true,
          child: Column(
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