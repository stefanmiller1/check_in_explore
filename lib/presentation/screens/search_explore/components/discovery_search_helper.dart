import 'dart:ui';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:flutter/material.dart';

enum discoverySearchMarker {circlesProfile, userProfiles}

bool showHeader(ReservationPreviewer res) => res.previewWeight >= 10 || res.reservation?.reservationState == ReservationSlotState.current;


IconData getIconForHeaderState(ReservationPreviewer res) {
  if (res.previewWeight >= 10) {
    return Icons.star_border_rounded;
  } else if (res.reservation?.reservationState == ReservationSlotState.current) {
    return Icons.access_time_rounded;
  }
  return Icons.star_border_rounded;
}

String getHeaderState(ReservationPreviewer res) {
  if (res.previewWeight >= 10) {
    return ' POPULAR';
  } else if (res.reservation?.reservationState == ReservationSlotState.current) {
    return ' HAPPENING NOW';
  }
  return '';
}

Widget bottomFooterDetails(BuildContext context, DashboardModel model, ReservationPreviewer res, {required Function() didSelectItem}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade800.withOpacity(0.5),
          /// when activity starts.
          /// activity owner
          /// community
          /// activity type
          /// people attending
          /// info...this is a ... activity that will happen at this location on ... ..., there are
          /// how to join (affiliiate options)
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                getSearchFooterWidget(
                    context,
                    model,
                    UniqueId(),
                    Colors.grey.shade200,
                    Colors.grey.shade200.withOpacity(0.75),
                    Colors.black,
                    null,
                    res.activityManagerForm ?? ActivityManagerForm.empty(),
                    res.reservation ?? ReservationItem.empty(),
                    didSelectItem: () {
                      didSelectItem();
                  }
                ),

                const SizedBox(height: 4),
                if (res.attendeesCount != null && res.attendeesCount != 0 || res.activityManagerForm?.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly == true) Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [

                          if (res.attendeesCount != 0 && res.attendeesCount != null) Chip(
                              backgroundColor: model.accentColor.withOpacity(0.18),
                              // elevation: 8,
                              avatar: Icon(Icons.person, color: Colors.grey.shade200, size: 18,),
                              label: Text(res.attendeesCount == 1 ? '${res.attendeesCount} Person Joined' : '${res.attendeesCount} People Joined', style: TextStyle(color: Colors.grey.shade200))
                          ),
                          const SizedBox(width: 4),
                          if (res.activityManagerForm?.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly == true) Chip(
                              backgroundColor: model.accentColor.withOpacity(0.18),
                              // elevation: 8,
                              avatar: Icon(Icons.remove_red_eye_outlined, color: Colors.grey.shade200, size: 18,),
                              label: Text('Looking For Vendors/Merchants', style: TextStyle(color: Colors.grey.shade200),)
                          ),

                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}