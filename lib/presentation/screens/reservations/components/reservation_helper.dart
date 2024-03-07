import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/reservation_post/system_post.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_details_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/invite_widgets/send_invitation_request.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/tabHelper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/webview_controller_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_attendees/activity_attendees_list_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/activity_settings_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/focused_main_container_widgets/activity_ticket_settings_widget/activity_ticket_settings_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_ticket_settings_widget/activity_ticket_sub_container_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:check_in_facade/auth/notification_facade/notification_core_config.dart';



enum ResSettingMarker {details, manageActivity, manageAttendance, manageActivityTickets, manageActivityAttendees, manageActivityPasses, messageOwner, sendInvites, addCalendar, receipts, showListing, leaveReservation}
enum ResOverviewMarker {messageHost, receipts, showListing, getSupport}
enum ResOverViewTabs {activity, reservation, discussion}

class ReservationCoreHelper {

  static ResOverViewTabs resOverViewTabs = ResOverViewTabs.discussion;
  static late bool showSuggestions = true;
  static late PageController? pageController = null;
}

class ReservationSettingListModel {

  final String title;
  final IconData icon;
  final ResSettingMarker marker;

  ReservationSettingListModel({
    required this.title,
    required this.icon,
    required this.marker
  });
}

class ReservationOverviewModel {

  final String title;
  final IconData icon;
  final ResOverviewMarker marker;

  ReservationOverviewModel({
    required this.title,
    required this.icon,
    required this.marker
  });
}

bool showAffiliateOnBoarding(AttendeeType type) {
  switch (type) {
    case AttendeeType.free:
      return false;
    case AttendeeType.tickets:
      return false;
    case AttendeeType.pass:
      return false;
    case AttendeeType.instructor:
      return true;
    case AttendeeType.vendor:
      return true;
    case AttendeeType.partner:
      return true;
    case AttendeeType.organization:
      return true;
    case AttendeeType.interested:
      return true;
  }
}

bool activitySetupComplete(ActivityManagerForm activityForm) => (activityForm.profileService.activityBackground.activityProfileImages != null && activityForm.profileService.activityBackground.activityProfileImages?.isNotEmpty == true && activityForm.profileService.activityBackground.activityTitle.isValid() && activityForm.profileService.activityBackground.activityDescription1.isValid());

/// tab items for top tab controller
List<TabBadge> tabItems(List<AccountNotificationItem> notifications) {
  final List<TabBadge> tabs = [];

  for (ResOverViewTabs tab in ResOverViewTabs.values) {
    if (tab == ResOverViewTabs.activity) {
      tabs.add(TabBadge(notifications.where((element) => element.notificationType == AccountNotificationType.activity).isNotEmpty, notifications.where((element) => element.notificationType == AccountNotificationType.activity).length.toString(), tab.name.toString(), tab));
    } else if (tab == ResOverViewTabs.discussion) {
      tabs.add(TabBadge(notifications.where((element) => element.notificationType == AccountNotificationType.activityPost).isNotEmpty, notifications.where((element) => element.notificationType == AccountNotificationType.activityPost).length.toString(), tab.name.toString(), tab));
    } else if (tab == ResOverViewTabs.reservation) {
      tabs.add(TabBadge(notifications.where((element) => element.notificationType == AccountNotificationType.reservation).isNotEmpty, notifications.where((element) => element.notificationType == AccountNotificationType.reservation).length.toString(), tab.name.toString(), tab));
    }
  }
  return tabs;
}

Widget loadReservations(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 25,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            height: 100,
            width: MediaQuery.of(context).size.width,
        ),
      ]
    ),
  );
}



List<ReservationSettingListModel> resSettingsList(BuildContext context, ActivityManagerForm? activity, bool isOwner, bool isAttendee) {
  return [
    if (activity != null && activity.activityAttendance.isTicketBased == true && isOwner) ReservationSettingListModel(title: 'Manage Tickets', icon: Icons.airplane_ticket_outlined, marker: ResSettingMarker.manageActivityTickets),
    ReservationSettingListModel(title: (isOwner) ? 'Manage Attendees' : 'Attendees', icon: Icons.people_outline, marker: ResSettingMarker.manageActivityAttendees),
    if (activity != null && activity.activityAttendance.isPassBased == true && isOwner) ReservationSettingListModel(title: 'Manage Passes', icon: Icons.credit_card, marker: ResSettingMarker.manageActivityPasses),
    if (isOwner) ReservationSettingListModel(title: 'Manage Activity', icon: Icons.directions_run_outlined, marker: ResSettingMarker.manageActivity),
    if (isAttendee && !(isOwner)) ReservationSettingListModel(title: 'Manage Attendance', icon: Icons.directions_run_outlined, marker: ResSettingMarker.manageAttendance),
    ReservationSettingListModel(title: 'Reservation Details', icon: Icons.info_outline_rounded, marker: ResSettingMarker.details),
    if (isOwner) ReservationSettingListModel(title: 'Listing Manager', icon: Icons.messenger_outline, marker: ResSettingMarker.messageOwner),
    if (isOwner || activity != null && activity.activityAttendance.isLimitedAttendance == true) ReservationSettingListModel(title: 'Send Invites', icon: Icons.group_outlined, marker: ResSettingMarker.sendInvites),
    ReservationSettingListModel(title: 'Add Dates to Calendar', icon: Icons.calendar_today_outlined, marker: ResSettingMarker.addCalendar),
    if (isOwner) ReservationSettingListModel(title: 'Get Receipt', icon: Icons.receipt_long_rounded, marker: ResSettingMarker.receipts),
    ReservationSettingListModel(title: 'Show Listing', icon: Icons.home_outlined, marker: ResSettingMarker.showListing),
    if (!isOwner) ReservationSettingListModel(title: 'Leave Listing', icon: Icons.cancel_outlined, marker: ResSettingMarker.leaveReservation),
  ];
}

