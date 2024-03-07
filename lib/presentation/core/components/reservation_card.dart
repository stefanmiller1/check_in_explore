import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_details_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_footer_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_notification_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget noItemsFound(DashboardModel model, IconData icon, String mainTitle, String subTitle, String buttonTitle,  {required Function() didTapStartButton}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: model.accentColor
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 18),
          Icon(icon, color: model.paletteColor),
          const SizedBox(height: 18),
          Text(mainTitle, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subTitle, style: TextStyle(color: model.disabledTextColor)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              didTapStartButton();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: model.paletteColor
                ),
                child: Center(
                  child: Text(buttonTitle, style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget LoadingReservationCard(BuildContext context) {
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          Container(
              height: 80,
              width: 80,
          ),
          Expanded(
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width - 100,
            ),
          )
        ],
      ),
    ),
  );
}




Widget getReservationCardListing(BuildContext context, bool isMessenger, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, bool endedReservation, bool isSelected, List<AccountNotificationItem> notifications, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendee, List<TicketItem> activityTickets) didSelectReservation}) {
  return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservationItem.instanceId.getOrCrash())),
    child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadListingManagerItemFailure: (_) => LoadingReservationCard(context),
          loadListingManagerItemSuccess: (item) {
            return getReservationCardAttendance(context, isMessenger, item.failure, reservationItem, currentUser, model, endedReservation, isSelected, notifications, didSelectReservation: (listing, reservation, activity, attendee, activityTickets) => didSelectReservation(listing, reservation, activity, attendee, activityTickets));
          },
          orElse: () => LoadingReservationCard(context),
        );
      },
    ),
  );
}

/// check current users [UserProfileModel]'s [AttendeeItem] for [ReservationItem]
Widget getReservationCardAttendance(BuildContext context, bool isMessenger, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendance, List<TicketItem> currentAttTickets) didSelectReservation}) {
  if (reservationItem.reservationOwnerId == currentUser.userId) {
    final ownerAttendee = AttendeeItem(attendeeId: UniqueId(), attendeeOwnerId: currentUser.userId, contactStatus: ContactStatus.joined, reservationId: reservationItem.reservationId, cost: '', paymentStatus: PaymentStatusType.noStatus, attendeeType: AttendeeType.free, paymentIntentId: '', dateCreated: DateTime.now(), );
    return getReservationCardActivity(context, isMessenger, listing, reservationItem, currentUser, ownerAttendee,  model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
  } else {
  return BlocProvider(create: (_) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(reservationItem.reservationId.getOrCrash(), currentUser.userId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadAttendeeItemSuccess: (item) => getReservationCardActivity(context, isMessenger, listing, reservationItem, currentUser, item.item,  model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation),
            orElse: () => getReservationCardActivity(context, isMessenger, listing, reservationItem, currentUser, AttendeeItem.empty(),  model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation),
          );
        },
      ),
    );
  }
}


Widget getReservationCardActivity(BuildContext context, bool isMessenger, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel currentUser, AttendeeItem? attendance, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendance, List<TicketItem> currentAttTickets) didSelectReservation}) {
  return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservationItem.reservationId.getOrCrash())),
    child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadActivityManagerFormSuccess: (item) {
              return getReservationCardActivityTickets(context, isMessenger, listing, item.item, reservationItem, attendance, currentUser, model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
            },
            orElse: () {
              return getReservationCardActivityTickets(context, isMessenger, listing, ActivityManagerForm.empty(), reservationItem, attendance, currentUser, model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
            }
        );
      },
    ),
  );
}





