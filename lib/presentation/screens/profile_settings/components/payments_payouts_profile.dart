import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_widget/payment_history_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_widget/payment_methods_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_widget/payout_history_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_widget/payout_payment_methods_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/profile_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen_helper.dart';
import 'package:flutter/material.dart';

class PaymentsPayoutsProfile extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel profile;

  const PaymentsPayoutsProfile({super.key, required this.model, required this.profile});

  @override
  State<PaymentsPayoutsProfile> createState() => _PaymentsPayoutsProfileState();
}

class _PaymentsPayoutsProfileState extends State<PaymentsPayoutsProfile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Edit Profile'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Text('Reservations', style: TextStyle(color: widget.model.paletteColor,
                  fontSize: widget.model.secondaryQuestionTitleFontSize,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ...paymentSettingsList().map(
                  (e) => profilePaymentSettingItemWidget(
                    widget.model,
                    e,
                    didSelectItem: (f) {
                      switch (f) {
                        case ProfilePaymentMarker.paymentMethods:
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return PaymentMethodsWidget(
                                  profile: widget.profile,
                                  model: widget.model
                              );
                            })
                          );
                          break;
                        case ProfilePaymentMarker.pastPayments:
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                            return PaymentHistoryWidget(
                              model: widget.model,
                              profile: widget.profile,
                            );
                          }));
                          break;
                        default:
                    }
                  }
                )
              ),


              const SizedBox(height: 35),
              Text('Hosting', style: TextStyle(color: widget.model.paletteColor,
                  fontSize: widget.model.secondaryQuestionTitleFontSize,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ...payoutSettingsList().map(
                      (e) => profilePaymentSettingItemWidget(
                      widget.model,
                      e,
                      didSelectItem: (f) {
                        switch (f) {
                          case ProfilePaymentMarker.payouts:
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return PayoutPaymentMethod(
                                  model: widget.model,
                                  profile: widget.profile,
                                );
                              })
                            );
                            break;
                          case ProfilePaymentMarker.taxes:
                          // TODO: Handle this case.
                            break;
                          case ProfilePaymentMarker.transactionHistory:
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return PayoutHistoryWidget(
                                model: widget.model,
                                profile: widget.profile,
                              );
                            }));
                            break;
                          default:
                        }
                      }
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}