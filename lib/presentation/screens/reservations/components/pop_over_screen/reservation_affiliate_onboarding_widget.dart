import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class ReservationAffiliateOnBoarding extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final AttendeeItem attendeeItem;
  final ReservationItem reservation;
  final UserProfileModel reservationOwner;

  const ReservationAffiliateOnBoarding({super.key, required this.attendeeItem, required this.activityManagerForm, required this.model, required this.reservation, required this.reservationOwner});

  @override
  State<ReservationAffiliateOnBoarding> createState() => _ReservationAffiliateOnBoardingState();
}

class _ReservationAffiliateOnBoardingState extends State<ReservationAffiliateOnBoarding> {

  @override
  void initState() {
    super.initState();
  }

  Widget attendeeTypeMainContainer(AttendeeType type) {
    switch (type) {
      case AttendeeType.free:
        return ReservationCreateNewAttendee(
            model: widget.model,
            reservation: widget.reservation,
            activityForm: widget.activityManagerForm,
            resOwner: widget.reservationOwner,
            isFromInvite: true,
          );
      case AttendeeType.instructor:
        return CreateNewInstructorForm(
          model: widget.model,
          reservation: widget.reservation,
          activityForm: widget.activityManagerForm,
          resOwner: widget.reservationOwner,
          isFromInvite: true,
        );
      case AttendeeType.vendor:
        return CreateNewVendorMerchant(
          model: widget.model,
          reservation: widget.reservation,
          activityForm: widget.activityManagerForm,
          resOwner: widget.reservationOwner,
          isFromInvite: true
        );
      case AttendeeType.partner:
        return ReservationRequestPartnershipAttendee(
          model: widget.model,
          reservation: widget.reservation,
          activityForm: widget.activityManagerForm,
          resOwner: widget.reservationOwner,
          isFromInvite: true,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return attendeeTypeMainContainer(widget.attendeeItem.attendeeType);
  }
}