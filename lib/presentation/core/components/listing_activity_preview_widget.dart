import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget getListingActivityPreviewWidget(BuildContext context, DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem) {
  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));

  return GestureDetector(
     onTap: () {
       Navigator.push(context, HeroDialogRoute(
           barrierLabelString: '',
           builder: (contexts) {
             return ActivityPreviewScreen(
               listing: listing,
               model: model,
               reservation: reservationItem
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
            BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityCreatorFormStarted(reservationItem.reservationId.getOrCrash())),
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
                      loadActivityCreatorFormFailure: (_) => getIconForActivityType(context, model, 25, reservationItem),
                      loadActivityCreatorFormSuccess: (item) => (item.item.activityBackground.activityProfileImages != null && (item.item.activityBackground.activityProfileImages?.isNotEmpty ?? false)) ? CircleAvatar(
                        backgroundColor: model.accentColor,
                        backgroundImage: Image.network(item.item.activityBackground.activityProfileImages!.first, fit: BoxFit.cover).image,
                      ) : getIconForActivityType(context, model, 25, reservationItem),
                      orElse: () => getIconForActivityType(context, model, 25, reservationItem)
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

Widget getIconForActivityType(BuildContext context, DashboardModel model, double radius, ReservationItem reservation) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: model.accentColor,
    child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SvgPicture.asset(getActivityOptions(context).firstWhere((element) => element.activityId == reservation.reservationSlotItem.first.selectedActivityType).iconPath ?? '')),
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