import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/src/provider.dart';

import '../../web_screens/focused_main_container_widgets/activity_ticket_settings_widget/activity_ticket_helper.dart';
import 'activity_ticket_results_helper.dart';

class ActivityTicketsResultMain extends StatelessWidget {

  final DashboardModel model;
  final ActivityTicketOption selectedTicket;
  final ReservationItem reservationItem;
  final UserProfileModel currentUser;
  final ActivityManagerForm activityManagerForm;

  const ActivityTicketsResultMain({super.key, required this.model, required this.reservationItem, required this.currentUser, required this.activityManagerForm, required this.selectedTicket});

  @override
  Widget build(BuildContext context) {

    if (ActivityTicketHelperCore.isLoading == true) {
      return JumpingDots(color: model.paletteColor, numberOfDots: 3);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: model.webBackgroundColor
        ),
        child: getPurchasedTicketInfoForSelectedTicket()
      ),
    );
  }

  Widget getPurchasedTicketInfoForSelectedTicket() {
    return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchPurchasedTicketsStarted(reservationItem.reservationId.getOrCrash(), selectedTicket.ticketId.getOrCrash())),
      child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
            loadOnHoldTicketsFailure: (_) => activityTicketsLoadingFailure(),
            loadPurchasedTicketSuccess: (item) => getOnHoldTicketInfoForSelectedTicket(item.tickets),
            orElse: () => getOnHoldTicketInfoForSelectedTicket([])
          );
        }
      )
    );
  }

  Widget getOnHoldTicketInfoForSelectedTicket(List<TicketItem> purchasedTickets) {
      return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchTicketsOnHoldStarted(reservationItem.reservationId.getOrCrash(), selectedTicket.ticketId.getOrCrash())),
          child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
              builder: (context, state) {
                return state.maybeMap(
                    loadOnHoldTicketsFailure: (_) => activityTicketsLoadingFailure(),
                    loadOnHoldTicketsSuccess: (item) {
                      return getMainContainer(context, purchasedTickets, item.tickets);
                    },
                    orElse: () => getMainContainer(context, purchasedTickets, [])
          );
        }
      )
    );
  }


  Widget getMainContainer(BuildContext context, List<TicketItem> purchasedTickets, List<TicketItem> onHoldTickets) {
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
                      Visibility(
                        visible: activityManagerForm.activityAttendance.isTicketFixed == true,
                        child: Column(
                          children: [
                            getTicketWithCounterForEntireActivity(
                                context,
                                model,
                                reservationItem,
                                activityManagerForm,
                                activityManagerForm.activityAttendance.defaultActivityTickets ?? ActivityTicketOption.empty(),
                                [],
                                false,
                                didDecreaseAmount: (ticket) {
                                },
                                didIncreaseAmount: (ticket) {
                                }
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Earnings: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(purchasedTickets)), activityManagerForm.rulesService.currency), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tickets Sold: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                Text('${purchasedTickets.length}/${activityManagerForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 0}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize),)
                              ],
                            )
                          ],
                        )
                      ),
                      Visibility(
                          visible: activityManagerForm.activityAttendance.isTicketPerSlotBased == false && activityManagerForm.activityAttendance.isTicketFixed == false,
                          child: Column(
                            children: [
                              getTicketWithCounterForDayBasedActivity(
                                  context,
                                  model,
                                  reservationItem,
                                  activityManagerForm,
                                  selectedTicket,
                                  purchasedTickets,
                                  false,
                                  didDecreaseAmount: (ticket) {
                                  },
                                  didIncreaseAmount: (ticket) {
                                  }
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Earnings: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                  Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(purchasedTickets)), activityManagerForm.rulesService.currency), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tickets Sold: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                  Text('${purchasedTickets.length}/${activityManagerForm.activityAttendance.activityTickets?.firstWhere((element) => element.ticketId == selectedTicket.ticketId, orElse: () => ActivityTicketOption.empty()).ticketQuantity}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize),)
                              ],
                            ),
                          ],
                        )
                      ),
                      Visibility(
                          visible: activityManagerForm.activityAttendance.isTicketPerSlotBased == true && activityManagerForm.activityAttendance.isTicketFixed == false,
                          child: Column(
                            children: [
                              getTicketWithCounterForSlotBasedActivity(
                                  context,
                                  model,
                                  reservationItem,
                                  activityManagerForm,
                                  selectedTicket,
                                  [],
                                  false,
                                  didDecreaseAmount: (ticket) {
                                  },
                                  didIncreaseAmount: (ticket) {
                                  }
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Earnings: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                  Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(purchasedTickets)), activityManagerForm.rulesService.currency), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tickets Sold: ', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                                  Text('${purchasedTickets.length}/${activityManagerForm.activityAttendance.activityTickets?.firstWhere((element) => element.ticketId == selectedTicket.ticketId, orElse: () => ActivityTicketOption.empty()).ticketQuantity}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize),)
                                ],
                              ),
                          ],
                        )
                      ),

                      Visibility(
                        visible: onHoldTickets.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            Text('On Hold', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            ...onHoldTickets.map((e) => ticketItemWidget(model, e, didSelectTicketRefund: (ticket) {}, didSelectRedeem: (ticket) {})).toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                      Divider(thickness: 1, color: model.disabledTextColor),
                      const SizedBox(height: 25),

                      Text('Purchased', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                      // tickets sold/limits
                      const SizedBox(height: 10),
                      ...purchasedTickets.map((e) => ticketItemWidget(model, e, didSelectTicketRefund: (ticket) {}, didSelectRedeem: (ticket) {})
                      ).toList(),
                      
                      
                    ]
                  ),
                )
              ),
            ),

          ],
        ),
      ),
    );
  }


}