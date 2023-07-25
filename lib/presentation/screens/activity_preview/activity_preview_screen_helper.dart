import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/map_listing_component.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../search_explore/components/map_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ActivityCreateNewMarker {activityDetails, additionalDetails, paymentReview}

class NewActivityModel {

  final ActivityCreateNewMarker markerItem;
  final Widget childWidget;

  NewActivityModel({required this.markerItem, required this.childWidget});

}

/// background info about the activity ///
Widget getActivityBackgroundColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, UserProfileModel? activityOwner, Widget? getListOfPartners, Widget? getListOfInstructors) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(activityForm.profileService.activityBackground.activityTitle.value.fold((l) => '${activityOwner?.legalName.getOrCrash()}\'s Activity', (r) => r), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),

        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(activityForm.profileService.activityBackground.activityDescription1.value.fold((l) => 'This Reservation was made ${getTitleForActivityOption(context, activityForm.activityType.activityId) ?? ''}, send ${activityOwner?.legalName.getOrCrash()} a message if you\'d like to know about how the space will be used.', (r) => r), style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
                  const SizedBox(height: 5),
                  Visibility(
                    visible: activityForm.profileService.activityBackground.activityDescription2?.isValid() == true,
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: model.disabledTextColor),
                        SizedBox(width: 10),
                        Expanded(child: Text(activityForm.profileService.activityBackground.activityDescription2?.value.fold((l) => '', (r) => r) ?? '', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (Responsive.isDesktop(context)) Visibility(
              visible: !(activityForm.profileService.activityBackground.isPartnersInviteOnly ?? false),
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                    color: model.webBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Align(
                    child: Text('Request Partnership', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                  ),
                ),
              ),
            ),
          ],
        ),

        if (Responsive.isMobile(context) || Responsive.isTablet(context)) Visibility(
          visible: !(activityForm.profileService.activityBackground.isPartnersInviteOnly ?? false),
          child: InkWell(
            onTap: () {

            },
            child: Container(
              width: 625,
              height: 60,
              decoration: BoxDecoration(
                color: model.webBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Align(
                child: Text('Request Partnership', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
              ),
            ),
          ),
        ),
        /// if activity is through an organization check and show associated organization...can also show if activity owner has communities/organization/partner associations.
        const SizedBox(height: 10),


        Visibility(
          visible: getListOfPartners != null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                getListOfPartners!
            ],
          )
        ),

        Visibility(
          visible: getListOfInstructors != null,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              getListOfInstructors!
            ],
          ),
        )
      ],
    ),
  );
}