/// an optional watcher in the case that an activity is ticket based
Widget getReservationCardActivityTickets(BuildContext context, bool isMessenger, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, AttendeeItem? attendeeItem, UserProfileModel currentUser, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendeeItem, List<TicketItem> tickets) didSelectReservation}) {
  return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchCurrentUserTicketsStarted(currentUser.userId.getOrCrash(), reservationItem.reservationId.getOrCrash())),
    child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
      builder: (context, state) {
          return state.maybeWhen(
            loadCurrentUsersTicketsSuccess: (item) {
              if (isMessenger) {
                return getMessengerReservationHeader(context, listing, activity, reservationItem, attendeeItem, currentUser, model, didSelectReservation: (listing, reservation, activity, attendeeItem) => didSelectReservation(listing, reservation, activity, attendeeItem, item));
              }
              return getReservationCardItem(context, listing, activity, reservationItem, attendeeItem, item, model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
            },
            orElse: () {
              if (isMessenger) {
                return getMessengerReservationHeader(context, listing, activity, reservationItem, attendeeItem, currentUser, model, didSelectReservation: (listing, reservation, activity, attendeeItem) => didSelectReservation(listing, reservation, activity, attendeeItem, []));
              }
              return getReservationCardItem(context, listing, activity, reservationItem, attendeeItem, [], model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
            }
          );
      }
    )
  );
}


Widget getMessengerReservationHeader(BuildContext context, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, AttendeeItem? attendeeItem, UserProfileModel currentUser, DashboardModel model, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendeeItem) didSelectReservation}) {
  late List<ReservationTimeFeeSlotItem> allSlots = [];

  for (ReservationSlotItem slots in reservationItem.reservationSlotItem) {
    for (ReservationTimeFeeSlotItem slot in slots.selectedSlots) {
      allSlots.add(slot);
    }
  }
  allSlots.sort((a,b) => a.slotRange.start.compareTo(b.slotRange.start));

  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    color: model.accentColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) Container(
            height: 55,
            width: 55,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image(
                  image: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhere((element) => element.spacePhoto != null).spacePhoto!.image,
                  errorBuilder: (context, err, stack) {
                    return getActivityTypeTabOption(
                        context, model,
                        55,
                        false,
                        getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                    );
                  },
                  fit: BoxFit.cover
              ),
            ),
          ),
          if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isEmpty) getActivityTypeTabOption(
              context, model,
              40,
              false,
              getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// name of facility
                Text('Booking: ${listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash()}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                const SizedBox(height: 4),
                /// dates
                if (reservationItem.reservationState == ReservationSlotState.refunded) Text('Booking has been Refunded', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                if (reservationItem.reservationState == ReservationSlotState.cancelled) Text('Booking has been Cancelled', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                if (reservationItem.reservationState == ReservationSlotState.confirmed) Text('You Booked ${allSlots.length} slots -- Starting: ${DateFormat.MMMd().format(allSlots.first.slotRange.start)} and Ending: ${DateFormat.MMMd().format(allSlots.last.slotRange.end)}', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                if (reservationItem.reservationState == ReservationSlotState.completed) Text('Booking Completed on ${DateFormat.MMMd().format(allSlots.last.slotRange.end)}', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      /// go to reservation
                      InkWell(
                        onTap: () {
                          didSelectReservation(listing, reservationItem, activity, attendeeItem);
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: model.disabledTextColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month_outlined, color: model.disabledTextColor,),
                                const SizedBox(width: 8),
                                Text('See Reservation', style: TextStyle(color: model.disabledTextColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                            return ReservationDetailsWidget(
                              model: model,
                              listing: listing,
                              reservationItem: reservationItem,
                              isReservationOwner: false,
                              allAttendees: [],
                              isFromChat: true,
                              currentUser: currentUser,
                              );
                            })
                          );
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: model.disabledTextColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, color: model.disabledTextColor),
                                Text('Review Reservation', style: TextStyle(color: model.disabledTextColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /// share reservation

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}



Widget getReservationCardItem(BuildContext context, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, AttendeeItem? attendeeItem, List<TicketItem> ticketsCurrentAttendee, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendeeItem, List<TicketItem> currentAttendeeTickets) didSelectReservation}) {

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));
  final bool isPrivate = (activity.rulesService.accessVisibilitySetting.isPrivateOnly == true || activity.rulesService.accessVisibilitySetting.isInviteOnly == true);

  return TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
              return model.paletteColor.withOpacity(0.1);
            }
            if (states.contains(MaterialState.hovered)) {
              return model.paletteColor.withOpacity(0.1);
            }
            return Colors.transparent; // Use the component's default.
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
           const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            )
        )
    ),
    onPressed: () {
      didSelectReservation(listing, reservationItem, activity, attendeeItem, ticketsCurrentAttendee);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: (isSelected) ? Border.all(color: model.paletteColor, width: 1.5) : null
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getReservationMediaFrame(
                    context,
                    model,
                    100,
                    100,
                    listing,
                    activity,
                    reservationItem,
                    didSelectItem: () {
                      // didSelectReservation(listing, reservationItem, activity, attendeeItem, ticketsCurrentAttendee);
                    }
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(activity.profileService.activityBackground.activityTitle.value.fold((l) => listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), (r) => r), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                if (isPrivate) Padding(
                                  padding: const EdgeInsets.only(left: 9.0),
                                  child: Icon(Icons.lock, color: model.paletteColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            /// number of attendees

                            reservationInviteNotificationTitle(
                              model,
                              Row(
                                children: [
                                  ///  free
                                  Visibility(
                                    visible: activity.activityAttendance.isLimitedAttendance == true || activity.activityAttendance.isTicketBased == null || activity.activityAttendance.isPassBased == null || activity.activityAttendance.isLimitedAttendance == null,
                                    child: getReservationCardActivityAttendees(context, model, activity),
                                  ),
                                  ///  tickets
                                  Visibility(
                                    visible: activity.activityAttendance.isTicketBased == true,
                                    child: getReservationCardActivityTicketAttendees(context, model, activity),
                                  ),
                                  Icon(Icons.favorite, color: model.paletteColor, size: 14),
                                  const SizedBox(width: 4),
                                  Text('1', style: TextStyle(color: model.paletteColor))
                                ],
                              ),
                              notifications.length
                            ),
                            const SizedBox(height: 4),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isEnded) Text('Starting: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                                if (resSorted.first.selectedDate != resSorted.last.selectedDate) Text('Ending: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                                if (isEnded) Text('Ended: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,)
                              ],
                            ),
                          ],
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: model.paletteColor.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : (getNumberOfSlotsToGo(reservationItem) == 0) ? Text('Finished', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    ),
  );
}


