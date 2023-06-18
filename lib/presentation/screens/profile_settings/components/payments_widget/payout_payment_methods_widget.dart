import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/misc/watcher_services/stripe_watcher_services/stripe_payment_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_widget/new_payment_method_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:dartz/dartz.dart' as bloc;


class PayoutPaymentMethod extends StatelessWidget {

  final UserProfileModel profile;
  final DashboardModel model;

  const PayoutPaymentMethod({super.key, required this.profile, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<PaymentServicesBloc>()..add(PaymentServicesEvent.initializePaymentService(bloc.optionOf(profile))),
      child: BlocConsumer<PaymentServicesBloc, PaymentServicesState>(
        listenWhen: (p,c) => p.isSaving != c.isSaving,
        listener: (context, state) {
          state.defaultPaymentFailureOrSuccessOption.fold(
                  () => {},
                  (either) => either.fold(
                      (failure) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: model.webBackgroundColor,
                        content: failure.maybeMap(
                          serverError: (value) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor)),
                          orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor)),
                        )
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                      (_) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
              )
          );
          state.failureOrSuccessOption.fold(
                  () => {},
                  (either) => either.fold(
                      (failure) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: model.webBackgroundColor,
                        content: failure.maybeMap(
                          paymentServerError: (value) => Text(value.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor)),
                          orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor)),
                        )
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                      (_) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }
              )
          );
        },
        buildWhen: (p,c) => p.isSaving != c.isSaving || p.isEditing != c.isEditing || p.cancellationList != c.cancellationList,
        builder: (context, state) {
          return updatePayoutMethodWidget(context, state);
        },
      ),
    );
  }

  Widget updatePayoutMethodWidget(BuildContext context, PaymentServicesState state) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: !state.isSaving,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
          elevation: 0,
          title: Text('Payout Methods'),
          iconTheme: IconThemeData(
          color: model.paletteColor
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Text('How to Receive Payments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: model.disabledTextColor,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text('Setup your account to receive payments, this way we will know where to send you your money.',
                style: TextStyle(
                  color: model.paletteColor,
                ),
                textAlign: TextAlign.left,
            ),
              const SizedBox(height: 35),
              if (state.isSaving) JumpingDots(numberOfDots: 3, color: model.paletteColor),
              if (!state.isSaving && (profile.stripeAccountDetailsSubmitted ?? false)) InkWell(
                onTap: () {
                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.presentStripePayoutAccount(profile));
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: model.paletteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(child:
                  Text('My Payout Account', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold))),
                ),
              ),

              if (!state.isSaving && !(profile.stripeAccountDetailsSubmitted ?? false)) InkWell(
                onTap: () {
                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewStripePayoutMethod(profile));
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: model.paletteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(child:
                  Text((profile.stripeAccountId != null) ? 'Finish Setting Up Payouts' : 'Setup Payouts', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold))),
                ),
              ),
          ],
        ),
      ),
    );
  }



}