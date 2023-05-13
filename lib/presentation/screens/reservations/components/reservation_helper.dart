import 'package:check_in_application/auth/update_services/booked_reservation_services/booked_reservation_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/reservation_post/system_post.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_details_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/send_invitation_request.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/webview_controller_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/activity_settings_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';



enum ResSettingMarker {details, manageActivity, messageOwner, sendInvites, addCalendar, receipts, showListing, sendInvite, leaveReservation}
enum ResOverviewMarker {messageHost, receipts, showListing, getSupport}

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



List<ReservationSettingListModel> resSettingsList(BuildContext context, bool isOwner) {
  return [
    if (isOwner) ReservationSettingListModel(title: 'Manage Activity', icon: Icons.directions_run_outlined, marker: ResSettingMarker.manageActivity),
    ReservationSettingListModel(title: 'Reservation Details', icon: Icons.info_outline_rounded, marker: ResSettingMarker.details),
    if (isOwner) ReservationSettingListModel(title: 'Listing Manager', icon: Icons.messenger_outline, marker: ResSettingMarker.messageOwner),
    if (isOwner) ReservationSettingListModel(title: 'Send Invites', icon: Icons.group_outlined, marker: ResSettingMarker.sendInvites),
    ReservationSettingListModel(title: 'Add Dates to Calendar', icon: Icons.calendar_today_outlined, marker: ResSettingMarker.addCalendar),
    if (isOwner) ReservationSettingListModel(title: 'Get Receipt', icon: Icons.receipt_long_rounded, marker: ResSettingMarker.receipts),
    ReservationSettingListModel(title: 'Show Listing', icon: Icons.home_outlined, marker: ResSettingMarker.showListing),
    if (!isOwner) ReservationSettingListModel(title: 'Leave Listing', icon: Icons.cancel_outlined, marker: ResSettingMarker.leaveReservation),
  ];
}



void presentMoreOptions(BuildContext context, DashboardModel model, bool isReservationOwner, UserProfileModel currentUser, ReservationItem reservation, ListingManagerForm listing, List<UserProfileModel> users, {required Function didLeaveListing}) {
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
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: resSettingsList(context, isReservationOwner).map(
                          (e) => profileSettingItemWidget(
                                model,
                                e.icon,
                                e.title,
                                false,
                                didSelectItem: () {
                                  Navigator.of(context).pop();

                                    switch (e.marker) {
                                      case ResSettingMarker.details:

                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                          return ReservationDetailsWidget(
                                              model: model,
                                              listing: listing,
                                              reservationItem: reservation,
                                              isReservationOwner: isReservationOwner,
                                              profiles: users,
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
                                              currentGuests: reservation,

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
                                              marker: MapMarker(
                                                childMarkerId: listing.listingServiceId.getOrCrash(),
                                                markerId: listing.listingServiceId.getOrCrash(),
                                                position: LatLng(
                                                    double.parse(listing
                                                        .listingProfileService.listingLocationSetting.longLat
                                                        .split(',')[0]),
                                                    double.parse(listing
                                                        .listingProfileService.listingLocationSetting.longLat
                                                        .split(',')[1])),
                                                markerTitle: completeTotalPriceWithOutCurrency((listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listing.listingProfileService.backgroundInfoServices.currency),
                                                icon: BitmapDescriptor.defaultMarker
                                                ).toMarker(),
                                              );
                                            }
                                          )
                                        );
                                        break;
                                      case ResSettingMarker.sendInvite:
                                        // TODO: Handle this case.
                                        break;
                                      case ResSettingMarker.manageActivity:
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                          return ActivitySettingsScreen(
                                            model: model,
                                            reservationItem: reservation,
                                            listing: listing,
                                          );
                                        }));
                                        break;
                                      case ResSettingMarker.leaveReservation:
                                        didLeaveListing();

                                        break;
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
                width: MediaQuery.of(context).size.width,
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
                    .start)} Reservation is about to begin, if you have any issues you can contact the owner here.'
              ),
            type: PostType.system
        ));
      }
    }
  }

  return systemMessage;
}