Widget getActivityRequirementsColumn(BuildContext context, DashboardModel model, UserProfileModel? activityOwner, ActivityManagerForm activityForm, Widget? getListOfVendors) {
  bool activityAgeSetting = activityForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !activityForm.profileService.activityRequirements.isSeventeenAndUnder;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Need to know More?', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
            // const SizedBox(height: 4),

            ///all
            /// expectations...age, age limit,
            Visibility(
              visible: activityForm.profileService.activityRequirements.isSeventeenAndUnder,
              child: ListTile(
                leading: Icon(Icons.info_outline, color: model.disabledTextColor),
                title: Text('For ages 17 and under', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: Text('This Activity will be catered specifically for kids'),
              ),
            ),

            Visibility(
              visible: activityForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !(activityForm.profileService.activityRequirements.isSeventeenAndUnder),
              child: ListTile(
                leading: Icon(Icons.info_outline, color: model.disabledTextColor),
                title: Text('Minimum age requirement ${activityForm.profileService.activityRequirements.minimumAgeRequirement}', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 2),
              ),
            ),

            /// expecations class. gender, experience expectations.
            Visibility(
              visible: activityForm.profileService.activityRequirements.isMensOnly == true,
              child: ListTile(
                leading: Icon(Icons.male, color: model.paletteColor),
                title: Text('This Activity will be for Males* only', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: const Text('*This does not exclude those who Identify as Male'),
              ),
            ),
            Visibility(
              visible: activityForm.profileService.activityRequirements.isWomenOnly == true,
              child: ListTile(
                leading: Icon(Icons.female, color: model.paletteColor),
                title: Text('This Activity will be for Females* only', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: const Text('*This does not exclude those who Identify as Female'),
              ),
            ),
            Visibility(
              visible: activityForm.profileService.activityRequirements.isCoEdOnly == true,
              child: ListTile(
                leading: Icon(Icons.accessibility, color: model.paletteColor),
                title: Text('This Activity will be Co-Ed*', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: const Text('*This does not exclude those who Identify as either Male or Female or Neither'),
              ),
            ),

            /// special requirements class, required past experience, additional req.
            Visibility(
              visible: activityForm.profileService.activityRequirements.skillLevelExpectation?.isNotEmpty == true,
              child: ListTile(
                leading: Icon(Icons.workspace_premium_outlined, color: model.paletteColor),
                title: Text('Expect a Skill Level Close to:', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Wrap(
                      spacing: 6.0,
                      runSpacing: 3.0,
                      children: activityForm.profileService.activityRequirements.skillLevelExpectation?.map(
                              (e) => Container(
                            decoration: BoxDecoration(
                                color: model.paletteColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.name, style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1,),
                            ),
                          )
                      ).toList() ?? []
                  ),
                ),
              )
            ),

            /// renting, class, experiences only
            Visibility(
                visible: activityForm.profileService.activityRequirements.isGearProvided == true ||
                    activityForm.profileService.activityRequirements.isEquipmentProvided == true ||
                    activityForm.profileService.activityRequirements.isAnalyticsProvided == true ||
                    activityForm.profileService.activityRequirements.isOfficiatorProvided == true ||
                    activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided == true ||
                    activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided == true ||
                    activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided == true,
                child: ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: model.paletteColor),
                  title: Text('What We Provide:', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 3.0,
                        children: [
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.isGearProvided == true,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Jersey_Gear.png', fit: BoxFit.contain, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(AppLocalizations.of(context)!.activityRequirementsCoveredJerseyGear, style: TextStyle(color: model.paletteColor)),
                                ],
                              ),
                            )
                          ),
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.isEquipmentProvided == true,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', fit: BoxFit.contain, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(color: model.paletteColor)),
                                ],
                              ),
                            )
                          ),
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.isAnalyticsProvided == true,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Icon(Icons.bar_chart_rounded, size: 80, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(AppLocalizations.of(context)!.activityRequirementsCoveredAnalyticsStandings, style: TextStyle(color: model.paletteColor)),
                                ],
                              ),
                            )
                          ),
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.isOfficiatorProvided == true,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Referee_Officiator.png', fit: BoxFit.contain, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Officiator/\nReferees', style: TextStyle(color: model.paletteColor)),
                                  ],
                                ),
                              )
                          ),
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided == true && activityAgeSetting,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Alcohol.png', fit: BoxFit.contain, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(AppLocalizations.of(context)!.activityRequirementEventAlcohol, style: TextStyle(color: model.paletteColor)),
                                ],
                              ),
                            )
                          ),
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided == true,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Food_Drinks.png', fit: BoxFit.contain, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(AppLocalizations.of(context)!.activityRequirementEventFoodOrDrink, style: TextStyle(color: model.paletteColor)),
                                ],
                              ),
                            )
                          ),
                          Visibility(
                              visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided == true,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Icon(Icons.lock, size: 35, color: model.paletteColor),
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Security', style: TextStyle(color: model.paletteColor)),
                                  ],
                          ),
                        )
                      ),
                    ],
                  ),
                )
              )
            ),


            /// offered/provision, gear or equipment
            /// selling options, (events
            Visibility(
              visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale == true,
              child: ListTile(
                leading: Icon(Icons.monetization_on_outlined, color: model.paletteColor),
                title: Text('Expect Food or Drinks to be Sold', style: TextStyle(color: model.paletteColor)),
                subtitle: const Text('You\'ll be able to buy Food or Drinks on the day of.'),
              ),
            ),

            Visibility(
              visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale == true && activityAgeSetting,
              child: ListTile(
                leading: Icon(Icons.monetization_on_outlined, color: model.paletteColor),
                title: Text('Expect Alcohol to be Sold', style: TextStyle(color: model.paletteColor)),
                subtitle: const Text('You\'ll be able to buy Drinks on the day of.'),
              ),
            ),


            /// events only
            /// offered/provisions, gear, food, drinks, security,
            /// vendors or merchants - invite or allow vendors to join. --- set a fee, contact details, an image (for now...), waiting lists?
            Visibility(
              visible: (activityForm.profileService.activityRequirements.eventActivityRulesRequirement != null) && !(activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly ?? false),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      width: 675,
                      height: 60,
                      decoration: BoxDecoration(
                        color: model.webBackgroundColor,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Align(
                        child: Text('Join as Vendor', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: getListOfVendors != null,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  getListOfVendors!
                ],
              ),
            ),

            const SizedBox(height: 5),
            if (Responsive.isTablet(context) || Responsive.isMobile(context)) if (activityOwner != null) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: getHostColumn(context, activityOwner, model),
            ),
          ],
        ),
      ),

      const SizedBox(width: 5),
      if (Responsive.isDesktop(context)) if (activityOwner != null) Container(
          width: 300,
          child: getHostColumn(context, activityOwner, model)),

    ],
  );
}

