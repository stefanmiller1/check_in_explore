import 'dart:ui';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Widget getReservationFooterWidget(
    BuildContext context,
    DashboardModel model,
    ActivityManagerForm activityForm,
    ReservationItem reservation,
    AttendeeItem? currentAttendee,
    List<AttendeeItem> allAttendees,
    UniqueId currentUser,
    bool isOwner,
    bool showAttendingOnly, {
      required Function() didSelectManage,
      required Function() didSelectJoin,
      required Function() didSelectManageTickets,
      required Function() didSelectFindTickets,
      required Function() didSelectManagePasses,
      required Function() didSelectFindPass,
      required Function() didSelectShare,
      required Function() didSelectMoreOptions,
      required Function() didSelectInterested,
    }) {

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservation.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));
  final isEnded = reservation.reservationSlotItem.map((e) => e.selectedDate).where((element) => element.isBefore(DateTime.now())).isNotEmpty;
  final isUnrestrictedActivity = activityForm.activityAttendance.isLimitedAttendance == null && activityForm.activityAttendance.isTicketBased == null || activityForm.activityAttendance.isLimitedAttendance == false && activityForm.activityAttendance.isTicketBased == false;


  return SizedBox(
    /// review reservation
    /// show res owner
    // color: Colors.grey.shade200.withOpacity(0.5),
    width: MediaQuery.of(context).size.width,
    height: 100,
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

                  if (isUnrestrictedActivity) getFooterForFreeActivity(
                      context,
                      model,
                      reservation,
                      activityForm,
                      resSorted,
                      isEnded,
                      isOwner,
                      showAttendingOnly,
                      currentUser,
                      false,
                      allAttendees,
                      currentAttendee,
                      didSelectManage: didSelectManage,
                      didSelectJoin: didSelectJoin,
                      didSelectInterested: didSelectInterested
                  ),
                  if (activityForm.activityAttendance.isLimitedAttendance == true) getFooterForFreeActivity(
                      context,
                      model,
                      reservation,
                      activityForm,
                      resSorted,
                      isEnded,
                      isOwner,
                      showAttendingOnly,
                      currentUser,
                      true,
                      allAttendees,
                      currentAttendee,
                      didSelectManage: didSelectManage,
                      didSelectJoin: didSelectJoin,
                      didSelectInterested: didSelectInterested
                  ),
                  if (activityForm.activityAttendance.isTicketBased == true) getFooterForTicketActivity(
                      context,
                      model,
                      activityForm,
                      resSorted,
                      isEnded,
                      isOwner,
                      showAttendingOnly,
                      currentUser,
                      allAttendees,
                      currentAttendee,
                      didSelectManageMyTicket: didSelectManageTickets,
                      didSelectFindTickets: didSelectFindTickets,
                      didSelectInterested: didSelectInterested
                  ),
                  if (activityForm.activityAttendance.isPassBased == true) getFooterForPassesActivity(
                      context,
                      model,
                      activityForm,
                      resSorted,
                      isEnded,
                      isOwner,
                      showAttendingOnly,
                      currentUser,
                      allAttendees,
                      currentAttendee,
                      didSelectManage: didSelectManagePasses,
                      didSelectJoin: didSelectFindPass,
                      didSelectInterested: didSelectInterested
                  ),

                    /// interested


                    const SizedBox(width: 4),
                    if (kIsWeb && (!(showAttendingOnly))) IconButton(
                        onPressed: () {
                          didSelectShare();
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.ios_share, color: model.paletteColor)
                    ),
                    if (kIsWeb && (!(showAttendingOnly))) IconButton(
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
  );
}


