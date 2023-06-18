import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/access_visibility_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/activity_general_rules_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/background_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/check_ins_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/create_ticket_attendee_type.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/custom_rule_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/requirements_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/reservations_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/select_attendee_type_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/select_cancellation_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final UserProfileModel userProfileModel;
  final ReservationItem reservationItem;
  final ActivityManagerForm activityForm;
  final SettingsItemModel currentNavItem;
  final Function() rebuild;

  const SettingsMainContainerWidget({Key? key, required this.model, required this.userProfileModel, required this.reservationItem, required this.activityForm, required this.currentNavItem, required this.rebuild}) : super(key: key);

  Widget getMainSettingsContainer(BuildContext context, SettingsItemModel navItem) {



    switch (navItem.navItem) {
      case SettingNavMarker.backgroundInfo:
        return BackgroundInfoSettingsWidget(
            model: model
        );
      case SettingNavMarker.requirementsInfo:
        return RequirementSettingsWidget(
          model: model,
        );
      case SettingNavMarker.reservations:
        return ReservationSettingsWidget(
          model: model,
          selectedReservationSlot: null,
        );
      case SettingNavMarker.reservation:
        return ReservationSettingsWidget(
          model: model,
          selectedReservationSlot: navItem.resSlotItem,
        );
      case SettingNavMarker.accessAndVisibility:
        return AccessVisibilitySettingWidget(
          model: model,
        );
      case SettingNavMarker.cancellations:
        return CancellationSettingsWidget(
            model: model
        );
      case SettingNavMarker.customFields:
        return CustomRuleSettingWidget(
            model: model
        );
      case SettingNavMarker.checkIns:
        return CheckInSettingWidget(
            model: model
        );
      case SettingNavMarker.activityRules:
        return ActivityGeneralRulesWidget(
            model: model
        );
      case SettingNavMarker.payments:
        return PaymentsSettingWidget(
            userProfile: userProfileModel,
            model: model,
            paymentRequirementTitle: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased == true) ? 'Tickets' : 'Passes',
            currentCurrency: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.currency,
            showCurrency: true,
            didSelectPaymentButton: () {
              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.createStripeOnBoardingAccountLink(userProfileModel));
            },
            didSelectPresentStripeAccountDashboard: () {
              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.presentStripeAccountDashboard(userProfileModel));
            },
            didSelectCurrencyOption: (currency) {
              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.currencyTypeChanged(currency.toString()));
            }
        );
      case SettingNavMarker.attendanceType:
        return SelectAttendeeTypeWidget(
            model: model
        );
      case SettingNavMarker.ticketBased:
        return CreateTicketAttendee(
            model: model
        );
      case SettingNavMarker.passesBased:
        break;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 165,
          decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(bloc.optionOf(activityForm), bloc.optionOf(reservationItem))),
          child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
            listenWhen: (p,c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.isSaving != c.isSaving || p.activitySettingsForm != c.activitySettingsForm,
            listener: (context, state) {

                ReservationHelperCore.currentActivityForm = state.activitySettingsForm;
                rebuild();

                /// handle saving errors & success options
                state.authFailureOrSuccessOptionSaving.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                          final snackBar = SnackBar(
                          backgroundColor: model.webBackgroundColor,
                          content: failure.maybeMap(
                          activityServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor),),
                          orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: model.disabledTextColor),),
                          )
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }, (_) {
                        final snackBar = SnackBar(
                            elevation: 4,
                              backgroundColor: model.paletteColor,
                              content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: model.webBackgroundColor))
                            );
                            state = state.copyWith(
                              authFailureOrSuccessOptionSaving: bloc.none()
                            );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // Navigator.of(context).pop();
                    }
                  )
                );
            },
            buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages || p.isSaving != c.isSaving || p.isEditingForm != c.isEditingForm || p.activitySettingsForm != c.activitySettingsForm,
            builder: (context, state) {

              return Stack(
                children: [
                  getMainSettingsContainer(
                      context,
                      currentNavItem
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Column(
                      children: [
                        if (state.isSaving) Column(
                          children: [
                            JumpingDots(color: model.paletteColor, radius: 5, numberOfDots: 4),
                            const SizedBox(height: 10),
                            Text(AppLocalizations.of(context)!.saving, style: TextStyle(color: model.disabledTextColor)),
                            const SizedBox(height: 20),
                          ],
                        ),


                        if (state.isEditingForm) InkWell(
                          onTap: () {
                            // widget.didFinishEditing();
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.createActivityFinished());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: model.paletteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Save\nChanges', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        )
      )
    );
  }
}