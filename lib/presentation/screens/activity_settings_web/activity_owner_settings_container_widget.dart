import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_access_visibility_widgets/access_visibility_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_rules_widget/activity_general_rules_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_mobile_widget/background_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_check_in_widget/check_ins_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_attendee_widget/create_ticket_attendee_type.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_custom_rules_widgets/custom_rule_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/requirements_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/reservations_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_attendee_widget/select_attendee_type_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_cancellation_widget/select_cancellation_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/settings_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/side_panel_container/activity_settings_widget/activity_settings_side_panel_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsMainContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel userProfileModel;
  final ReservationItem reservationItem;
  final ActivityManagerForm activityForm;
  final SettingsItemModel? currentNavItem;
  final Function() rebuild;
  final Function() didPresentSidePanel;

  const SettingsMainContainerWidget({Key? key, required this.model, required this.userProfileModel, required this.reservationItem, required this.activityForm, required this.currentNavItem, required this.rebuild, required this.didPresentSidePanel}) : super(key: key);

  @override
  State<SettingsMainContainerWidget> createState() => _SettingsMainContainerWidgetState();
}

class _SettingsMainContainerWidgetState extends State<SettingsMainContainerWidget> {



  Widget getMainSettingsContainer(BuildContext context, SettingsItemModel? navItem, UserProfileModel activityOwner) {

    switch (navItem?.navItem) {
      case SettingNavMarker.backgroundInfo:
        return BackgroundInfoSettingsWidget(
            model: widget.model,
            activityManagerForm: widget.activityForm,
            currentUser: widget.userProfileModel,
            reservationItem: widget.reservationItem,
        );
      case SettingNavMarker.requirementsInfo:
        return RequirementSettingsWidget(
          model: widget.model,
          activityOwner: activityOwner,
          currentUser: widget.userProfileModel,
          reservationItem: widget.reservationItem,
          activityManagerForm: widget.activityForm,
        );
      case SettingNavMarker.reservations:
        return ReservationSettingsWidget(
          model: widget.model,
          selectedReservationSlot: null,
        );
      case SettingNavMarker.reservation:
        return ReservationSettingsWidget(
          model: widget.model,
          selectedReservationSlot: navItem?.resSlotItem,
        );
      case SettingNavMarker.accessAndVisibility:
        return AccessVisibilitySettingWidget(
          model: widget.model,
        );
      case SettingNavMarker.cancellations:
        return CancellationSettingsWidget(
            model: widget.model
        );
      case SettingNavMarker.customFields:
        return CustomRuleSettingWidget(
            model: widget.model
        );
      case SettingNavMarker.checkIns:
        return CheckInSettingWidget(
            model: widget.model
        );
      case SettingNavMarker.activityRules:
        return ActivityGeneralRulesWidget(
            model: widget.model
        );
      case SettingNavMarker.payments:
        return PaymentsSettingWidget(
            userProfile: widget.userProfileModel,
            model: widget.model,
            paymentRequirementTitle: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased == true) ? 'Tickets' : 'Passes',
            currentCurrency: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.currency,
            showCurrency: true,
            didSelectPaymentButton: () {
              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.createStripeOnBoardingAccountLink(widget.userProfileModel));
            },
            didSelectPresentStripeAccountDashboard: () {
              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.presentStripeAccountDashboard(widget.userProfileModel));
            },
            didSelectCurrencyOption: (currency) {
                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.currencyTypeChanged(currency.toString()));
            }
        );
      case SettingNavMarker.attendanceType:
        return SelectAttendeeTypeWidget(
            model: widget.model
        );
      case SettingNavMarker.ticketBased:
        return CreateTicketAttendee(
            model: widget.model
        );
      case SettingNavMarker.passesBased:
        break;
    }
    return Container();
  }

  Widget getSideSettingsContainer(BuildContext context, SettingsItemModel? navItem) {
    switch (navItem?.navItem) {

      case SettingNavMarker.backgroundInfo:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.requirementsInfo:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.locationInfo:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.spaces:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.reservations:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.reservation:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.spaceOption:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.activity:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.hoursAndAvailability:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.accessAndVisibility:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.cancellations:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.customFields:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.spaceRules:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.activityRules:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.payments:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.checkIns:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.reservationConditions:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.pricingRules:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.quotas:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.attendanceType:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.ticketBased:
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 350,
              child: getActivityTicketOptionsColumn(
                  context,
                  widget.model,
                  context.read<UpdateActivityFormBloc>().state.reservationItem,
                  context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                  didSelectTicketOption: (e) {

                },
                false,
                null,
            ),
          )
        );
      case SettingNavMarker.passesBased:
        // TODO: Handle this case.
        break;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.userProfileModel.userId != widget.reservationItem.reservationOwnerId) ? BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.reservationItem.reservationOwnerId.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadSelectedProfileFailure: (_) => settingsFailureToLoadContainer(widget.model),
                loadSelectedProfileSuccess: (item) => getMainContainer(item.profile),
                orElse: () => settingsFailureToLoadContainer(widget.model)
          );
        }
      )
    ) : getMainContainer(widget.userProfileModel);
  }

  Widget getMainContainer(UserProfileModel activityOwner) {
    return Padding(
        padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 10.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 165,
            decoration: BoxDecoration(
                color: widget.model.accentColor,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(bloc.optionOf(widget.activityForm), bloc.optionOf(widget.reservationItem))),
              child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
                listenWhen: (p,c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.isSaving != c.isSaving || p.activitySettingsForm != c.activitySettingsForm,
                listener: (context, state) {

                  ReservationHelperCore.currentActivityForm = state.activitySettingsForm;
                  widget.rebuild();

                  /// handle saving errors & success options
                  state.authFailureOrSuccessOptionSaving.fold(
                          () {},
                          (either) => either.fold(
                              (failure) {
                            final snackBar = SnackBar(
                                backgroundColor: widget.model.webBackgroundColor,
                                content: failure.maybeMap(
                                  activityServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                                  orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                                )
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }, (_) {
                        final snackBar = SnackBar(
                            elevation: 4,
                            backgroundColor: widget.model.paletteColor,
                            content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
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
                          widget.currentNavItem,
                          activityOwner
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Column(
                          children: [
                            if (state.isSaving) Column(
                              children: [
                                JumpingDots(color: widget.model.paletteColor, radius: 5, numberOfDots: 4),
                                const SizedBox(height: 10),
                                Text(AppLocalizations.of(context)!.saving, style: TextStyle(color: widget.model.disabledTextColor)),
                                const SizedBox(height: 20),
                              ],
                            ),


                            if (state.isEditingForm && state.isSaving == false) InkWell(
                              onTap: () {
                                // widget.didFinishEditing();
                                context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(true));
                                context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.createActivityFinished());
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: widget.model.paletteColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text('Save\nChanges', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        right: 0,
                        top: 120,
                        child: AnimatedContainer(
                          width: (ReservationHelperCore.didPresentSidePanel) ? 350 : 0,
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeInOut,
                          child: Visibility(
                            visible: ReservationHelperCore.didPresentSidePanel,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: widget.model.webBackgroundColor,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                          color: widget.model.disabledTextColor.withOpacity(0.35),
                                          spreadRadius: 5,
                                          blurRadius: 13,
                                          offset: const Offset(5,0)
                                      )
                                    ]
                                ),
                                width: 350,
                                // height: MediaQuery.of(context).size.height - 120,
                                child: getSideSettingsContainer(context, widget.currentNavItem)
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                ReservationHelperCore.didPresentSidePanel = !ReservationHelperCore.didPresentSidePanel;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: (ReservationHelperCore.didPresentSidePanel) ? widget.model.accentColor : widget.model.paletteColor,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: widget.model.disabledTextColor)
                              ),
                              height: 45,
                              child:  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined, color: (ReservationHelperCore.didPresentSidePanel) ? widget.model.paletteColor : widget.model.accentColor,),
                                    const SizedBox(width: 8),
                                    Text('preview', style: TextStyle(color: (ReservationHelperCore.didPresentSidePanel) ? widget.model.paletteColor : widget.model.accentColor)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  );
                },
              ),
            )
        )
    );
  }

}