Widget getFooterForFreeActivity(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityForm, List<ReservationSlotItem> resSorted, bool isEnded, bool isOwner, bool showAttendeeOnly, UniqueId currentUser, bool isLimitedAttendance, List<AttendeeItem> allAttending, AttendeeItem? currentAttendee, {required Function() didSelectManage, required Function() didSelectJoin, required Function() didSelectInterested}) {
  
  final bool isAttending = currentAttendee?.contactStatus == ContactStatus.joined || isOwner;
  final int numberOfAttendees = allAttending.where((element) => element.attendeeType == AttendeeType.free && element.contactStatus == ContactStatus.joined).length;
  final bool attendeeLimitReached = (activityForm.activityAttendance.attendanceLimit ?? 0) <= (numberOfAttendees) || activityForm.activityAttendance.attendanceLimit == 0;

  return Expanded(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (activityForm.activityAttendance.isLimitedAttendance == true) IconButton(onPressed: () {
                                }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Attendance is limited to ${activityForm.activityAttendance.attendanceLimit ?? 1} for this activity',),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(width: 1, color: model.disabledTextColor)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.people_outline),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(numberOfAttendees == 0 ? 'Attending' : '$numberOfAttendees Attending', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (kIsWeb) Expanded(
                            child: getInterestedAttendeesActivity(
                                context,
                                model,
                                currentUser,
                                allAttending,
                                currentAttendee,
                                didSelectInterested: () {
                                  if (isAttending == false)  {
                                    didSelectInterested();
                                  }
                                }
                            ),
                          ),

                        ],
                      ),
                    ),

                      getReservationState(model, resSorted, isEnded),
                    ],
                  ),
                ),
              ),


              if (!(showAttendeeOnly)) Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   if (isLimitedAttendance && attendeeLimitReached) Flexible(
                        child: InkWell(
                          onTap: () {
                            if (isAttending) {
                              didSelectManage();
                            } else {
                              final snackBar = SnackBar(
                                  elevation: 4,
                                  backgroundColor: model.paletteColor,
                                  content: Text('Sorry, we are no longer accepting attendees.', style: TextStyle(color: model.webBackgroundColor))
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 200
                              ),
                             height: 45,
                             width: 150,
                             decoration: BoxDecoration(
                             color: (isAttending) ? model.paletteColor : model.accentColor,
                             borderRadius: const BorderRadius.all(Radius.circular(40)),
                             ),
                             child: Center(child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text((isAttending) ? 'Manage' : 'Fully Booked', style: TextStyle(color: (isAttending) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                            )
                          )
                        ),
                      ),
                    ),
                   if (isLimitedAttendance && attendeeLimitReached == false) Flexible(
                     child: InkWell(
                       onTap: () {
                         if (isAttending) {
                           didSelectManage();
                         } else {
                           didSelectJoin();
                         }
                       },
                       child: Container(
                         constraints: BoxConstraints(
                             maxWidth: 200
                         ),
                         height: 45,
                         width: 150,
                         decoration: BoxDecoration(
                           color: model.paletteColor,
                           borderRadius: const BorderRadius.all(Radius.circular(40)),
                         ),
                         child: Center(child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
                           child: Text((isAttending) ? 'Manage' : 'Join', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                         )),
                       ),
                     ),
                   ),

                   if (isLimitedAttendance == false) Flexible(
                      child: InkWell(
                        onTap: () {
                          if (isAttending) {
                            didSelectManage();
                          } else {
                            didSelectJoin();
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: 200
                          ),
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            color: model.paletteColor,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text((isAttending) ? 'Manage' : 'Join', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]
    ),
  );
}


Widget getFooterForTicketActivity(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, List<ReservationSlotItem> resSorted, bool isEnded, bool isOwner, bool showAttendeeOnly, UniqueId currentUser, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendee, {required Function() didSelectManageMyTicket, required Function() didSelectFindTickets, required Function() didSelectInterested}) {
  
      final isTicketHolder = currentAttendee?.attendeeType == AttendeeType.tickets && currentAttendee?.contactStatus == ContactStatus.joined;
      // final bool isLessThanMain = MediaQuery.of(context).size.width <= 700;
      final int numberOfTicketHolders = allAttendees.where((element) => element.attendeeType == AttendeeType.tickets && element.contactStatus == ContactStatus.joined).length;

      return Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  if (activityForm.activityAttendance.isTicketFixed == true) IconButton(onPressed: () {
                                  }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Tickets are limited to ${activityForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 1} for this activity',),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(width: 1, color: model.disabledTextColor)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.airplane_ticket_outlined),
                                              const SizedBox(width: 8),
                                              Expanded(child: Text(numberOfTicketHolders == 0 ? 'Attending' : '$numberOfTicketHolders Attending', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                                          ],
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (kIsWeb)  Expanded(
                              child: getInterestedAttendeesActivity(
                                  context,
                                  model,
                                  currentUser,
                                  allAttendees,
                                  currentAttendee,
                                  didSelectInterested: () {
                                    if (isTicketHolder == false)  {
                                      didSelectInterested();
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
                      ),
                      getReservationState(model, resSorted, isEnded),
                    ],
                  ),
                ),
              ),

              if (!(showAttendeeOnly)) Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          if (isTicketHolder) {
                            didSelectManageMyTicket();
                          } else {
                            didSelectFindTickets();
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: 180
                          ),
                          height: 45,
                          // width: 150,
                          decoration: BoxDecoration(
                            color: model.paletteColor,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text((isTicketHolder) ? 'Manage My Ticket' : 'Find Tickets', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,),
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
}


Widget getFooterForPassesActivity(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, List<ReservationSlotItem> resSorted, bool isEnded, bool isOwner, bool showAttendingOnly, UniqueId currentUser, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendee, {required Function() didSelectManage, required Function() didSelectJoin, required Function() didSelectInterested}) {

            final isPassHolder = currentAttendee?.contactStatus == ContactStatus.joined && currentAttendee?.attendeeType == AttendeeType.pass;
            final bool isLessThanMain = MediaQuery.of(context).size.width <= 700;
            final numberOfPassHolders = allAttendees.where((element) => element.attendeeType == AttendeeType.pass && element.contactStatus == ContactStatus.joined).length;

            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(width: 1, color: model.disabledTextColor)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.credit_card_outlined),
                                                    const SizedBox(width: 8),
                                                    Expanded(child: Text(numberOfPassHolders == 0 ? 'Attending' : '$numberOfPassHolders Attending', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1,)),
                                                ],
                                              ),
                                            )
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (activityForm.activityAttendance.isPassesFixed == true) IconButton(onPressed: () {
                                        }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Passes are limited to ${activityForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 1} for this activity',),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (kIsWeb) Expanded(
                                    child: getInterestedAttendeesActivity(
                                        context,
                                        model,
                                        currentUser,
                                        allAttendees,
                                        currentAttendee,
                                        didSelectInterested: () {
                                          if (isPassHolder == false)  {
                                            didSelectInterested();
                                        }
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            getReservationState(model, resSorted, isEnded),
                          ],
                        ),
                      ),
                    ),

                    if (!(showAttendingOnly)) InkWell(
                      onTap: () {
                        if (isPassHolder) {
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
                        child: Center(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text((isPassHolder) ? 'Manage My Pass' : 'Find Pass', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
              )
            ),
          ),
        ),
      ]
    ),
  );
}