Widget getActivityRulesColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

      /// all
      /// select rules to include

      /// classes
      /// special rules

      /// all
      /// check-in form

      /// custom rules
      /// custom rules - related to specific attendee types

    ],
  );
}


Widget getActivityTicketOptionsColumn(
    BuildContext context,
    DashboardModel model,
    ReservationItem reservation,
    ActivityManagerForm activityForm,
    bool showFindTicket,
    {required Function(ActivityTicketOption) didSelectTicketOption}) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text('Activity Tickets', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 4),
      Visibility(
        visible: activityForm.activityAttendance.isTicketFixed == true,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getTicketForEntireActivity(
                context,
                model,
                reservation,
                activityForm,
                activityForm.activityAttendance.defaultActivityTickets ?? ActivityTicketOption.empty(),
                true,
                showFindTicket,
                didSelectTicket: (ticket) {
                  didSelectTicketOption(ticket);
                }
            ),
          )
        )
      ),

      Visibility(
        visible: activityForm.activityAttendance.isTicketPerSlotBased == false && activityForm.activityAttendance.isTicketFixed == false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  if ((activityForm.activityAttendance.activityTickets?.length ?? 0) == 1) Text('${activityForm.activityAttendance.activityTickets?.length ?? 0} Event', style: TextStyle(color: model.disabledTextColor)),
                  if ((activityForm.activityAttendance.activityTickets?.length ?? 0) > 1) Text('${activityForm.activityAttendance.activityTickets?.length ?? 0} Events', style: TextStyle(color: model.disabledTextColor)),
                  ...activityForm.activityAttendance.activityTickets?.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: getTicketForDayBasedActivity(
                          context,
                          model,
                          activityForm,
                          e,
                          showFindTicket,
                          true,
                          didSelectTicket: (ticket) {
                            didSelectTicketOption(ticket);
                          },
                      ),
                    )
                ).toList() ?? []
              ]
            ),
          )
        ),

        Visibility(
          visible: activityForm.activityAttendance.isTicketPerSlotBased == true && activityForm.activityAttendance.isTicketFixed == false,
            child: Column(
            children: activityForm.activityAttendance.activityTickets?.map(
            (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: getTicketForSlotBasedActivity(
                    context,
                    model,
                    activityForm,
                    e,
                    showFindTicket,
                    true,
                    didSelectTicket: (ticket) {
                      didSelectTicketOption(ticket);
                    },
                ),
              )
            ).toList() ?? []
          )
        ),
    ],
  );
}


/// HOW DOES THIS APPLY TO MERCHANT BASED ACTIVITIES?
/// OPTION TO JOIN VIA TICKET OR PASS ATTENDEE
Widget getActivityAttendeeOptionsColumn(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

      /// ticket or pass options

      /// ticket options

    ],
  );
}

Widget getActivityCancellationsRefunds(BuildContext context, DashboardModel model, ActivityManagerForm activityForm,) {
  return Column(
    children: [

    ],
  );
}

