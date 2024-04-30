import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityAttendeeTicketsResultMain extends StatelessWidget {

  final DashboardModel model;
  final List<TicketItem> tickets;
  final ReservationItem reservationItem;
  final UserProfileModel currentUser;
  final ActivityManagerForm activityManagerForm;

  const ActivityAttendeeTicketsResultMain(
      {super.key, required this.model, required this.reservationItem, required this.currentUser, required this.activityManagerForm, required this.tickets});

  void _handleShowSelectedTicket(BuildContext context, TicketItem ticket) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Ticket',
      // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        width: 300,
                        height: 420,
                        child: AttendeeTicketWidget(
                            reservationItem: reservationItem,
                            currentUser: currentUser,
                            activityManagerForm: activityManagerForm,
                            ticket: ticket,
                            model: model
                )
              )
            )
          )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: (!(kIsWeb)) ? AppBar(
          elevation: 0,
          backgroundColor: model.paletteColor,
          title: Text('Tickets', style: TextStyle(color: model.accentColor)),
          centerTitle: true,
        ) : null,
        body: getMainContainer(context),
      ),
    );
  }

  Widget getMainContainer(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Row(
          children: [
            const SizedBox(height: 10),

            /// info about the ticket
            Flexible(
            child: Center(
            child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                              Text('Ticket Details', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Paid: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                  Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(tickets)), activityManagerForm.rulesService.currency), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Purchased: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                  Text(tickets.length.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                                ],
                              ),
                              const SizedBox(height: 25),
                              Divider(thickness: 1, color: model.disabledTextColor),
                              const SizedBox(height: 25),
                              Text('Purchased', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              ...tickets.map((e) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: getAttendeeTicketItemWidget(context, model, reservationItem, activityManagerForm, e, didSelectTicket: (TicketItem ticket) {  }),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /// receipt
                                              InkWell(
                                                onTap: () {

                                                  if (kIsWeb) {
                                                    _handleShowSelectedTicket(context, e);
                                                  } else {
                                                    /// push new page
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                                      return AttendeeTicketWidget(
                                                          reservationItem: reservationItem,
                                                          currentUser: currentUser,
                                                          activityManagerForm: activityManagerForm,
                                                          ticket: e,
                                                          model: model
                                                      );
                                                    }));
                                                  }

                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(25),
                                                      color: model.paletteColor,
                                                    ),
                                                    height: 40,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                                      child: Center(
                                                          child: Text('Show Ticket', style: TextStyle(color: model.accentColor)),
                                                    ),
                                                  )
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              (e.redeemed == true) ? Text('Redeemed', style: TextStyle(color: model.disabledTextColor)) : Text('Not Redeemed', style: TextStyle(color: model.disabledTextColor)),

                                            ],
                                          ),

                                        ],
                                      ),
                                  const SizedBox(height: 4),
                                  Text('Paid: ${completeTotalPriceWithCurrency(e.selectedTicketFee.toDouble(), activityManagerForm.rulesService.currency)}', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                                  Text('Ticket ID: ${e.ticketId.getOrCrash()}', style: TextStyle(color: model.disabledTextColor)),
                                  Text('Purchase Date: ${DateFormat.yMMMMd().format(e.createdAt)}', style: TextStyle(color: model.disabledTextColor)),
                                  const SizedBox(height: 15),
                                  Divider(thickness: 1, color: model.disabledTextColor.withOpacity(0.23)),
                                  const SizedBox(height: 15),
                                ],
                              )
                            ).toList()

                    ]
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}