Widget getReservationMediaFrame(BuildContext context, DashboardModel model, double height, double width, ListingManagerForm? listing, ActivityManagerForm activity, ReservationItem reservationItem, {required Function() didSelectItem}) {
  return InkWell(
    onTap: didSelectItem,
    child: Column(
      children: [
        if (activity.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) SizedBox(
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
                activity.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
                errorBuilder: (context, err, stack) {
                  return getActivityTypeTabOption(
                      context,
                      model,
                      height,
                      false,
                      getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                  );
                },
                fit: BoxFit.cover
            ),
          ),
        ) else if (listing != null && retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) SizedBox(
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
                image: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhere((element) => element.spacePhoto != null).spacePhoto!.image,
                errorBuilder: (context, err, stack) {
                  return getActivityTypeTabOption(
                      context,
                      model,
                      height,
                      false,
                      getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                  );
                },
                fit: BoxFit.cover
            ),
          ),
        ) else getActivityTypeTabOption(
            context, model,
            height,
            false,
            getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
        ),
      ],
    ),
  );
}

Widget getSearchFooterWidget(BuildContext context, DashboardModel model, UniqueId currentUserId, Color textColor, Color secondaryTextColor, Color backgroundColor, ListingManagerForm? listing, ActivityManagerForm activity, ReservationItem reservationItem, {required Function() didSelectItem}) {
  final String? listingTitle = listing?.listingProfileService.backgroundInfoServices.listingName.getOrCrash();
  final String activityTitle = getTitleForActivityOption(context, reservationItem.reservationSlotItem.first.selectedActivityType) ?? 'rent';

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));

  final bool isEnded = resSorted.last.selectedDate.isBefore(DateTime.now());

  return InkWell(
    onTap: didSelectItem,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: const BorderRadius.all(Radius.circular(35)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.25),
                          child: retrieveUserProfile(
                            reservationItem.reservationOwnerId.getOrCrash(),
                            model,
                            null,
                            model.paletteColor,
                            model.secondaryQuestionTitleFontSize,
                            profileType: UserProfileType.firstLetterOnlyProfile,
                            trailingWidget: null,
                            selectedButton: (e) {

                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.profileService.activityBackground.activityTitle.value.fold((l) => (listing != null) ? '$activityTitle at $listingTitle' : '$activityTitle Activity', (r) => r), style: TextStyle(color: textColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                            const SizedBox(height: 3),
                            if (listing != null) Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: secondaryTextColor), maxLines: 1),
                            if (!isEnded) Text('Starts: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: secondaryTextColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (reservationItem.reservationState == ReservationSlotState.current) Chip(
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.red,
                    label: Text('On Now', style: TextStyle(
                        color: model.accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    avatar: Icon(CupertinoIcons.dot_radiowaves_left_right, size: 15, color: textColor),
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (Responsive.isMobile(context) == false) Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slots Booked', style: TextStyle(color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : (getNumberOfSlotsToGo(reservationItem) == 0) ? Text('Finished', style: TextStyle(color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Booked', style: TextStyle(color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                  )
                ),
                const SizedBox(height: 5),
                Visibility(
                  // visible: isEnded == false,
                  child: Visibility(
                    visible: activity.activityAttendance.isLimitedAttendance == true || activity.activityAttendance.isTicketBased == null || activity.activityAttendance.isPassBased == null || activity.activityAttendance.isLimitedAttendance == null,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('Join', style: TextStyle(color: backgroundColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                      ),
                    )
                  ),
                ),
                ///  tickets
                Visibility(
                  // visible: isEnded == false,
                  child: Visibility(
                    visible: activity.activityAttendance.isTicketBased == true,
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('Find Tickets', style: TextStyle(color: backgroundColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 5),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     if (!isEnded) Text('Starting: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                //     if (resSorted.first.selectedDate != resSorted.last.selectedDate) Text('Ending: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                //     if (isEnded) Text('Ended: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,)
                //   ],
                // ),
              ],
            )
          ],
        ),
        if (Responsive.isMobile(context) == true) Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            Container(
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slots Booked', style: TextStyle(color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : (getNumberOfSlotsToGo(reservationItem) == 0) ? Text('Finished', style: TextStyle(color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Booked', style: TextStyle(color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                )
            ),
            const SizedBox(width: 8),
            Visibility(
              // visible: isEnded == false,
              child: Visibility(
                  visible: activity.activityAttendance.isLimitedAttendance == true || activity.activityAttendance.isTicketBased == null || activity.activityAttendance.isPassBased == null || activity.activityAttendance.isLimitedAttendance == null,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: textColor,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('Join', style: TextStyle(color: backgroundColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                    ),
                  )
              ),
            ),
            ///  tickets
            Visibility(
              // visible: isEnded == false,
              child: Visibility(
                visible: activity.activityAttendance.isTicketBased == true,
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Find Tickets', style: TextStyle(color: backgroundColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}


Widget getReservationCardActivityAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.free.toString(), activityForm.activityFormId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
        return state.maybeMap(
        loadAllAttendanceSuccess: (item) {
            return Row(
              children: [
                Icon(Icons.person_sharp, color: model.paletteColor, size: 14),
                const SizedBox(width: 4),
                Text(item.item.length.toString(), style: TextStyle(color: model.paletteColor)),
                const SizedBox(width: 10),
              ],
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}


  Widget getReservationCardActivityTicketAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.tickets.toString(), activityForm.activityFormId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadAllAttendanceSuccess: (item) {
              return Row(
                children: [
                  Icon(Icons.airplane_ticket_outlined, color: model.paletteColor, size: 14),
                  const SizedBox(width: 4),
                  Text(item.item.length.toString(), style: TextStyle(color: model.paletteColor)),
                  const SizedBox(width: 10),
                ],
              );
            },
            orElse: () => Container(),
          );
        },
      ),
    );
  }
