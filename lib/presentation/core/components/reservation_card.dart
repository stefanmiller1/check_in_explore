import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget noReservationsFound(DashboardModel model, {required Function() didTapStartButton}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: model.accentColor
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Icon(Icons.calendar_today_outlined, color: model.paletteColor),
          const SizedBox(height: 18),
          Text('No Reservations Yet!', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Start a Pop-Up Shop in your backyard or make Rent out a basement for your next undeground Rave.', style: TextStyle(color: model.disabledTextColor)),
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
                  child: Text('Start Booking', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold)),
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



Widget getReservationCard(BuildContext context, ReservationItem reservationItem, DashboardModel model, bool endedReservation, {required Function(ListingManagerForm listing, ReservationItem reservation) didSelectReservation}) {

  return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservationItem.instanceId.getOrCrash())),
    child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadListingManagerItemFailure: (_) => LoadingReservationCard(context),
          loadListingManagerItemSuccess: (item) {
            return getReservationCardItem(context, item.failure, reservationItem, model, endedReservation, didSelectReservation: (listing, reservation) => didSelectReservation(listing, reservation));
          },
          orElse: () => LoadingReservationCard(context),
        );
      },
    ),
  );
}


Widget getReservationCardItem(BuildContext context, ListingManagerForm listing, ReservationItem reservationItem, DashboardModel model, bool isEnded, {required Function(ListingManagerForm listing, ReservationItem reservation) didSelectReservation}) {

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));


  return InkWell(
    onTap: () {
      didSelectReservation(listing, reservationItem);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(image: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhere((element) => element.spacePhoto != null).spacePhoto!.image, fit: BoxFit.cover),
                ),
              ),
              if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isEmpty) getActivityTypeTabOption(
                  context, model,
                  100,
                  false,
                  getActivityOptions(context).firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
              ),

              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_sharp, color: model.paletteColor, size: 14),
                        const SizedBox(width: 4),
                        Text('1', style: TextStyle(color: model.paletteColor)),
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
                        if (!isEnded) Text('Starting: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: model.disabledTextColor)),
                        if (resSorted.first.selectedDate != resSorted.last.selectedDate) Text('Ending: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor)),
                        if (isEnded) Text('Ended: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor))
                      ],
                    ),

                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: model.paletteColor.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold,)) : (getNumberOfSlotsToGo(reservationItem) == 0) ? Text('Finished', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold,)),
                  )
              )
            ],
          )
      ),
    ),
  );
}