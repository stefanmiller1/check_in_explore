import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_details_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget noReservationsFound(DashboardModel model, IconData icon, String mainTitle, String subTitle, String buttonTitle,  {required Function() didTapStartButton}) {
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




Widget getReservationCard(BuildContext context, bool isMessenger, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, bool endedReservation, bool isSelected, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity) didSelectReservation}) {

  return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservationItem.instanceId.getOrCrash())),
    child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadListingManagerItemFailure: (_) => LoadingReservationCard(context),
          loadListingManagerItemSuccess: (item) {
            return getReservationCardActivity(context, isMessenger, item.failure, reservationItem, currentUser, model, endedReservation, isSelected, didSelectReservation: (listing, reservation, activity) => didSelectReservation(listing, reservation, activity));
          },
          orElse: () => LoadingReservationCard(context),
        );
      },
    ),
  );
}


Widget getReservationCardActivity(BuildContext context, bool isMessenger, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, bool isEnded, bool isSelected, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity) didSelectReservation}) {
  return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservationItem.reservationId.getOrCrash())),
    child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadActivityManagerFormSuccess: (item) {
              if (isMessenger) {
                return getMessengerReservationHeader(context, listing, item.item, reservationItem, currentUser, model, didSelectReservation: (listing, reservation, activity) => didSelectReservation(listing, reservation, activity));
              }
              return getReservationCardItem(context, listing, item.item, reservationItem, model, isEnded, isSelected, didSelectReservation: (listing, reservation, activity) => didSelectReservation(listing, reservation, activity));
            },
            orElse: () {
              if (isMessenger) {
                return getMessengerReservationHeader(context, listing, ActivityManagerForm.empty(), reservationItem, currentUser, model, didSelectReservation: (listing, reservation, activity) => didSelectReservation(listing, reservation, activity));
              }
              return getReservationCardItem(context, listing, ActivityManagerForm.empty(), reservationItem, model, isEnded, isSelected, didSelectReservation: (listing, reservation, activity) => didSelectReservation(listing, reservation, activity));
            }
        );
      },
    ),
  );
}



Widget getMessengerReservationHeader(BuildContext context, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity) didSelectReservation}) {
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
                          didSelectReservation(listing, reservationItem, activity);
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
                              profiles: [],
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



Widget getReservationCardItem(BuildContext context, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, DashboardModel model, bool isEnded, bool isSelected, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity) didSelectReservation}) {

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));


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
      didSelectReservation(listing, reservationItem, activity);
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
                if (activity.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) Container(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                        activity.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
                        errorBuilder: (context, err, stack) {
                          return getActivityTypeTabOption(
                              context,
                              model,
                              100,
                              false,
                              getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                          );
                        },
                        fit: BoxFit.cover
                    ),
                  ),
                ) else if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) Container(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                        image: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhere((element) => element.spacePhoto != null).spacePhoto!.image,
                        errorBuilder: (context, err, stack) {
                          return getActivityTypeTabOption(
                              context,
                              model,
                              100,
                              false,
                              getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                          );
                        },
                        fit: BoxFit.cover
                    ),
                  ),
                ) else getActivityTypeTabOption(
                    context, model,
                    100,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.profileService.activityBackground.activityTitle.value.fold((l) => listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), (r) => r), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person_sharp, color: model.paletteColor, size: 14),
                            const SizedBox(width: 4),
                            Text((reservationItem.reservationAffiliates?.where((element) => element.contactStatus == ContactStatus.joined).length ?? 0 + 1).toString(), style: TextStyle(color: model.paletteColor)),
                            const SizedBox(width: 10),
                            Icon(Icons.favorite, color: model.paletteColor, size: 14),
                            const SizedBox(width: 4),
                            Text('1', style: TextStyle(color: model.paletteColor))
                          ],
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
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: model.paletteColor.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), maxLines: 1,) : (getNumberOfSlotsToGo(reservationItem) == 0) ? Text('Finished', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), maxLines: 1,) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), maxLines: 1),
                  )
                )
              ],
            ),
          )
      ),
    ),
  );
}