void updateNotifications(BuildContext context, DashboardModel model, ResOverViewTabs tab, List<AccountNotificationItem> notifications) {

  switch (tab) {

    case ResOverViewTabs.activity:
      LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
      e.notificationType == AccountNotificationType.activity).map((e) => e.notificationId).toList(),
          model.paletteColor,
          model.accentColor
      );
      break;
    case ResOverViewTabs.reservation:
      LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
      e.notificationType == AccountNotificationType.reservation).map((e) => e.notificationId).toList(),
          model.paletteColor,
          model.accentColor
      );
      break;
    case ResOverViewTabs.discussion:
      LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
          e.notificationType == AccountNotificationType.activityPost).map((e) => e.notificationId).toList(),
          model.paletteColor,
          model.accentColor
      );
      break;
  }
}

void presentNewAttendeeJoin(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 750,
                  width: 600,
                  decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ReservationCreateNewAttendee(
                    model: model,
                    reservation: reservation,
                    activityForm: activity,
                    resOwner: reservationOwner,
                    isFromInvite: false,
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
      );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ReservationCreateNewAttendee(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
      })
    );
  }
}

void presentNewTicketAttendeeJoin(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 750,
                  width: 600,
                  decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ReservationCreateTicketAttendee(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                  )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
          )
        );
      }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ReservationCreateTicketAttendee(
              model: model,
              reservation: reservation,
              activityForm: activity,
              resOwner: reservationOwner,
          );
        }
      )
    );
  }
}




void presentPartnershipRequestAttendee(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 750,
                    width: 600,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: ReservationRequestPartnershipAttendee(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                      isFromInvite: false,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ReservationRequestPartnershipAttendee(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
        }
    )
    );
  }
}



void presentNewInstructorAttendee(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 750,
                    width: 600,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: CreateNewInstructorForm(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                      isFromInvite: false,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return CreateNewInstructorForm(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
        }
      )
    );
  }
}


void presentNewVendorAttendee(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 750,
                    width: 600,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: CreateNewVendorMerchant(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                      isFromInvite: false,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return CreateNewVendorMerchant(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
        }
      )
    );
  }

}