Widget getInterestedAttendeesActivity(BuildContext context, DashboardModel model, UniqueId currentUser, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendees, {required Function() didSelectInterested}) {
  final bool isLessThanMain = MediaQuery.of(context).size.width <= 600;
  final bool isInterested = currentAttendees?.isInterested ?? false;
  final int numberOfInterested = allAttendees.where((element) => element.isInterested == true).length;

  return InkWell(
    onTap: () {
      didSelectInterested();
    },
    child: Container(
        decoration: BoxDecoration(
            color: (isInterested) ? model.paletteColor : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: model.disabledTextColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.remove_red_eye_outlined, color: (isInterested) ? model.accentColor : model.paletteColor),
              const SizedBox(width: 8),
              Expanded(child: Text(numberOfInterested == 0 ? 'Interested' : '$numberOfInterested Interested', style: TextStyle(color: (isInterested) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,)),
          ],
        ),
      )
    ),
  );
}

// Widget noAttendeesFooterWidget (BuildContext context, DashboardModel model, UniqueId currentUser, List<ReservationSlotItem> resSorted, bool isOwner, bool isEnded, bool showAttendingOnly, {required Function() didSelectManage, required Function() didSelectJoin, required Function() didSelectInterested}) {
//   return Expanded(
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Center(child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             getInterestedAttendeesActivity(
//                 context,
//                 model,
//                 currentUser,
//                 didSelectInterested: () {
//                     didSelectInterested();
//                 }
//             ),
//             getReservationState(model, resSorted, isEnded),
//           ],
//         )),
//         if (isOwner && !(showAttendingOnly)) Flexible(
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Flexible(
//                 child: InkWell(
//                   onTap: () {
//                     if (isOwner) {
//                       didSelectManage();
//                     } else {
//                       didSelectJoin();
//                     }
//                   },
//                   child: Container(
//                     height: 45,
//                     constraints: BoxConstraints(
//                       maxWidth: 180
//                     ),
//                     decoration: BoxDecoration(
//                       color: model.paletteColor,
//                       borderRadius: const BorderRadius.all(Radius.circular(40)),
//                     ),
//                     child: Center(child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text((isOwner) ? 'Manage Reservation' : 'Join', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold), maxLines: 1),
//                     )),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget getReservationState(DashboardModel model, List<ReservationSlotItem> resSorted, bool isEnded) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 4),
      if (!isEnded) Text('Starting: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
      if (resSorted.first.selectedDate != resSorted.last.selectedDate && isEnded == false) Text('Ending: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
      if (isEnded) Text('Ended: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
    ],
  );
}
