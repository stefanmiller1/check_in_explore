import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/reservations_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/cupertino.dart';

class ReservationSubContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final Function() didSelectReservation;

  const ReservationSubContainerWidget({super.key,
    required this.model,
    required this.didSelectReservation
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Expanded(
          child: ReservationScreen(
            model: model,
            didSelectReservation: (listing, reservation, profile, activity) {
                ReservationHelperCore.isLoading = true;
                ReservationHelperCore.currentListingManagerForm = listing;
                ReservationHelperCore.currentUserProfile = profile;
                ReservationHelperCore.selectedReservationItem = reservation;
                ReservationHelperCore.currentActivityForm = activity;
                didSelectReservation();

                Future.delayed(const Duration(seconds: 2), () {
                  ReservationHelperCore.isLoading = false;
                  didSelectReservation();
                });
            },
          ),
        ),
      ],
    );
  }

}