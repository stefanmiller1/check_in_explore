import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/misc/watcher_services/stripe_watcher_services/stripe_payment_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_widget/new_payment_method_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class PayoutHistoryWidget extends StatelessWidget {

  final UserProfileModel profile;
  final DashboardModel model;

  const PayoutHistoryWidget({super.key, required this.profile, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<StripePaymentWatcherBloc>()..add(const StripePaymentWatcherEvent.watchAllPayoutHistory()),
      child: BlocBuilder<StripePaymentWatcherBloc, StripePaymentWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    titleTextStyle: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                    elevation: 0,
                    title: Text('Payment Methods'),
                    iconTheme: IconThemeData(
                        color: model.paletteColor
                    ),
                  ),
                  body: Center(child: JumpingDots(numberOfDots: 3, color: model.paletteColor))),
              loadAllPayoutsFailure: (_) => updatePayoutItems(context, []),
              loadAllPayoutsSuccess: (items) => updatePayoutItems(context, items.payoutModel),
              orElse: () => updatePayoutItems(context, []));
        },
      ),
    );
  }


  Widget updatePayoutItems(BuildContext context, List<PayoutModel> payouts) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 35),
            Text('Payout History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: model.disabledTextColor,
              ),
              textAlign: TextAlign.left,
            ),
            if (payouts.isNotEmpty) Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ]
            ),

            if (payouts.isEmpty) Column(
              children: [

              ],
            )

          ],
        ),
      ),
    );
  }


}