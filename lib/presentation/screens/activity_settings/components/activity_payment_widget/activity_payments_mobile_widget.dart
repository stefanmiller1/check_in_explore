import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_settings_mobile_container.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dart;

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PaymentMobileEditor extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final UserProfileModel activityOwner;
  final ReservationItem reservation;
  final Function() didSave;

  const PaymentMobileEditor({super.key, required this.model, required this.activityManagerForm, required this.reservation, required this.didSave, required this.activityOwner});

  @override
  State<PaymentMobileEditor> createState() => _PaymentMobileEditorState();
}

class _PaymentMobileEditorState extends State<PaymentMobileEditor> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
        child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
            listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.isSaving != c.isSaving || p.activitySettingsForm != c.activitySettingsForm,
            listener: (context, state) {

              /// handle saving errors & success options
              state.authFailureOrSuccessOptionSaving.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              activityServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              unexpected: (e) => Text('Uh Oh. Something un-expected happened', style: TextStyle(color: widget.model.disabledTextColor)),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {

                    Navigator.of(context).pop();
                    widget.didSave();
                  }
                  )
              );
            },
            buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages || p.isSaving != c.isSaving || p.isEditingForm != c.isEditingForm || p.activitySettingsForm != c.activitySettingsForm,
            builder: (context, state) {

              return Scaffold(
                  appBar: scaffoldHeaderWidget(
                      context,
                      widget.model,
                      state,
                      didPressPreview: () {

                      }
                  ),
                  body: Stack(
                    children: [
                      PaymentsSettingWidget(
                      userProfile: widget.activityOwner,
                      model: widget.model,
                      paymentRequirementTitle: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased == true) ? 'Tickets' : 'Passes',
                      currentCurrency: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.currency,
                      showCurrency: true,
                      didSelectPaymentButton: () {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.createStripeOnBoardingAccountLink(widget.activityOwner));
                        },
                        didSelectPresentStripeAccountDashboard: () {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.presentStripeAccountDashboard(widget.activityOwner));
                        },
                        didSelectCurrencyOption: (currency) {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.currencyTypeChanged(currency.toString()));
                        }
                      ),
                      isSavingWidget(context, widget.model, state)
                    ],
                  )
              );
            }
        )
    );
  }
}

