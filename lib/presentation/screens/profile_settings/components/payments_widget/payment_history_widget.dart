import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/misc/watcher_services/stripe_watcher_services/stripe_payment_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/webview_controller_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'helpers.dart';

class PaymentHistoryWidget extends StatefulWidget {

  final UserProfileModel profile;
  final DashboardModel model;

  const PaymentHistoryWidget({
    super.key,
    required this.profile,
    required this.model,
  });

  @override
  State<PaymentHistoryWidget> createState() => _PaymentHistoryWidgetState();
}

class _PaymentHistoryWidgetState extends State<PaymentHistoryWidget> {

  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Payment History'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations(widget.profile, false)),
          child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  resLoadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                  loadCurrentUserReservationsSuccess: (e) => getAllPayments(context, e.item),
                  loadCurrentUserReservationsFailure: (_) => getAllPayments(context, []),
                  ///TODO: add failure of type empty
                  /// if network call cant be made you should not be allowed to make any new reservation
                  orElse: () => getAllPayments(context, [])
              );
            },
          )
      )
    );
  }


  Widget getAllPayments(BuildContext context, List<ReservationItem> reservation) {
    return BlocProvider(create: (_) => getIt<StripePaymentWatcherBloc>()..add(StripePaymentWatcherEvent.watchAllPaymentIntentHistory(widget.profile.stripeCustomerId ?? '')),
      child: BlocBuilder<StripePaymentWatcherBloc, StripePaymentWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
              loadAllPaymentIntentsFailure: (_) => noReservationsFound(
                  widget.model,
                  Icons.calendar_today_outlined,
                  'No Reservations Yet!',
                  'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                  'Start Booking',
                  didTapStartButton: () {
                  }
                ),
              loadAllPaymentIntentsSuccess: (items) => getAllListings(context, reservation, items.paymentIntent),
              orElse: () => noReservationsFound(
                  widget.model,
                  Icons.calendar_today_outlined,
                  'No Reservations Yet!',
                  'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                  'Start Booking',
                  didTapStartButton: () {
                  }
                )
          );
        },
      ),
    );
  }

  Widget getAllListings(BuildContext context, List<ReservationItem> reservation, List<PaymentIntent> paymentIntent) {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsStarted(reservation.map((e) => e.instanceId.getOrCrash()).toSet().toList())),
      child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadAllPublicListingItemsSuccess: (item) => retrievePaymentHistory(context, paymentIntent, reservation, item.items),
              loadAllPublicListingItemsFailure: (_) => retrievePaymentHistory(context, paymentIntent, reservation, []),
              orElse: () => retrievePaymentHistory(context, paymentIntent, reservation, [])
          );
        },
      )
    );
  }

  Widget retrievePaymentHistory(BuildContext context, List<PaymentIntent> paymentHistory, List<ReservationItem> reservations, List<ListingManagerForm> listing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
          children: [
            const SizedBox(height: 35),
            if (paymentHistory.isNotEmpty) Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: widget.model.disabledTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                ...paymentHistory.map(
                        (p) {
                        if (reservations.isNotEmpty && reservations.map((e) => e.reservationId.getOrCrash()).contains(p.reservationId)) {
                          if (listing.isNotEmpty && listing.map((e) => e.listingServiceId.getOrCrash()).contains(p.listingId)) {
                            return getPaymentHistoryItemWidget(
                              context,
                              widget.model,
                              p,
                              listing.firstWhere((element) => element.listingServiceId.getOrCrash() == p.listingId),
                              reservations.firstWhere((element) => element.reservationId.getOrCrash() == p.reservationId),
                              didSelectPayment: (payment) {

                                if (payment.receipt_url != null) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) {
                                        return WebViewWidgetComponent(
                                          urlString: payment.receipt_url!,
                                          model: widget.model,
                                      );
                                    })
                                  );
                                }
                              }
                            );
                          }
                        } else {
                          return getPaymentHistoryOnly(
                              context,
                              widget.model,
                              p,
                              didSelectPayment: (payment) {

                            }
                          );
                        }
                      return getPaymentHistoryOnly(
                          context,
                          widget.model,
                          p,
                          didSelectPayment: (payment) {

                      }
                    );
                  }
                ),
              ],
            )
          ],
      ),
        ),
    );
  }
}