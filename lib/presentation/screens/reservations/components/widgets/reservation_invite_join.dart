import 'dart:ui';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget getInviteToJoinWidget(
    BuildContext context,
    DashboardModel model,
    ActivityManagerForm activityForm,
    ReservationItem reservation,
    UserProfileModel resOwner,
    bool isOwner, {
      required Function() didSelectManage,
      required Function() didSelectJoin,
      required Function() didSelectManageTickets,
      required Function() didSelectFindTickets,
      required Function() didSelectShare,
      required Function() didSelectMoreOptions
    }) {

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservation.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));
  final isEnded = reservation.reservationSlotItem.map((e) => e.selectedDate).where((element) => element.isBefore(DateTime.now())).isNotEmpty;
  final isUnrestrictedActivty = activityForm.activityAttendance.isLimitedAttendance == null && activityForm.activityAttendance.isTicketBased == null || activityForm.activityAttendance.isLimitedAttendance == false && activityForm.activityAttendance.isTicketBased == false;
  final isAttendee = false;

  return ClipRRect(
      child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        /// review reservation
        /// show res owner
        color: Colors.grey.shade200.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 700
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// TODO: Side bar to contain - (Join, Buy, Leave, Interested...Button), Activity Title, Activity Dates, Activity Location??, Attending/Interested
                      /// TODO: Hide bottom when not on discussion..

                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isUnrestrictedActivty) getAttendeesForFreeActivity(model, activityForm),
                              if (activityForm.activityAttendance.isLimitedAttendance == true) getAttendeesForFreeActivity(model, activityForm),
                              if (activityForm.activityAttendance.isTicketBased == true) getAttendeesForTicketActivity(model, activityForm),
                              const SizedBox(height: 5),
                              if (!isEnded) Text('Starting: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                              if (resSorted.first.selectedDate != resSorted.last.selectedDate) Text('Ending: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                              if (isEnded) Text('Ended: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),

                            ],
                          )
                        ),

                        const SizedBox(width: 10),
                      if (isUnrestrictedActivty) InkWell(
                        onTap: () {
                          if (isOwner) {
                            didSelectManage();
                          } else {
                            didSelectJoin();
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: 220
                          ),
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            color: model.paletteColor,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(child: Text((isOwner) ? 'Manage' : 'Join', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))),
                        ),
                      ),
                      if (activityForm.activityAttendance.isLimitedAttendance == true) InkWell(
                          onTap: () {
                            if (isOwner) {
                              didSelectManage();
                            } else {
                              didSelectJoin();
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 220
                            ),
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              color: model.paletteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(child: Text((isOwner) ? 'Manage Guests' : 'Join', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))),
                          ),
                        ),
                        if (activityForm.activityAttendance.isTicketBased == true) InkWell(
                          onTap: () {
                            if (isOwner) {
                              didSelectManageTickets();
                            } else {
                              didSelectFindTickets();
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 220
                            ),
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              color: model.paletteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(child: Text((isOwner) ? 'Manage Tickets' : 'Find Tickets', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))),
                          ),
                        ),
                        if (activityForm.activityAttendance.isPassBased == true) InkWell(
                          onTap: () {

                          },
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 220
                            ),
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              color: model.paletteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(child: Text((isOwner) ? 'Manage Passes' : 'Find Passes', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (kIsWeb) IconButton(
                            onPressed: () {
                              didSelectShare();
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.ios_share, color: model.paletteColor)
                        ),
                        if (kIsWeb) IconButton(
                            onPressed: () {
                              didSelectMoreOptions();
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert_rounded, color: model.paletteColor)
                        ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
  );
}

