import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/activity_settings_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_availability_widget/activity_availability_preview.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_widget/activity_background_preview.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_background_widget/add_more_activity_background_info.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_presets/activity_presets_preview.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_pricing_widget/add_pricing_requirement_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_pricing_widget/review_pricing_breakdown_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_pricing_widget/select_pricing_cancellation_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/select_requirement_basics.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/select_requirement_custom.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/select_requirement_event_basics.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/select_requirement_event_provided.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/select_requirement_event_selling.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_requirements_widget/select_requirements_provided.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_reservation_widget/create_pass_reservation_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_reservation_widget/create_ticket_reservation_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_reservation_widget/review_reservation_overview_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_reservation_widget/select_reservation_overview_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_rules_widget/create_new_activity_game_rule.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_rules_widget/create_new_activity_rule.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_rules_widget/review_activity_rule_preset.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_type_widget/select_activity_type_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivitySettingsScreen extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservationItem;
  final ListingManagerForm listing;

  const ActivitySettingsScreen({super.key, required this.model, required this.reservationItem, required this.listing});

  @override
  State<ActivitySettingsScreen> createState() => _ActivitySettingsScreenState();
}

class _ActivitySettingsScreenState extends State<ActivitySettingsScreen> {

  // TODO: HANDLE SAVING THE WAY SAVING IS HANDLED IN UPDATING PAYMENT SETTINGS...
  // TODO: INCLUDE SETUP FOR ACCEPTING PAYMENTS (IF CHARGING ATTENDEE TYPE IS ANYTHING OTHER THAN FREE)
  // TODO: MAKE THE OPTION TO JOIN AS OTHER ATTENDEE TYPES, I.E ACCEPTING VENDORS...TRAINERS..ORG PARTNERS (LIKE AN APPLICATION) THAT INCLUDES A WAITING LIST & POTENTIAL FEE.

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }


  Widget getMainListTile(BuildContext context, ActivityCreatorFormNav currentNav) {
    switch (currentNav.creatorSectionNav) {
      case ActivityCreatorFormNavSection.selectActivityType:

        switch (currentNav.activityTypeNav) {
          case ActivityTypeNav.selectActivityType:
            /// present current activity type (either experience, game or class etc.) [ActivityTypeNav]
            /// present activity options offered by listing facility.
            ///  TODO: include commercial/retail activity
            ///  TODO: include co-working/office activity
            // return ListTile(
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (_) {
            //           return SelectActivityTypeWidget(
            //             model: widget.model,
            //             activityManagerForm: context.read<UpdateActivityFormBloc>().state.activityManagerForm,
            //         );
            //       })
            //     );
            //   },
            //   title: Text('The Activity'),
            //   subtitle: Text(getActivityTypeOptions().firstWhere((element) => element.activityType == context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityType.activityType).title ?? 'Select an Activity Type'),
            //   leading: Icon(getActivityTypeOptions().firstWhere((element) => element.activityType == context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityType.activityType).icon ?? Icons.house_outlined, color: widget.model.paletteColor),
            //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            // );
          case ActivityTypeNav.selectActivity:
            return ListTile(
              onTap: () {

              },
              title: const Text('About the Activity'),
              subtitle: Text(getTitleForActivityOption(context, context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityId) ?? ''),
              leading:  Icon(getIconDataForActivity(context, context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityId), color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
        }
        break;
      case ActivityCreatorFormNavSection.selectActivityPreset:

          switch (currentNav.activityPreSetup) {
            case ActivityPreSetup.addFacilityActivityContactDetails:
              // return ActivityPresetContactDetails(
              //   model: widget.model,
              // );
            case ActivityPreSetup.addFacilityActivityOrganizationDetails:
              /// linking your community...
              // return ActivityPresetCommunityLinkToPreview(
              //   model: widget.model,
              // );
            case ActivityPreSetup.selectActivitySetupClass:
              // return ActivityPresetClassPreview(
              //   model: widget.model,
              // );
            case ActivityPreSetup.addClassPlayers:
              // return ActivityPresetClassPlayersPreview(
              //   model: widget.model,
              // );
            case ActivityPreSetup.selectActivityGameTeams:
              // return ActivityPresetGamePreview(
              //   model: widget.model,
              // );
          }
        break;
      // case ActivityCreatorFormNavSection.selectLocationType:
      //   // TODO: Handle this case.
      //   break;
      // case ActivityCreatorFormNavSection.selectSpaceType:
      //   // TODO: Handle this case.
      //   break;
      case ActivityCreatorFormNavSection.selectBookingDates:

        // if (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.isActive)) {
         return  viewListOfSelectedSlots(
            context,
            widget.model,
            [],
            widget.reservationItem.reservationSlotItem,
            widget.reservationItem.cancelledSlotItem ?? [],
            false,
            AppLocalizations.of(context)!.profileFacilitySlotTime,
            AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
            AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
            widget.listing,
            didSelectReservation: (e) {
            },
            didSelectCancelResSlot: (e, f) {
            setState(() {});
            },
            didSelectRemoveResSlot: (e, f) {

            }
          );
        // } else {
        //   switch (currentNav.activityAvailableDatesNav) {
        //     case ActivityAvailableDatesNav.selectDurationType:
        //       return ActivityAvailabilitySelectDurationTypePreview(
        //           model: widget.model
        //       );
        //     case ActivityAvailableDatesNav.selectOperatingHours:
        //     // TODO: Handle this case.
        //       break;
        //     case ActivityAvailableDatesNav.selectSessionType:
        //     // TODO: Handle this case.
        //       break;
        //     case ActivityAvailableDatesNav.selectPreBookingType:
        //     // TODO: Handle this case.
        //       break;
        //     case ActivityAvailableDatesNav.reviewDateSetup:
        //     // TODO: Handle this case.
        //       break;
        //   }
        // }
        break;
      case ActivityCreatorFormNavSection.selectBackground:
       switch (currentNav.activityBackgroundNav) {
         case ActivityBackgroundNav.addActivityNameDescription:
           /// add profile image for activity, adding a new image will
           /// are changes to profile image list also a form of uploading a new post?
           /// or is the profile image just a separate way of starting a new post and previewing your activity calls --- too confusing.
           /// the point here is can the profile images and posts be consolidated in some way?
           return ActivityBackgroundPreview(
               reservation: widget.reservationItem,
               model: widget.model
           );
         case ActivityBackgroundNav.addMoreActivityBackground:
           return ListTile(
               onTap: () {
                 Navigator.push(context, MaterialPageRoute(
                   builder: (_) {
                     return ActivityAddMoreBackgroundInfoWidget(
                       reservation: widget.reservationItem,
                       model: widget.model,
                       activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                     );
                   })
                );
               },
               leading: Icon(Icons.more_horiz, color: widget.model.paletteColor),
               title: const Text('More to Know..'),
               subtitle: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription2 != null) ? Text(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription2!.value.fold((l) => 'Add a Description', (r) => r)) : const Text('Add More'),
               trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
             );
         case ActivityBackgroundNav.addClassActivityBackground:
           return ActivityClassBackgroundPreview(
             reservation: widget.reservationItem,
             model: widget.model,
         );
       }
       break;
      case ActivityCreatorFormNavSection.selectRequirements:
        switch (currentNav.activityRequirementsNav) {

          case ActivityRequirementsNav.selectAgeGenderSkillYearsRequirement:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivitySelectRequirementsBasics(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                  })
                );
              },
              title: Text('Expectations'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder) Text('17 and Under'),
                  if (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder)) Text('Minimum Age: ${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement}'),

                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isMensOnly ?? false) Text('Mens Only'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isWomenOnly ?? false) Text('Womens Only'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isCoEdOnly ?? false) Text('Co-Ed'),

                  if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation ?? []).isEmpty) Text('Add a Skill Level'),
                  if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation ?? []).isNotEmpty) Text('Skill Style: '),
                  if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation ?? []).isNotEmpty) ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.map(
                          (e) => Text(e.name)
                  ).toList() ?? []
                ],
              ),
              leading: Icon(Icons.add_chart_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
            break;
          case ActivityRequirementsNav.AddAdditionalCustomDetails:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivitySelectCustomRequirement(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                    })
                );
              },
              title: Text('Special Requirements'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Special Requirements'),
                  ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.customRequirementOption?.value.fold((l) => [], (r) => r.map(
                          (e) => Text(e.customDetail ?? '')
                    )
                  ) ?? []
                ],
              ),
              leading: Icon(Icons.more_horiz_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityRequirementsNav.selectProvidedItems:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRequirementProvided(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
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
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isFacilityGear ?? false) const Text('Gear/Clothing Will Be Provided'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) const Text('Equipment Will Be Provided'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) const Text('Analytics Will Be Provided'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) const Text('Officiators Will Be Provided'),
                ],
              ),
              leading: Icon(Icons.front_hand_sharp, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityRequirementsNav.selectEventOptionItems:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRequirementEventBasics(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
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
            );
          case ActivityRequirementsNav.selectEventSellingOptions:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRequirementEventSelling(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
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
            );
          case ActivityRequirementsNav.selectEventProvidedOptions:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRequirementEventProvided(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
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
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) const Text('Equipment Will be Provided'),
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) const Text('Alcohol Will be Provided'),
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) const Text('Food Will be Provided'),
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) const Text('Security Will be Provided'),
                ],
              ),
              leading: Icon(Icons.front_hand_sharp, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
        }
        break;
      case ActivityCreatorFormNavSection.selectRules:

        switch (currentNav.activityRulesNav) {
          case ActivityRulesNav.reviewActivityPresetRules:
            return ListTile(
              onTap: () {

                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRulesToReview(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                    })
                );

              },
              title: Text('Rules'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review The Rules'),
                  ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.ruleOption.value.fold((l) => [Text('Add Rules For Attendees')], (r) => r.map(
                          (e) => (e.active ?? false) ? Text(e.detail ?? '') : Container()).toList())
                ],
              ),
              leading: Icon(Icons.rule_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityRulesNav.selectActivityRules:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRuleToCreate(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                    );
                  })
                );
              },
              title: Text('Special Rules'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption?.value.fold((l) => [const Text('Add Special Rules')], (r) => r.map(
                            (e) => Text(e.customDetail ?? ''))
                    ) ?? [],
                ],
              ),
              leading: Icon(Icons.rule_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityRulesNav.addCustomRules:
            return ListTile(
              onTap: () {

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
            break;
          case ActivityRulesNav.addCheckInRules:
            return ListTile(
              onTap: () {

              },
              title: const Text('Check In Form'),
              subtitle: Text('Add Check In Forms'),
              leading: Icon(Icons.sticky_note_2_outlined, color: widget.model.paletteColor),
            );
            break;
          case ActivityRulesNav.addActivityRewardRules:
            // TODO: Handle this case.
            break;
          case ActivityRulesNav.addActivityContributionDonationRules:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityRuleGameToCreate(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                    })
                );
              },
              title: const Text('Contributions & Donations'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ],
              ),
              leading: Icon(Icons.wallet_giftcard_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityRulesNav.reviewFacilityIncentiveOptions:
            // TODO: Handle this case.
            break;
          case ActivityRulesNav.requestFacilityPartnerSponsorshipOptions:
            // TODO: Handle this case.
            break;
        }
        break;
      case ActivityCreatorFormNavSection.selectAttendance:
        switch (currentNav.activityAttendanceNav) {

          case ActivityAttendanceNav.attendanceOverview:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityAttendeeSelectType(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                    })
                );
              },
              title: Text('Attendance Overview'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance == null) const Text('Add Attendance Limit'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? false) Text('Attendance Limit: ${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.attendanceLimit ?? 0}'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) const Text('Tickets Holders Only'),
                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false) const Text('Pass Holders Only')
                ],
              ),
              leading: Icon(Icons.paste_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityAttendanceNav.addTicketAttendance:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityAttendeeCreateTicket(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                    })
                );
              },
              title: const Text('Ticket Attendees'),
              leading: Icon(Icons.airplane_ticket_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityAttendanceNav.addPassesAttendance:
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return ActivityAttendeeCreatePasses(
                        reservation: widget.reservationItem,
                        model: widget.model,
                        activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                      );
                    })
                );
              },
              title: const Text('Pass Attendees'),
              leading: Icon(Icons.credit_card_rounded, color: widget.model.paletteColor),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
            );
          case ActivityAttendanceNav.reviewAttendanceType:
           return ListTile(
             onTap: () {
               Navigator.push(context, MaterialPageRoute(
                   builder: (_) {
                     return ActivityAttendeeOverviewReview(
                       reservation: widget.reservationItem,
                       model: widget.model,
                       activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                   );
                 })
               );
             },
             title: const Text('Review Attendees'),
             leading: Icon(Icons.more_horiz_rounded, color: widget.model.paletteColor),
             trailing: Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor),
           );
        }
        break;


    }

    return ListTile(
      title: Text(currentNav.title),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        title: Text('Your Activity', style: TextStyle(color: widget.model.accentColor)),
      ),
      body: getActivityFromReservation()
    );
  }

  Widget getActivityFromReservation() {
    return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchAllActivityManagerFormsStarted(true, widget.reservationItem.reservationId.getOrCrash())),
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadAllActivityManagerFormsFailure: (_) => getMainContainer(ActivityManagerForm.empty()),
              loadAllActivityManagerFormsSuccess: (item) => item.items.isNotEmpty ? getMainContainer(item.items.first) : getMainContainer(ActivityManagerForm.empty()),
              orElse: () => getMainContainer(ActivityManagerForm.empty())
          );
        },
      ),
    );
  }
  
  Widget getMainContainer(ActivityManagerForm activityForm) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityForm), dart.optionOf(widget.reservationItem))),
        child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
          listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
          listener: (context, state) {

      },
      buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
      builder: (context, state) {

        return SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    for (var navItem in groupBy(getMenuItems(context), (menuItem) => menuItem.creatorSectionNav).entries.toList())

                    if (navItem.value.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (navItem.key != ActivityCreatorFormNavSection.selectBackground) const SizedBox(height: 5),
                          if (navItem.key != ActivityCreatorFormNavSection.selectBackground) Divider(thickness: 0.5, color: widget.model.disabledTextColor),
                          const SizedBox(height: 5),
                          Text(getSectionTitle(navItem.key), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: navItem.value.map(
                                    (menuItem) => getMainListTile(context, menuItem)
                        ).toList(),
                      )
                    ],
                  )
                ],
              ),
            )
          );
        }
      )
    );
  }
}