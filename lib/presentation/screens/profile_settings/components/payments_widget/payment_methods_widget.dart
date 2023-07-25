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

class PaymentMethodsWidget extends StatefulWidget {

  final UserProfileModel profile;
  final DashboardModel model;

  const PaymentMethodsWidget({super.key, required this.profile, required this.model});

  @override
  State<PaymentMethodsWidget> createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {

  late bool isComplete = false;
  CardItem? _selectedCard;
  late bool isSavingAsDefault = false;
  late List<String> cancellations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<StripePaymentWatcherBloc>()..add(StripePaymentWatcherEvent.watchAllPaymentMethods(widget.profile.stripeCustomerId ?? '')),
        child: BlocBuilder<StripePaymentWatcherBloc, StripePaymentWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadInProgress: (_) => Scaffold(
                resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                    elevation: 0,
                    title: Text('Payment Methods'),
                    iconTheme: IconThemeData(
                        color: widget.model.paletteColor
                    ),
                  ),
                  body: Center(child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor))),
          loadAllPaymentMethodsFailure: (_) => updatePaymentMethodSettings(context, []),
          loadAllPaymentMethodsSuccess: (items) => updatePaymentMethodSettings(context, items.cards),
          orElse: () => updatePaymentMethodSettings(context, []));
        },
      ),
    );
  }

  Widget updatePaymentMethodSettings(BuildContext context, List<CardItem> cards) {
    return BlocProvider(create: (context) => getIt<PaymentServicesBloc>()..add(PaymentServicesEvent.initializePaymentService(bloc.optionOf(widget.profile))),
      child: BlocConsumer<PaymentServicesBloc, PaymentServicesState>(
        listenWhen: (p,c) => p.isSaving != c.isSaving,
        listener: (context, state) {
            state.defaultPaymentFailureOrSuccessOption.fold(
                    () => {},
                    (either) => either.fold(
                      (failure) {
                        final snackBar = SnackBar(
                                elevation: 4,
                                backgroundColor: widget.model.webBackgroundColor,
                                content: failure.maybeMap(
                                  serverError: (value) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                  orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                )
                            );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                      (_) {
                      final snackBar = SnackBar(
                          elevation: 4,
                          backgroundColor: widget.model.paletteColor,
                          content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                }
              )
            );
            state.failureOrSuccessOption.fold(
                    () => {},
                    (either) => either.fold(
                            (failure) {
                              final snackBar = SnackBar(
                                  elevation: 4,
                                  backgroundColor: widget.model.webBackgroundColor,
                                  content: failure.maybeMap(
                                      paymentServerError: (value) => Text(value.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                      orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                )
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            (_) {
                        final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              }
            )
          );
        },
        buildWhen: (p,c) => p.isSaving != c.isSaving || p.isEditing != c.isEditing || p.cancellationList != c.cancellationList,
        builder: (context, state) {
          return retrievePaymentMethods(context, cards, state);
        },
      ),
    );
  }

  Widget retrievePaymentMethods(BuildContext context, List<CardItem> cards, PaymentServicesState state) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: !state.isSaving,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Payment Methods'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCard = null;
                  });
                  context.read<PaymentServicesBloc>().add(PaymentServicesEvent.editBoolDidChange(!state.isEditing));

                },
                child: Text('Edit', style: TextStyle(color: (state.isEditing) ? widget.model.disabledTextColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, decoration: TextDecoration.underline)),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            if (cards.isNotEmpty) Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Methods',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: widget.model.disabledTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                ...cards.asMap().map(
                    (i, e) => MapEntry(i, getPaymentItemWidget(
                      context,
                      widget.model,
                      e,
                      _selectedCard?.paymentId == e.paymentId,
                      state.isEditing,
                      !cards.map((e) => e.paymentId).contains(widget.profile.defaultPaymentMethod) ? i == cards.length - 1 : widget.profile.defaultPaymentMethod == e.paymentId,
                      isSavingAsDefault,
                      true,
                      cancellations.contains(e.paymentId),
                      selectedCard: (card) {
                        setState(() {
                          isSavingAsDefault = false;
                          if (_selectedCard != card && !state.isEditing) {
                            _selectedCard = card;
                          } else {
                            _selectedCard = null;
                          }
                        });
                      },
                      selectedSetDefault: (selected) {
                        setState(() {
                          isSavingAsDefault = !isSavingAsDefault;
                        });
                      },
                      saveNewDefault: (cardItem) {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didChangeDefaultPayment(cardItem.paymentId));
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewDefaultPaymentMethod());
                      },
                      selectedRemove: (cardItem) {

                        cancellations.addAll(state.cancellationList ?? []);
                        setState(() {
                          if (!(cancellations.contains(cardItem.paymentId))) {
                            cancellations.add(cardItem.paymentId);
                          } else {
                            cancellations.remove(cardItem.paymentId);
                          }
                        });
                      }
                    ),
                  )
                ).values.toList(),
                const SizedBox(height: 15),
                Divider(color: widget.model.disabledTextColor),
                const SizedBox(height: 15),
              ],
            ),
            if (state.isSaving) JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            if (!state.isSaving) InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (contexts) {
                      return NewPaymentMethodWidget(
                        profile: widget.profile,
                        model: widget.model,
                        didSaveNewPaymentMethod: (cardToken) {
                          context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didUpdateNewPaymentMethod(cardToken));
                          context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewPaymentMethod());
                          Navigator.of(contexts).pop();
                        },
                      );
                  })
                );
              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: widget.model.paletteColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text('New Payment Method', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
              ),
            ),
            const SizedBox(height: 15),
            if (!state.isSaving && cancellations.isNotEmpty) InkWell(
              onTap: () {

                context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didDChangePaymentsToDelete(cancellations));
                context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedDeleteSelectedPayments());

              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: widget.model.paletteColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text('Delete Selected', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
              ),
            )
          ],
        ),
      ),
    );
  }
}