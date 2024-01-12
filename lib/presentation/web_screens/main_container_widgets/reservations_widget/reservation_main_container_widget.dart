import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_results_main.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final UniqueId? initialReservationId;

  const ReservationMainContainerWidget({super.key, required this.model, this.initialReservationId});

  @override
  Widget build(BuildContext context) {

    /// in which case load from initialRes;
    final bool isFromInitialLoad = ReservationHelperCore.selectedReservationItem == null;
    /// in which case load from selectedReservation;
    final bool isFromSelectedReservation = ReservationHelperCore.selectedReservationItem != null;

    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: (ReservationHelperCore.selectedReservationItem != null) ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ReservationResultMain(
              model: model,
              isReply: false,
              listing: ReservationHelperCore.currentListingManagerForm,
              currentUser: ReservationHelperCore.currentUserProfile,
              currentUserId: ReservationHelperCore.currentUserProfile?.userId.getOrCrash(),
              reservationId: ReservationHelperCore.selectedReservationItem!.reservationId.getOrCrash(),
            ),
          ),
        ) : (initialReservationId != null) ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ReservationResultMain(
              model: model,
              isReply: false,
              listing: ReservationHelperCore.currentListingManagerForm,
              currentUser: ReservationHelperCore.currentUserProfile,
              currentUserId: ReservationHelperCore.currentUserProfile?.userId.getOrCrash(),
              reservationId: initialReservationId!.getOrCrash(),
            ),
          ),
        ) : Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.sticky_note_2_outlined, color: model.disabledTextColor, size: 85),
              const SizedBox(height: 10),
              Text('Your Reservations', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
              const SizedBox(height: 10),
              Text('Select any reservation from the list and get things started!', style: TextStyle(color: model.disabledTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}