void presentMoreOptions(BuildContext context, DashboardModel model, bool isReservationOwner, UserProfileModel currentUser, ActivityManagerForm? activity, ReservationItem reservation, ListingManagerForm listing, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendee, {required Function(ResSettingMarker) didUpdateMarkerWeb, required Function didLeaveListing}) {
  showDialog(context: context, builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.all(12),
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(
         mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 600,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: resSettingsList(context, activity, isReservationOwner, currentAttendee != null).map(
                          (e) => profileSettingItemWidget(
                                model,
                                e.icon,
                                e.title,
                                false,
                                didSelectItem: () {
                                  Navigator.of(context).pop();

                                  if (!(kIsWeb)) {
                                    switch (e.marker) {
                                      case ResSettingMarker.details:
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                            return ReservationDetailsWidget(
                                                model: model,
                                                listing: listing,
                                                reservationItem: reservation,
                                                isReservationOwner: isReservationOwner,
                                                allAttendees: allAttendees,
                                                currentUser: currentUser,
                                                isFromChat: false
                                              );
                                            })
                                          );
                                        break;
                                      case ResSettingMarker.messageOwner:
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (_) {
                                                return DirectChatScreen(
                                                  model: model,
                                                  room: null,
                                                  currentUser: currentUser,
                                                  reservationItem: reservation,
                                                  isFromReservation: true,
                                                );
                                              }));

                                        break;
                                      case ResSettingMarker.sendInvites:
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                            return SendInvitationRequest(
                                              model: model,
                                              currentUser: currentUser,
                                              attendeeType: AttendeeType.free,
                                              reservationItem: reservation,
                                              inviteType: InvitationType.reservation,
                                              didSelectInvite: (contacts) {},

                                            );
                                          })
                                        );
                                        break;
                                      case ResSettingMarker.addCalendar:
                                        // TODO: Handle this case.
                                        break;
                                      case ResSettingMarker.receipts:
                                        if (reservation.receipt_link != null) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_) {
                                                  return WebViewWidgetComponent(
                                                    urlString: reservation.receipt_link!,
                                                    model: model,
                                                );
                                              })
                                            );
                                          }
                                        break;
                                      case ResSettingMarker.showListing:
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                            return FacilityPreviewScreen(
                                              isAutoImplyLeading: true,
                                              model: model,
                                              listing: listing,
                                              selectedReservationsSlots: null,
                                              listingId: listing.listingServiceId,
                                              // marker: MapMarker(
                                              //     childMarkerId: listing.listingServiceId.getOrCrash(),
                                              //     markerId: listing.listingServiceId.getOrCrash(),
                                              //     position: LatLng(
                                              //         double.parse(listing
                                              //             .listingProfileService.listingLocationSetting.longLat
                                              //             .split(',')[0]),
                                              //         double.parse(listing
                                              //             .listingProfileService.listingLocationSetting.longLat
                                              //             .split(',')[1])),
                                              //     markerTitle: completeTotalPriceWithOutCurrency((listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listing.listingProfileService.backgroundInfoServices.currency),
                                              //     icon: BitmapDescriptor.defaultMarker
                                              //  ).toMarker(),
                                                didSelectBack: () {  },
                                                didSelectReservation: (listing, res) {

                                                },
                                              );
                                             }
                                            )
                                          );
                                        break;
                                      case ResSettingMarker.manageActivity:
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                            return ActivitySettingsScreenMobile(
                                              model: model,
                                              reservationItem: reservation,
                                              activityManagerForm: activity,
                                              listing: listing,
                                              currentUser: currentUser,
                                            );
                                          }));
                                        break;
                                      case ResSettingMarker.manageAttendance:
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                          return ActivitySettingsScreenMobile(
                                            model: model,
                                            reservationItem: reservation,
                                            activityManagerForm: activity,
                                            listing: listing,
                                            currentUser: currentUser,
                                          );
                                        }));
                                        break;
                                      case ResSettingMarker.leaveReservation:
                                        didLeaveListing();
                                        break;
                                      case ResSettingMarker.manageActivityAttendees:
                                        Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
                                          return ActivityAttendeesListScreen(
                                            model: model,
                                            reservationItem: reservation,
                                            activityManagerForm: activity,
                                            currentUser: currentUser,
                                            didSelectAttendee: (AttendeeItem attendee, UserProfileModel user) {
                                              Navigator.of(newContext).push(MaterialPageRoute(builder: (_) {
                                                  return ReviewCurrentProfile(
                                                    currentUser: user,
                                                    model: model,
                                                    didSelectEditProfile: (profile) {

                                                    },
                                                  );
                                                },
                                              )
                                            );
                                          });
                                        }));
                                        break;
                                      case ResSettingMarker.manageActivityPasses:
                                        break;
                                      case ResSettingMarker.manageActivityTickets:
                                        Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
                                          return ActivityTicketSubContainer(
                                              model: model,
                                              currentReservationItem: reservation,
                                              currentActivityManagerForm: activity,
                                              didSelectTicketItem: (ticket) {
                                                    Navigator.of(newContext).push(MaterialPageRoute(builder: (_) {
                                                      return ActivityTicketSettingsMainContainerWidget(
                                                          model: model,
                                                          reservationItem: reservation,
                                                          activityManagerForm: activity,
                                                          selectedTicketOption: ticket,
                                                          rebuild: () {

                                                    },
                                                  );
                                                })
                                              );
                                            }
                                          );
                                        }));
                                        break;
                                      }
                                    } else {
                                  didUpdateMarkerWeb(e.marker);
                                }
                              }
                            ),
                  ).toList()
                ),
              ),
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 600,
                height: 45,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
              ),
            )
          ],
        ),
      );
    }
  );
}

List<Post> retrieveSystemMessages(ReservationItem reservation, UniqueId currentUser) {
  List<Post> systemMessage = [];

    for (ReservationSlotItem resSlot in reservation.reservationSlotItem) {
      for (ReservationTimeFeeSlotItem slot in resSlot.selectedSlots) {
        if (slot.slotRange.start.isBefore(DateTime.now())) {
          systemMessage.add(Post(
              id: slot.slotRange.start.millisecondsSinceEpoch.toString(),
              createdAt: slot.slotRange.start,
              authorId: currentUser,
              systemPost: SystemPost(
                text: 'The ${DateFormat.jm().format(slot.slotRange
                    .start)} Reservation is aAbout to begin, if you have any issues you can contact the owner here.'
              ),
            type: PostType.system
        ));
      }
    }
  }

  return systemMessage;
}