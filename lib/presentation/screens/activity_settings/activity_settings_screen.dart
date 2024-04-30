import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_attendee_widget/create_ticket_attendee_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_attendee_widget/select_attendee_type_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_cancellation_widget/select_cancellation_settings_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_payment_widget/activity_payments_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_rules_widget/activity_general_rules_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_mobile_widget/background_info_settings_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_check_in_widget/chexk_ins_info_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_custom_rules_widgets/custom_rule_info_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_access_visibility_widgets/access_visibility_info_settings_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/requirements_settings_mobile_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'components/activity_background_mobile_widget/activity_background_preview.dart';
import 'components/activity_reservation_widget/create_pass_reservation_widget.dart';
import 'components/activity_settings_mobile_container.dart';

class ActivitySettingsScreenMobile extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final ReservationItem reservationItem;
  final ActivityManagerForm? activityManagerForm;
  final ListingManagerForm listing;

  const ActivitySettingsScreenMobile({super.key, required this.model, required this.reservationItem, required this.listing, this.activityManagerForm, required this.currentUser});

  @override
  State<ActivitySettingsScreenMobile> createState() => _ActivitySettingsScreenMobileState();
}

class _ActivitySettingsScreenMobileState extends State<ActivitySettingsScreenMobile> {

  // TODO: HANDLE SAVING THE WAY SAVING IS HANDLED IN UPDATING PAYMENT SETTINGS...
  // TODO: INCLUDE SETUP FOR ACCEPTING PAYMENTS (IF CHARGING ATTENDEE TYPE IS ANYTHING OTHER THAN FREE)
  // TODO: MAKE THE OPTION TO JOIN AS OTHER ATTENDEE TYPES, I.E ACCEPTING VENDORS...TRAINERS..ORG PARTNERS (LIKE AN APPLICATION) THAT INCLUDES A WAITING LIST & POTENTIAL FEE.

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }


  /// depending on activity show list of items

  Widget getMainListTile(BuildContext context, SettingNavMarker currentNav, ActivityManagerForm activityForm, UserProfileModel activityOwner) {

    switch (currentNav) {
      case SettingNavMarker.backgroundInfo:
        return Column(
          children: [
              ActivityBackgroundPreview(
                reservation: widget.reservationItem,
                model: widget.model,
                currentUser: widget.currentUser,
                activityManagerForm: activityForm,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) {
                        return ActivitySettingsMobileEditor(
                            model: widget.model,
                            activityManagerForm: activityForm,
                            reservation: widget.reservationItem,
                            activityOwner: activityOwner,
                            mainSettingsWidget: BackgroundInfoSettingsWidget(
                              model: widget.model,
                              activityManagerForm: activityForm,
                              currentUser: widget.currentUser,
                              reservationItem: widget.reservationItem,
                            ),
                            didSave: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                        );
                    })
                  );
                },
                leading: Icon(Icons.more_horiz, color: widget.model.paletteColor),
                title: const Text('More to Know..'),
                subtitle: (activityForm.profileService.activityBackground.activityDescription2 != null) ? Text(activityForm.profileService.activityBackground.activityDescription2!.value.fold((l) => 'Add a Description', (r) => r)) : const Text('Add More'),
                trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
              ),

              /// for class activities...
               Visibility(
                 visible: activityForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
                 child: ActivityClassBackgroundPreview(
                  reservation: widget.reservationItem,
                  model: widget.model,
               ),
             )
          ],
        );
      case SettingNavMarker.requirementsInfo:
        return Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return RequirementsSettingsMobileEditor(
                        model: widget.model,
                        activityManagerForm: activityForm,
                        reservation: widget.reservationItem,
                        activityOwner: activityOwner,
                        currentUser: widget.currentUser,
                        didSave: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })
                );
              },
              title: Text('Expectations'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activityForm.profileService.activityRequirements.isSeventeenAndUnder) Text('17 and Under'),
                  if (!(activityForm.profileService.activityRequirements.isSeventeenAndUnder)) Text('Minimum Age: ${activityForm.profileService.activityRequirements.minimumAgeRequirement}'),

                  if (activityForm.profileService.activityRequirements.isMensOnly ?? false) Text('Mens Only'),
                  if (activityForm.profileService.activityRequirements.isWomenOnly ?? false) Text('Womens Only'),
                  if (activityForm.profileService.activityRequirements.isCoEdOnly ?? false) Text('Co-Ed'),

                  if ((activityForm.profileService.activityRequirements.skillLevelExpectation ?? []).isEmpty) Text('Add a Skill Level'),
                  if ((activityForm.profileService.activityRequirements.skillLevelExpectation ?? []).isNotEmpty) Text('Skill Style: '),
                  if ((activityForm.profileService.activityRequirements.skillLevelExpectation ?? []).isNotEmpty) ...activityForm.profileService.activityRequirements.skillLevelExpectation?.map(
                          (e) => Text(e.name)
                  ).toList() ?? []
                ],
              ),
              leading: Icon(Icons.add_chart_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return RequirementsSettingsMobileEditor(
                        model: widget.model,
                        activityManagerForm: activityForm,
                        reservation: widget.reservationItem,
                        activityOwner: activityOwner,
                        currentUser: widget.currentUser,
                        didSave: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })
                );
              },
              title: const Text('On The House'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add What You Will Provide'),
                  if (activityForm.profileService.activityRequirements.isFacilityGear ?? false) const Text('Gear/Clothing Will Be Provided'),
                  if (activityForm.profileService.activityRequirements.isEquipmentProvided ?? false) const Text('Equipment Will Be Provided'),
                  if (activityForm.profileService.activityRequirements.isAnalyticsProvided ?? false) const Text('Analytics Will Be Provided'),
                  if (activityForm.profileService.activityRequirements.isOfficiatorProvided ?? false) const Text('Officiators Will Be Provided'),
                ],
              ),
              leading: Icon(Icons.front_hand_sharp, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return RequirementsSettingsMobileEditor(
                        model: widget.model,
                        activityManagerForm: activityForm,
                        reservation: widget.reservationItem,
                        activityOwner: activityOwner,
                        currentUser: widget.currentUser,
                        didSave: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })
                );
              },
              title: Text('Selling Options'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add What Will be Sold (optional)'),

                ],
              ),
              leading: Icon(Icons.sell_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return RequirementsSettingsMobileEditor(
                        model: widget.model,
                        activityManagerForm: activityForm,
                        reservation: widget.reservationItem,
                        activityOwner: activityOwner,
                        currentUser: widget.currentUser,
                        didSave: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })
                );
              },
              title: const Text('On The House'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add What You Will Provide'),
                  if (activityForm.profileService.activityRequirements.isFacilityGear ?? false) const Text('Gear/Clothing Will Be Provided'),
                  if (activityForm.profileService.activityRequirements.isEquipmentProvided ?? false) const Text('Equipment Will Be Provided'),
                  if (activityForm.profileService.activityRequirements.isAnalyticsProvided ?? false) const Text('Analytics Will Be Provided'),
                  if (activityForm.profileService.activityRequirements.isOfficiatorProvided ?? false) const Text('Officiators Will Be Provided'),
                ],
              ),
              leading: Icon(Icons.front_hand_sharp, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return RequirementsSettingsMobileEditor(
                        model: widget.model,
                        activityManagerForm: activityForm,
                        reservation: widget.reservationItem,
                        activityOwner: activityOwner,
                        currentUser: widget.currentUser,
                        didSave: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })
                );
              },
              title: const Text('On The House (Event)'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add What You Will Provide'),
                  if (activityForm.profileService.activityRequirements.isEquipmentProvided ?? false) const Text('Equipment Will be Provided'),
                  if (activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) const Text('Alcohol Will be Provided'),
                  if (activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) const Text('Food Will be Provided'),
                  if (activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) const Text('Security Will be Provided'),
                ],
              ),
              leading: Icon(Icons.front_hand_sharp, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return RequirementsSettingsMobileEditor(
                        model: widget.model,
                        activityManagerForm: activityForm,
                        reservation: widget.reservationItem,
                        activityOwner: activityOwner,
                        currentUser: widget.currentUser,
                        didSave: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    })
                );
              },
              title: const Text('Vendors & Merchants'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement == null || (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.listOfMerchants.isEmpty ?? false)) const Text('Add Vendors'),
                  // if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.listOfMerchants.isNotEmpty ?? false) ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.listOfMerchants.map(
                  //     (e) =>  Text(e.name.value.fold((l) => '', (r) => r))
                  // ).toList() ?? []
                ],
              ),
              leading: Icon(Icons.add_business, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            ),

          ],
        );
      case SettingNavMarker.reservation:
        // TODO: Handle this case.
        break;
      case SettingNavMarker.activity:
        return ListTile(
          onTap: () {

          },
          title: const Text('About the Activity'),
          subtitle: Text(getTitleForActivityOption(context, activityForm.activityType.activityId) ?? ''),
          leading:  Icon(getIconDataForActivity(context, activityForm.activityType.activityId), color: widget.model.paletteColor),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
        );
      case SettingNavMarker.accessAndVisibility:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) {
              return AccessVisibilitySettingsMobile(
                reservation: widget.reservationItem,
                model: widget.model,
                activityManagerForm: activityForm,
                didSave: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                }
              );
            })
          );
        },
        title: const Text('Access and Visibility'),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

                if (activityForm.rulesService.accessVisibilitySetting.isInviteOnly == true) Text('Invite Required'),
                if (activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true) Text('Private Event'),
                if (activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == false) Text('Public Event')

              ],
            ),
            leading: Icon(Icons.remove_red_eye_outlined, color: widget.model.paletteColor),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
        );
      case SettingNavMarker.customFields:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return CustomRuleInfoMobileEditor(
                      reservation: widget.reservationItem,
                      model: widget.model,
                      activityManagerForm: activityForm,
                      didSave: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                  );
                })
            );
          },
          title: const Text('Custom Rules'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Custom Rules'),

            ],
          ),
          leading: Icon(Icons.checklist_rounded, color: widget.model.paletteColor),
        );
      case SettingNavMarker.checkIns:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return CheckInInfoMobileEditor(
                      reservation: widget.reservationItem,
                      model: widget.model,
                      activityManagerForm: activityForm,
                      didSave: () {
                        setState(() {
                          Navigator.of(context).pop();
                    });
                  }
                );
              })
            );
          },
          title: const Text('Check In Form'),
          subtitle: Text('Add Check In Forms'),
          leading: Icon(Icons.sticky_note_2_outlined, color: widget.model.paletteColor),
        );
      case SettingNavMarker.activityRules:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return ActivityRuleMobileEditor(
                      reservation: widget.reservationItem,
                      model: widget.model,
                      activityManagerForm: activityForm,
                      didSave: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                  );
                })
            );
          },
          title: Text('Activity Rules'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activityForm.rulesService.ruleOption.isValid() && activityForm.rulesService.ruleOption.getOrCrash().isEmpty) Text('Add Rules'),
              ...activityForm.rulesService.ruleOption.value.fold((l) => [], (r) => r.map((e) => Text(predefinedDetailOptions(context).firstWhere((element) => element.uid == e.uid).detail ?? ''))),
            ],
          ),
          leading: Icon(Icons.rule_rounded, color: widget.model.paletteColor),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
        );
      case SettingNavMarker.cancellations:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return CancellationSettingsMobileEditor(
                      reservation: widget.reservationItem,
                      model: widget.model,
                      activityManagerForm: activityForm,
                      didSave: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                  );
                })
            );
          },
          title: const Text('Cancellation'),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Cancellation Rules'),
            ]
          ),
          leading: Icon(Icons.cancel_outlined, color: widget.model.paletteColor),
        );
      case SettingNavMarker.payments:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return PaymentMobileEditor(
                      reservation: widget.reservationItem,
                      model: widget.model,
                      activityManagerForm: activityForm,
                      activityOwner: activityOwner,
                      didSave: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                  );
                })
            );
          },
          title: const Text('Payments'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Handle Payments'),
              Text('Currency: ${NumberFormat.simpleCurrency(locale: activityForm.rulesService.currency).currencyName}'),
            ]
          ),
          leading: Icon(Icons.payments_outlined, color: widget.model.paletteColor),
        );
      case SettingNavMarker.attendanceType:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return AttendeeTypeMobileEditor(
                    reservation: widget.reservationItem,
                    model: widget.model,
                    activityManagerForm: activityForm,
                    didSave: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  );
                })
            );
          },
          title: Text('Attendance Overview'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activityForm.activityAttendance.isLimitedAttendance == null) const Text('Add Attendance Limit'),
              if (activityForm.activityAttendance.isLimitedAttendance ?? false) Text('Attendance Limit: ${activityForm.activityAttendance.attendanceLimit ?? 0}'),
              if (activityForm.activityAttendance.isTicketBased ?? false) const Text('Tickets Holders Only'),
              if (activityForm.activityAttendance.isPassBased ?? false) const Text('Pass Holders Only')
            ],
          ),
          leading: Icon(Icons.paste_rounded, color: widget.model.paletteColor),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
        );
      case SettingNavMarker.ticketBased:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return TicketAttendeeMobileEditor(
                    reservation: widget.reservationItem,
                    model: widget.model,
                    activityManagerForm: activityForm,
                    didSave: () {
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    }
                  );
                })
            );
          },
          title: const Text('Ticket Attendees'),
          leading: Icon(Icons.airplane_ticket_rounded, color: widget.model.paletteColor),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
        );
      case SettingNavMarker.passesBased:
        return ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return ActivityAttendeeCreatePasses(
                    reservation: widget.reservationItem,
                    model: widget.model,
                    activityManagerForm: activityForm,
                  );
                })
            );
          },
          title: const Text('Pass Attendees'),
          leading: Icon(Icons.credit_card_rounded, color: widget.model.paletteColor),
          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
        );
      default:
        return Container();
    }

    return Container();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        title: Text('Your Activity', style: TextStyle(color: widget.model.accentColor)),
      ),
      body: getActivityOwner()
    );
  }

  Widget getActivityOwner() {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.reservationItem.reservationOwnerId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadSelectedProfileFailure: (_) => settingsFailureToLoadContainer(widget.model),
                  loadSelectedProfileSuccess: (item) => getActivityFromReservation(item.profile),
                  orElse: () => settingsFailureToLoadContainer(widget.model)
              );
            }
        )
    );
  }

  Widget getActivityFromReservation(UserProfileModel activityOwner) {
    if (widget.activityManagerForm == null) {
      return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(widget.reservationItem.reservationId.getOrCrash())),
        child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadActivityManagerFormSuccess: (item) => getMainContainer(item.item, activityOwner),
                orElse: () => getMainContainer(ActivityManagerForm.empty(), activityOwner)
            );
          },
        ),
      );
    } else {
      return getMainContainer(widget.activityManagerForm!, activityOwner);
    }
  }


  Widget getMainContainer(ActivityManagerForm activityForm, UserProfileModel activityOwner) {
    return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...activitySettingsHeader(context).map((e) =>
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(e.settingTitle, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 5),
                              Column(
                                children: subActivitySettingItems(activityForm).where((element) => e.sectionMarker == element.sectionNavItem).map(
                                        (e) => getMainListTile(context, e.navItem, activityForm, activityOwner)
                                ).toList()
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        )
                    ).toList()

          ],
        ),
      )
    );
  }
}