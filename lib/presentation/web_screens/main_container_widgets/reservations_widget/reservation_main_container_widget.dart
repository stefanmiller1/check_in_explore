import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:flutter/material.dart';

class ReservationMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final UniqueId? initialReservationId;
  final UserProfileModel? currentUserProfile;

  const ReservationMainContainerWidget({super.key, required this.model, this.initialReservationId, this.currentUserProfile});

  @override
  Widget build(BuildContext context) {


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
              currentUser: currentUserProfile,
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
              currentUser: currentUserProfile,
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