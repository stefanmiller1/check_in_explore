import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_access_visibility_widgets/access_visibility_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_rules_widget/activity_general_rules_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_mobile_widget/background_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_check_in_widget/check_ins_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_attendee_widget/create_ticket_attendee_type.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_custom_rules_widgets/custom_rule_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/requirements_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/pop_over_screen/activity_onboarding_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/reservations_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_attendee_widget/select_attendee_type_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_cancellation_widget/select_cancellation_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../activity_settings/components/activity_vendor_form_widget/activity_vendor_forms_widget.dart';

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


  late ActivityManagerForm? initActivityManagerForm = null;
  late bool needsOnBoarding = false;
  late bool didCreateNewActivity = false;

  @override
  void initState() {
    super.initState();

    initActivityManagerForm = widget.activityForm;
    needsOnBoarding = activitySetupComplete(widget.activityForm) == false;

  }

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
      case SettingNavMarker.vendorForm:
        return VendorFormsWidget(
          reservation: widget.reservationItem,
          model: widget.model,
          activityForm: widget.activityForm,
          resOwner: activityOwner,
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
      default:
        return Container();
    }
    return Container();
  }

  Widget getSideSettingsContainer(BuildContext context, SettingsItemModel? navItem, UserProfileModel reservationOwner) {
    switch (navItem?.navItem) {
      case SettingNavMarker.backgroundInfo:
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: ReservationHelperCore.previewerWidth - 30,
                  child: Column(
                    children: [
                      getActivityBackgroundForPreview(
                          context,
                          widget.model,
                          true,
                          true,
                          widget.activityForm,
                          widget.reservationItem,
                          [],
                          reservationOwner
                    ),
                  ],
                ),
              ),
            )
          )
        );
      case SettingNavMarker.requirementsInfo:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: ReservationHelperCore.previewerWidth - 30,
              child: Column(
                children: [
                  getActivityRequirementsColumn(
                    context,
                    widget.model,
                    true,
                    false,
                    reservationOwner,
                    widget.activityForm,
                    widget.reservationItem,
                    [],
                    widget.userProfileModel.userId.getOrCrash(),
                    didSelectAttendees: () {

                    }
                  ),
                ],
              ),
            ),
          ),
        );
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
              width: ReservationHelperCore.previewerWidth - 30,
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
      case null:
        // TODO: Handle this case.
      case SettingNavMarker.vendorForm:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: ReservationHelperCore.previewerWidth - 27,
            child: getActivityVendorOptionColumn(
              context,
              widget.model,
              context.read<UpdateActivityFormBloc>().state.reservationItem,
              context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
              reservationOwner,
              true,
              ReservationHelperCore.previewerWidth,
              false,
              didSelectManage: () {

              },
            ),
          ),
        );
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

                        if ((initActivityManagerForm != null) && activitySetupComplete(initActivityManagerForm!) == false && activitySetupComplete(state.activitySettingsForm)) {
                          didCreateNewActivity = true;
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              setState(() {
                                didCreateNewActivity = false;
                              });
                            }
                          });
                        }

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

                  bool showPreviewer = widget.currentNavItem?.navItem == SettingNavMarker.backgroundInfo || widget.currentNavItem?.navItem == SettingNavMarker.requirementsInfo || widget.currentNavItem?.navItem == SettingNavMarker.ticketBased || widget.currentNavItem?.navItem == SettingNavMarker.vendorForm;

                  return Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                      getMainSettingsContainer(
                          context,
                          widget.currentNavItem,
                          activityOwner
                      ),

                      if (showPreviewer) Positioned(
                        right: 0,
                          child: AnimatedContainer(
                            width: (ReservationHelperCore.didPresentSidePanel && Responsive.isDesktop(context)) ? ReservationHelperCore.previewerWidth : 0,
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
                                  width: ReservationHelperCore.previewerWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: getSideSettingsContainer(context, widget.currentNavItem, activityOwner),
                                )
                              ),
                            ),
                          )
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


                            if ((state.activitySettingsForm != initActivityManagerForm) && activitySetupComplete(state.activitySettingsForm) == false && ((initActivityManagerForm != null) && activitySetupComplete(initActivityManagerForm!) == false) && state.isSaving == false) InkWell(
                              onTap: () {
                                // widget.didFinishEditing();
                                context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(true));
                                context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.createActivityFinished());
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: widget.model.paletteColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Center(
                                      child: Text('Save Draft', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            /// will un-publish if saving (from init published) but incomplete.
                            if (state.activitySettingsForm != initActivityManagerForm &&
                                activitySetupComplete(state.activitySettingsForm) == false &&
                                (initActivityManagerForm != null) &&
                                activitySetupComplete(initActivityManagerForm!)) InkWell(
                              onTap: () {
                                context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(true));
                                context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.createActivityFinished());
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: widget.model.paletteColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Center(
                                          child: Text('Un-Publish & Save Draft', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8)
                                ],
                              ),
                            ),



                            /// Publish is not published on load
                            AnimatedBorderButton(
                                buttonText: ((initActivityManagerForm != null) && activitySetupComplete(initActivityManagerForm!) == false) ? 'Publish Activity' : 'Update Activity',
                                isActivated: (state.isEditingForm && state.activitySettingsForm != initActivityManagerForm && activitySetupComplete(state.activitySettingsForm) && (initActivityManagerForm != null)),
                                model: widget.model,
                                didSelectButton: () {
                                    context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(true));
                                    context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.createActivityFinished());
                              }
                            ),
                          ],
                        ),
                      ),

                      if (showPreviewer) Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.didPresentSidePanel();
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


                      if (needsOnBoarding) OnBoardingPopOverWidget(
                          popOverWidget: ActivityOnBoardingWidget(
                            model: widget.model,
                            didSelectClose: () {
                              setState(() {
                                needsOnBoarding = false;
                              });
                            },
                          ),
                          model: widget.model
                      ),

                      if (didCreateNewActivity) Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Lottie.asset(
                            height: MediaQuery.of(context).size.height - 200,
                            'assets/lottie_animations/animation_700434682245.json'
                        ),
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