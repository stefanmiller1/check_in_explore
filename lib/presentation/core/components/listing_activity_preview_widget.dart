import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget getListingActivityPreviewWidget(BuildContext context, DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem) {
  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));

  return GestureDetector(
     onTap: () {

       Navigator.push(context, MaterialPageRoute(
           builder: (_) {
             return ActivityPreviewScreen(
               model: model,
               currentListingId: listing.listingServiceId,
               currentReservationId: reservationItem.reservationId,
               listing: listing,
               reservation: reservationItem,
               didSelectBack: () {  },
             );
           }
       ));
       // ActivityPreviewScreen
     },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: getColorFromActivityStatus(reservationItem.reservationState, model),
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: model.mobileBackgroundColor,
                borderRadius: BorderRadius.circular(30)
              ),
            ),
            BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservationItem.reservationId.getOrCrash())),
              child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
                builder: (context, state) {
                  return state.maybeMap(
                      loadInProgress: (_) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      loadActivityManagerFormFailure: (_) => getActivityFromReservationId(context, model, 25, reservationItem),
                      loadActivityManagerFormSuccess: (item) => (item.item.profileService.activityBackground.activityProfileImages != null && (item.item.profileService.activityBackground.activityProfileImages?.isNotEmpty ?? false)) ? CircleAvatar(
                        backgroundColor: model.accentColor,
                        backgroundImage: Image.network(item.item.profileService.activityBackground.activityProfileImages!.first.uriPath ?? '', fit: BoxFit.cover).image,
                      ) : getActivityFromReservationId(context, model, 25, reservationItem),
                      orElse: () => getActivityFromReservationId(context, model, 25, reservationItem)
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Container(
            width: 50,
            child: Text(DateFormat.MMMd().format(resSorted.first.selectedDate), maxLines: 1, overflow: TextOverflow.ellipsis)
        )
      ],
    ),
  );
}


Color getColorFromActivityStatus(ReservationSlotState state, DashboardModel model) {
  switch (state) {
    case ReservationSlotState.confirmed:
      return Colors.greenAccent;
    case ReservationSlotState.current:
      return Colors.deepOrangeAccent;
    case ReservationSlotState.completed:
      return model.accentColor;
    default:
      return model.accentColor;
  }
}