Widget flagOrReportActivityColumn(DashboardModel model, {required Function() didSelectReport}) {
  return ListTile(
    onTap: () {

    },
    leading: Icon(Icons.flag, color: model.paletteColor),
    title: Text('Report This Listing', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
  );
}

Widget getVendorAttendees(DashboardModel model, ActivityManagerForm activityForm, {required Function(AttendeeItem) didSelectAttendee}) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.vendor.toString(), activityForm.activityFormId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          attLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
          loadAllAttendanceFailure: (_) => Container(),
          loadAllAttendanceSuccess: (item) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vendors', style: TextStyle(color: model.paletteColor)),
                const SizedBox(height: 15),
                Container(
                  height: 165,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: item.item.map(
                            (attendee) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: getVendorAttendeeType(
                              context,
                              model,
                              attendee: attendee,
                              didSelectAttendee: (attendee) {
                                didSelectAttendee(attendee);
                              }
                          ),
                        )
                    ).toList(),
                  ),
                ),
              ],
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}


Widget getPartnerAttendees(DashboardModel model, ActivityManagerForm activityForm, {required Function(AttendeeItem) didSelectAttendee}) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.partner.toString(), activityForm.activityFormId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          attLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
          loadAllAttendanceFailure: (_) => Container(),
          loadAllAttendanceSuccess: (item) {
            return ListTile(
              leading: Icon(Icons.handshake_outlined, color: model.paletteColor),
              title: Text('Partners', style: TextStyle(color: model.paletteColor)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: SingleChildScrollView(
                  child: Row(
                    children: item.item.map(
                            (attendee) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: getPartnerAttendeeType(context,
                              model,
                              attendee: attendee,
                              didSelectAttendee: (attendee) {

                              }
                          ),
                        )
                    ).toList(),
                  ),
                ),
              ),
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}

Widget getInstructorAttendees(DashboardModel model, ActivityManagerForm activityForm, {required Function(AttendeeItem) didSelectAttendee}) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.instructor.toString(), activityForm.activityFormId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          attLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
          loadAllAttendanceFailure: (_) => Container(),
          loadAllAttendanceSuccess: (item) {
            return ListTile(
              leading: Icon(Icons.people_outline, color: model.paletteColor),
              title: Text('Instructors', style: TextStyle(color: model.paletteColor)),
              subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: SingleChildScrollView(
                  child: Column(
                    children: item.item.map(
                            (attendee) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                          child: getInstructorAttendeeType(
                              context,
                              model,
                              attendee: attendee,
                              didSelectAttendee: (attendee) {

                              }
                          ),
                        )
                    ).toList(),
                  ),
                ),
              )
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}

Widget getAttendeesForTicketActivity(DashboardModel model, ActivityManagerForm activityForm) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.tickets.toString(), activityForm.activityFormId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          attLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
          loadAllAttendanceFailure: (_) => Container(),
          loadAllAttendanceSuccess: (item) {
            return Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: model.disabledTextColor)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.airplane_ticket_outlined),
                          const SizedBox(width: 8),
                          Text('Attending: ${item.item.length}', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1,),
                      ],
                    ),
                  )
                ),
                const SizedBox(width: 8),
                if (activityForm.activityAttendance.isTicketFixed == true) IconButton(onPressed: () {
                }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Tickets are limited to ${activityForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 1} for this activity',),
              ],
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}


Widget getAttendeesForFreeActivity(DashboardModel model, ActivityManagerForm activityForm) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.free.toString(), activityForm.activityFormId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          attLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
          loadAllAttendanceFailure: (_) => Container(),
          loadAllAttendanceSuccess: (item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: model.disabledTextColor)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.people_outline),
                          const SizedBox(width: 8),
                          Text('Attending: ${item.item.length}', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1,),
                      ],
                    ),
                  )
                ),
                const SizedBox(width: 8),
                if (activityForm.activityAttendance.isLimitedAttendance == true) IconButton(onPressed: () {
                }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Attendance is limited to ${activityForm.activityAttendance.attendanceLimit ?? 1} for this activity',),
              ],
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}

