import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/map_listing_component.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../search_explore/components/map_helper.dart';

enum ActivityCreateNewMarker {activityDetails, additionalDetails, paymentReview}

class NewActivityModel {

  final ActivityCreateNewMarker markerItem;
  final Widget childWidget;

  NewActivityModel({required this.markerItem, required this.childWidget});

}

/// background info about the activity ///
Widget getActivityBackgroundColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, UserProfileModel user) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(activityForm.profileService.activityBackground.activityTitle.value.fold((l) => '${user.legalName.getOrCrash()}\'s Activity', (r) => r), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),

        Text(activityForm.profileService.activityBackground.activityDescription1.value.fold((l) => 'This Reservation was made ${getTitleForActivityOption(context, activityForm.activityType.activityId) ?? ''}, send ${user.legalName.getOrCrash()} a message if you\'d like to know about the space will be used.', (r) => r), style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
        const SizedBox(height: 5),
        if (activityForm.profileService.activityBackground.activityDescription2 != null) Text(activityForm.profileService.activityBackground.activityDescription2!.value.fold((l) => '', (r) => r), style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
        /// if activity is through an organization check and show associated organization...can also show if activity owner has communities/organization/partner associations.
        if (activityForm.profileService.activityBackground.isPartnersInviteOnly ?? false) Row(
          children: [
            Icon(Icons.verified, color: model.paletteColor),
            const SizedBox(width: 5),
            Text('Verified Organization')
          ],
        ),

        /// TODO: INCORPORATE THE OPTION TO JOIN AS AN INSTRUCTOR AND SHOW LIST OF INSTRUCTORS...
        /// TODO: INCORPORATE OPTION TO JOIN AS A VENDOR AND SHOW LIST OF VENDORS...
        /// TODO: INCORPORATE THE OPTION TO PARTNER
        // if (activityForm.activityType.activityType == ProfileActivityTypeOption.classesLessons && activityForm.activityBackground.classActivityBackground != null) Column(
        //   children: [
        //       Text('About The Class', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
        //       Text('Instructors'),
        //       Tab(
        //         text: 'Experience',
        //         child: ,
        //       ),
        //   ],
        // )

      ],
    ),
  );
}


Widget getActivityRequirementsColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

      ///all
      /// expectations...age, age limit,
      /// expecations class. gender, experience expectations.

      /// special requirements class, required past experience, additional req.

      /// renting, class, experiences only
      /// offered/provision, gear or equipment
      /// selling options, (events

      /// events only
      /// offered/provisions, gear, food, drinks, security,
      /// vendors or merchants - invite or allow vendors to join. --- set a fee, contact details, an image (for now...), waiting lists?
      /// tournament vendors...

    ],
  );
}

Widget getActivityRulesColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

      /// all
      /// select rules to include

      /// classes
      /// special rules

      /// all
      /// check-in form

      /// custom rules
      /// custom rules - related to specific attendee types

    ],
  );
}

/// HOW DOES THIS APPLY TO MERCHANT BASED ACTIVITIES?
/// OPTION TO JOIN VIA TICKET OR PASS ATTENDEE
Widget getActivityAttendeeOptionsColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

      /// ticket or pass options

      /// ticket options

    ],
  );
}

Widget getActivityCancellationsRefunds(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

    ],
  );
}

Widget flagOrReportActivityColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Row(
    children: [

    ],
  );
}


