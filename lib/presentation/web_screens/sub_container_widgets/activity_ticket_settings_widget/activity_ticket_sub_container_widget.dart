import 'dart:ui';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/focused_main_container_widgets/activity_ticket_settings_widget/activity_ticket_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityTicketSubContainer extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem? currentReservationItem;
  final ActivityManagerForm? currentActivityManagerForm;
  final Function(ActivityTicketOption ticketOption) didSelectTicketItem;

  const ActivityTicketSubContainer({super.key, required this.model, required this.currentReservationItem, required this.currentActivityManagerForm, required this.didSelectTicketItem});

  @override
  State<ActivityTicketSubContainer> createState() => _ActivityTicketSubContainerState();
}

class _ActivityTicketSubContainerState extends State<ActivityTicketSubContainer> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: (!(kIsWeb)) ? AppBar(
        backgroundColor: widget.model.paletteColor,
        title: const Text('Manage Tickets'),
        centerTitle: true,
      ) : null,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  getActivityTicketOptionsColumn(
                      context,
                      widget.model,
                      widget.currentReservationItem ?? ReservationItem.empty(),
                      widget.currentActivityManagerForm ?? ActivityManagerForm.empty(),
                      false,
                      ActivityTicketHelperCore.selectedTicket,
                      didSelectTicketOption: (ticket) {
                        widget.didSelectTicketItem(ticket);
                    }
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),

          Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: widget.model.accentColor.withOpacity(0.35)
                      ),
                  child: getAllPurchasedTicketsFooterWidget(context))
                ),
              ),
            )
          ),
        ],
      ),
    );
  }


  Widget getAllPurchasedTicketsFooterWidget(BuildContext context) {
    if (widget.currentReservationItem == null && widget.currentActivityManagerForm == null) {
      return getLoadingForOverviewFooter(context);
    }
    return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchAllPurchasedTicketsStarted(widget.currentReservationItem!.reservationId.getOrCrash())),
        child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadInProgress: (_) => getLoadingForOverviewFooter(context),
                  loadAllPurchasedTicketsFailure: (_) => getNoPurchasedTicketsFooter(),
                  /// earnings from all tickets
                  loadAllPurchasedTicketsSuccess: (item) => getPurchasedTicketsFooter(item.tickets),
                  /// no earnings yet.
                  orElse: () => getNoPurchasedTicketsFooter()
              );
            }
        )
    );
  }

  Widget getPurchasedTicketsFooter(List<TicketItem> tickets) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Total Earnings: ', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize), maxLines: 1)),
            /// earnings,
            Row(
              children: [
                Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(tickets)), widget.currentActivityManagerForm!.rulesService.currency),
                    style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                Icon(Icons.credit_card, color: widget.model.paletteColor)
              ],
            )
            /// number of tickets on sale
            /// link to stripe
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Tickets Sold:', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize), maxLines: 1,)),

            Row(
              children: [
                Text('x ${tickets.length} ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                Icon(Icons.airplane_ticket_outlined, color: widget.model.paletteColor)
              ],
            )

          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {

          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.model.paletteColor
              ),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Center(child: Text('Review Earnings', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {

          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.model.webBackgroundColor
              ),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Center(child: Text('Manage Tickets', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold))),
              )
          ),
        )
      ],
    );
  }


  Widget getNoPurchasedTicketsFooter() {
    return Align(
      alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.airplane_ticket_outlined, color: widget.model.disabledTextColor, size: 35),
            const SizedBox(height: 10),
            Text('Ticket Info will appear here', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {

              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: widget.model.webBackgroundColor
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(child: Text('Manage Tickets', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold))),
                )
              ),
            )
          ],
        ),
    );
  }


}