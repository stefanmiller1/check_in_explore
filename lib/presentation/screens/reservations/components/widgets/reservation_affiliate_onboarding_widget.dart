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

  late bool isOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 0, milliseconds: 150), () {
       setState(() {
         isOpen = true;
       });
    });
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
    return Stack(
      alignment: Alignment.center,
      children: [
          AnimatedOpacity(
              opacity: isOpen ? 1 : 0,
              duration: Duration(seconds: 1, milliseconds: 400),
              child: Container(
                color: Colors.black.withOpacity(0.25),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
            ),
          ),
          AnimatedContainer(
              width: isOpen ? 600 : 0,
              height: isOpen ? MediaQuery.of(context).size.height : 0,
              constraints: BoxConstraints(maxWidth: 600),
              duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: widget.model.webBackgroundColor,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
            opacity: isOpen ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              // height: 750,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: attendeeTypeMainContainer(widget.attendeeItem.attendeeType)
              ),
            ),
          ),
        ),
      ],
    );
  }
}