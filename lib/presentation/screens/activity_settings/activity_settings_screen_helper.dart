import 'dart:collection';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// List<ActivityCreatorFormNav> getMenuItems(BuildContext context) {
//
//   List<ActivityCreatorFormNav> activityNavMenuItem = [];
//   ActivityManagerForm formState = context.read<UpdateActivityFormBloc>().state.activitySettingsForm;
//
//
//   /// your background ///
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-2p4fj903023r'), ActivityCreatorFormNavSection.selectBackground, AppLocalizations.of(context)!.activityCreatorFormNavBackground2, AppLocalizations.of(context)!.facilityBackgroundMainTitle, true, false, activityBackgroundNav: ActivityBackgroundNav.addActivityNameDescription));
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-f39029n3f093'), ActivityCreatorFormNavSection.selectBackground, AppLocalizations.of(context)!.activityCreatorFormNavBackground3, AppLocalizations.of(context)!.facilityBackgroundMainTitle2, true, false, activityBackgroundNav: ActivityBackgroundNav.addMoreActivityBackground));
//
//
//   /// *** class based background *** ///
//   // if (formState.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.classesLessons) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-4282983nfoi3'), ActivityCreatorFormNavSection.selectBackground, AppLocalizations.of(context)!.facilityBackgroundMainTitle2, AppLocalizations.of(context)!.activityCreatorFormNavBackground4, true, false, activityBackgroundNav: ActivityBackgroundNav.addClassActivityBackground));
//   // }
//
//
//   /// your activity ///
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-69043n0934f4'), ActivityCreatorFormNavSection.selectActivityType, AppLocalizations.of(context)!.activityCreatorFormNavTypeNavTitle1, AppLocalizations.of(context)!.activityCreatorFormNavType1, true, false, activityTypeNav: ActivityTypeNav.selectActivityType));
//   if (formState.activityType.activityType != ProfileActivityTypeOption.toRent) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-539209fj2093'), ActivityCreatorFormNavSection.selectActivityType, AppLocalizations.of(context)!.activityCreatorFormNavTypeNavTitle2, AppLocalizations.of(context)!.activityCreatorFormNavType2, true, false, activityTypeNav: ActivityTypeNav.selectActivity));
//   }
//
//   /// your presets ///
//   /// *** class based presets *** ///
//   // if (formState.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.classesLessons) {
//   //   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-5029f0nf9023'), ActivityCreatorFormNavSection.selectActivityPreset, AppLocalizations.of(context)!.activityCreatorFormNavPreset1, AppLocalizations.of(context)!.activityCreatorFormNavPresetTitle, true, false, activityPreSetup: ActivityPreSetup.selectActivitySetupClass));
//     // if (formState.activityCreatorForm.activityAvailability.classesActivityAvailability?.coachExistingTeam ?? false) {
//     // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-39f0293nf903'), ActivityCreatorFormNavSection.selectActivityPreset, AppLocalizations.of(context)!.activityCreatorFormNavPreset2, AppLocalizations.of(context)!.activityCreatorFormNavPresetTitle, true, false, activityPreSetup: ActivityPreSetup.addClassPlayers));
//     // }
//   // }
//   /// *** game based presets *** ///
//   // if (formState.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.gameMatches && formState.activityCreatorForm.activityType.activity == ProfileActivityOption.tournament) {
//   //   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-gi5409203fj9'), ActivityCreatorFormNavSection.selectActivityPreset, AppLocalizations.of(context)!.activityCreatorFormNavPreset3, AppLocalizations.of(context)!.activityCreatorFormNavPresetTitle, true, false, activityPreSetup: ActivityPreSetup.selectActivityGameTeams));
//   // }
//   /// *** experience based presets *** ///
//   // if (formState.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.experiences) {
//   //   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-4f3i909f0494'), ActivityCreatorFormNavSection.selectActivityPreset, AppLocalizations.of(context)!.activityCreatorFormNavPreset3, '', true, false, activityPreSetup: ActivityPreSetup.addFacilityActivityContactDetails));
//   //   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-f02395n029nf'), ActivityCreatorFormNavSection.selectActivityPreset, AppLocalizations.of(context)!.activityCreatorFormNavPreset3, '', true, false, activityPreSetup: ActivityPreSetup.addFacilityActivityOrganizationDetails));
//   // }
//
//
//   // your availability ///
//   /// *** ACTIVITY WITHOUT FACILITY *** ///
//   // if (formState.activityAvailability.isActive) {
//   //   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-g049592093f2'), ActivityCreatorFormNavSection.selectBookingDates, AppLocalizations.of(context)!.activityCreatorFormNavAvailabilitySubTitle1, AppLocalizations.of(context)!.activityCreatorFormNavAvailability1, true, false, activityAvailableDatesNav: ActivityAvailableDatesNav.selectDurationType));
//   //   if (formState.activityAvailability.durationType != DurationType.day) { activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-9504ngo45094'), ActivityCreatorFormNavSection.selectBookingDates, AppLocalizations.of(context)!.activityCreatorFormNavAvailabilitySubTitle2, AppLocalizations.of(context)!.activityCreatorFormNavAvailability2, true, false, activityAvailableDatesNav: ActivityAvailableDatesNav.selectOperatingHours)); }
//   //   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-209rnfoi0233'), ActivityCreatorFormNavSection.selectBookingDates, AppLocalizations.of(context)!.activityCreatorFormNavAvailabilitySubTitle3, AppLocalizations.of(context)!.activityCreatorFormNavAvailability3, true, false, activityAvailableDatesNav: ActivityAvailableDatesNav.selectPreBookingType));
//   // }
//   // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-cmoie900293n'), ActivityCreatorFormNavSection.selectBookingDates, AppLocalizations.of(context)!.activityCreatorFormNavAvailabilitySubTitle4, AppLocalizations.of(context)!.activityCreatorFormNavAvailability4, true, false, activityAvailableDatesNav: ActivityAvailableDatesNav.reviewDateSetup));
//
//
//   /// your requirement ///
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-2pfpom30-203'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle1, AppLocalizations.of(context)!.activityCreatorFormNavRequirement1, true, false, activityRequirementsNav: ActivityRequirementsNav.selectAgeGenderSkillYearsRequirement));
//
//   // if (formState.activityCreatorForm.activityType.activity != ProfileActivityOption.events) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-f093nodikmf9'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle2, AppLocalizations.of(context)!.activityCreatorFormNavRequirement2, true, false, activityRequirementsNav: ActivityRequirementsNav.AddAdditionalCustomDetails));
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-fj803049nf94'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle3, AppLocalizations.of(context)!.activityCreatorFormNavRequirement3, true, false, activityRequirementsNav: ActivityRequirementsNav.selectProvidedItems));
//   // }
//
//   /// *** experience based requirement *** ///
//   // if (formState.activityCreatorForm.activityType.activity == ProfileActivityOption.events) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-90394fj09j0k'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle2, AppLocalizations.of(context)!.activityCreatorFormNavRequirement2, true, false, activityRequirementsNav: ActivityRequirementsNav.selectEventOptionItems));
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-g0394jf094j9'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle3, AppLocalizations.of(context)!.activityCreatorFormNavRequirement3, true, false, activityRequirementsNav: ActivityRequirementsNav.selectEventProvidedOptions));
//   // } else if (formState.activityCreatorForm.activityType.activity != ProfileActivityOption.toRent) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-f09i4noif434'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle4, AppLocalizations.of(context)!.activityCreatorFormNavRequirement4, true, false, activityRequirementsNav: ActivityRequirementsNav.selectEventSellingOptions));
//   // }
//   /// *** game based requirement *** ///
//   // if (formState.activityCreatorForm.activityType.activity == ProfileActivityOption.tournament) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-f0934j09f3no'), ActivityCreatorFormNavSection.selectRequirements, AppLocalizations.of(context)!.activityCreatorFormNavRequirementSubTitle4, AppLocalizations.of(context)!.activityCreatorFormNavRequirement4, true, false, activityRequirementsNav: ActivityRequirementsNav.selectEventSellingOptions));
//   // }
//
//   /// your rules ///
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-50gj309gn099'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle1, AppLocalizations.of(context)!.activityCreatorFormNavRules1, true, false, activityRulesNav: ActivityRulesNav.reviewActivityPresetRules));
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-fj093nnoie09'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle2, AppLocalizations.of(context)!.activityCreatorFormNavRules2, true, false, activityRulesNav: ActivityRulesNav.selectActivityRules));
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-fj093nnoie09'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle2, AppLocalizations.of(context)!.activityCreatorFormNavRules2, true, false, activityRulesNav: ActivityRulesNav.addCheckInRules));
//   activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-fj093nnoie09'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle2, AppLocalizations.of(context)!.activityCreatorFormNavRules2, true, false, activityRulesNav: ActivityRulesNav.addCustomRules));
//   // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-f2390f09f930'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle3, AppLocalizations.of(context)!.activityCreatorFormNavRules3, true, false, activityRulesNav: ActivityRulesNav.addActivityRewardRules));
//
//   /// *** game based rules *** ///
//   if (formState.activityType.activityType == ProfileActivityTypeOption.gameMatches) {
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-g03jg940309n'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle4, AppLocalizations.of(context)!.activityCreatorFormNavRules4, true, false, activityRulesNav: ActivityRulesNav.addActivityContributionDonationRules));
//     /// *** NON - FACILITY - OWNER *** ///
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-fj3029209fj9'), ActivityCreatorFormNavSection.selectRules, AppLocalizations.of(context)!.activityCreatorFormNavRulesSubTitle1, AppLocalizations.of(context)!.activityCreatorFormNavRules4, true, false, activityRulesNav: ActivityRulesNav.reviewFacilityIncentiveOptions));
//   }
//
//   /// your attendance ///
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-g0394n039403'), ActivityCreatorFormNavSection.selectAttendance, AppLocalizations.of(context)!.activityCreatorFormNavAttendanceSubTitle1, AppLocalizations.of(context)!.activityCreatorFormNavAttendance1, true, false, activityAttendanceNav: ActivityAttendanceNav.attendanceOverview));
//     // if (formState.activityCreatorForm.activityAttendance.isTicketBased ?? false) {
//       activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-6902nf0293n'), ActivityCreatorFormNavSection.selectAttendance, AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicketSubTitle, AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicket1, true, false, activityAttendanceNav: ActivityAttendanceNav.addTicketAttendance));
//     // }
//     // if (formState.activityCreatorForm.activityAttendance.isPassBased ?? false) {
//       activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-6mj4398ng09'), ActivityCreatorFormNavSection.selectAttendance, AppLocalizations.of(context)!.activityCreatorFormNavAttendancePassesSubTitle, AppLocalizations.of(context)!.activityCreatorFormNavAttendancePasses1, true, false, activityAttendanceNav: ActivityAttendanceNav.addPassesAttendance));
//     // }
//     activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-h0495n093894'), ActivityCreatorFormNavSection.selectAttendance, AppLocalizations.of(context)!.activityCreatorFormNavAttendanceSubTitle3, AppLocalizations.of(context)!.activityCreatorFormNavAttendanceReview, true, false, activityAttendanceNav: ActivityAttendanceNav.reviewAttendanceType));
//
//     /// your prices ///
//     // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-89060jnf093f'), ActivityCreatorFormNavSection.selectPricing, AppLocalizations.of(context)!.activityCreatorFormNavCosting1, AppLocalizations.of(context)!.facilityCostingMainTitle, true, false, activityPricingNav: ActivityPricingNav.reviewCostingBreakdown));
//     // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-502390593092'), ActivityCreatorFormNavSection.selectPricing, AppLocalizations.of(context)!.activityCreatorFormNavCosting2, AppLocalizations.of(context)!.facilityCostingMainTitle, true, false, activityPricingNav: ActivityPricingNav.addDynamicBasedCosting));
//     // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-592039869234'), ActivityCreatorFormNavSection.selectPricing, AppLocalizations.of(context)!.activityCreatorFormNavCosting3, AppLocalizations.of(context)!.facilityCostingMainTitle, true, false, activityPricingNav: ActivityPricingNav.selectCancellationType));
//
//     /// review ///
//     // activityNavMenuItem.add(ActivityCreatorFormNav(UniqueId.fromUniqueString('6e24dae0-96dd-41id-nfio-60j2093n3902'), ActivityCreatorFormNavSection.viewSummary, AppLocalizations.of(context)!.facilitySummaryMainTitle, '', true, false, activitySummaryNav: ActivitySummaryNav.reviewActivity));
//
//     return activityNavMenuItem;
// }

String getSectionTitle(ActivityCreatorFormNavSection section) {

  switch (section) {
    case ActivityCreatorFormNavSection.selectActivityType:
      return 'Activity Type';
    case ActivityCreatorFormNavSection.selectActivityPreset:
      return 'Activity Preset';
    case ActivityCreatorFormNavSection.selectBookingDates:
      return 'Activity Dates';
    case ActivityCreatorFormNavSection.selectBackground:
      return 'Activity Profile';
    case ActivityCreatorFormNavSection.selectRequirements:
      return 'Your Requirements';
    case ActivityCreatorFormNavSection.selectRules:
      return 'Your Rules';
    case ActivityCreatorFormNavSection.selectAttendance:
      return 'Attendees';
    default:
      return 'Loading...';
  }
}


