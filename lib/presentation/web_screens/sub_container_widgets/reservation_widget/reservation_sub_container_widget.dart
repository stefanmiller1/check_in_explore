import 'package:beamer/beamer.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/reservations_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/cupertino.dart';

class ReservationSubContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final UniqueId? initialReservationId;
  final Function() didSelectReservation;

  const ReservationSubContainerWidget({super.key,
    required this.model,
    required this.didSelectReservation,
    this.initialReservationId
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Expanded(
          child: ReservationScreen(
            initialReservationId: (ReservationHelperCore.selectedReservationItem == null) ? (ReservationHelperCore.selectedReservationItem?.reservationId != initialReservationId) ? initialReservationId : initialReservationId : null,
            model: model,
            didSelectReservation: (listing, reservation, profile, activity, attendeeItem, activityTickets) {

                ReservationHelperCore.isLoading = true;
                ReservationHelperCore.currentListingManagerForm = listing;
                ReservationHelperCore.currentUserProfile = profile;
                ReservationHelperCore.selectedReservationItem = reservation;
                ReservationHelperCore.currentActivityForm = activity;
                ReservationHelperCore.selectedReservationAttendeeItem = attendeeItem;
                ReservationHelperCore.currentAttendeeTicketItems = activityTickets;
                ReservationCoreHelper.pageController = null;

                didSelectReservation();
                Beamer.of(context).update(
                    configuration: RouteInformation(
                        location: '/${DashboardMarker.reservations.toString()}/reservation/${ReservationHelperCore.selectedReservationItem?.reservationId.getOrCrash().toString()}'
                    ),

                    rebuild: false
                );

                Future.delayed(const Duration(seconds: 1), () {
                  ReservationHelperCore.isLoading = false;
                  int tabIndex = ResOverViewTabs.values.indexWhere((element) => element == ReservationCoreHelper.resOverViewTabs);
                  ReservationCoreHelper.pageController = PageController(initialPage: tabIndex);


                  didSelectReservation();
                });
            },
          ),
        ),
      ],
    );
  }

}