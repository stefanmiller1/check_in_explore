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
Widget getActivityBackgroundColumn(BuildContext context, DashboardModel model, ActivityCreatorForm activityForm, UserProfileModel user) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(activityForm.activityBackground.activityTitle.value.fold((l) => '${user.legalName.getOrCrash()}\'s Activity', (r) => r), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),

        Text(activityForm.activityBackground.activityDescription1.value.fold((l) => 'This Reservation was made ${getTitleForActivityOption(context, activityForm.activityType.activity) ?? ''}, send ${user.legalName.getOrCrash()} a message if you\'d like to know about the space will be used.', (r) => r), style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
        const SizedBox(height: 5),
        if (activityForm.activityBackground.activityDescription2 != null) Text(activityForm.activityBackground.activityDescription2!.value.fold((l) => '', (r) => r), style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
        /// if activity is through an organization check and show associated organization...can also show if activity owner has communities/organization/partner associations.
        if (activityForm.activityBackground.isAnOrganization) Row(
          children: [
            Icon(Icons.verified, color: model.paletteColor),
            const SizedBox(width: 5),
            Text('Verified Organization')
          ],
        ),

        /// TODO: INCORPORATE THE OPTION TO JOIN AS AN INSTRUCTOR AND SHOW LIST OF INSTRUCTORS...
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


