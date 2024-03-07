import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/components/background_images_pageview.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/map_listing_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../search_explore/components/map_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ActivityCreateNewMarker {activityDetails, additionalDetails, paymentReview}
enum ActivityPreviewTabs {activity, reservation}

class NewActivityModel {

  final ActivityCreateNewMarker markerItem;
  final Widget childWidget;

  NewActivityModel({required this.markerItem, required this.childWidget});

}


Widget getActivityBackgroundForPreview(BuildContext context, DashboardModel model, bool showSuggestions, bool isOwner, ActivityManagerForm activityForm, ReservationItem reservation, List<UniqueId> linkedCommunities, UserProfileModel? activityOwner) {
  return SizedBox(
    width: ReservationHelperCore.previewerWidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActivityBackgroundImagePreview(
          activityForm: activityForm,
          model: model,
          reservation: reservation,
        ),
        const SizedBox(height: 8),
        getActivityBackgroundHeader(context, model, activityForm, isOwner, linkedCommunities),
        getActivityBackgroundRowOne(context, model, activityForm, reservation, activityOwner),
        getActivityBackgroundRowTwo(context, 620, model, showSuggestions, activityForm, activityOwner, reservation)
      ],
    ),
  );
}

/// background info about the activity ///
Widget getActivityBackgroundColumn(BuildContext context, DashboardModel model, bool activitySetupComplete, bool showSuggestions, bool isOwner, ActivityManagerForm activityForm, UserProfileModel? activityOwner, Widget? getListOfPartners, Widget? getListOfInstructors,  List<UniqueId> linkedCommunities, ReservationItem reservation) {

  final bool isLessThanMain = Responsive.isDesktop(context);

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getActivityBackgroundHeader(context, model, activityForm, isOwner, linkedCommunities),
        Visibility(
          visible: isLessThanMain == false,
          child: Column(
            children: [
              getActivityBackgroundRowOne(context, model, activityForm, reservation, activityOwner),
              getActivityBackgroundRowTwo(context, 620, model, showSuggestions, activityForm, activityOwner, reservation)
            ],
          ),
        ),
        Visibility(
          visible: isLessThanMain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: getActivityBackgroundRowOne(context, model, activityForm, reservation, activityOwner),
              ),
              const SizedBox(width: 6),
              getActivityBackgroundRowTwo(context, 250, model, showSuggestions, activityForm, activityOwner, reservation)
            ],
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


Widget getActivityBackgroundHeader(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, bool isOwner, List<UniqueId> linkedCommunities) {
  final bool isPrivate = (activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true || activityForm.rulesService.accessVisibilitySetting.isInviteOnly == true);

  return Column(
    children: [
      Row(
        children: [
          /// link to community
          if (isOwner && linkedCommunities.isEmpty) Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: model.accentColor, width: 3),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.add, size: 28, color: model.disabledTextColor),
                  onPressed: () {

                  },
                  tooltip: 'Link Community',
                )
              ),
            ],
          ),
        const SizedBox(width: 8),
        activityForm.profileService.activityBackground.activityTitle.value.fold(
                (l) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: model.disabledTextColor.withOpacity(0.25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Add Your Title +', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                ),
                (r) => Expanded(
                  child: Text(r, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis)),
          ),
          Visibility(
            visible: isPrivate,
            child: Padding(
              padding: const EdgeInsets.only(left: 9.0),
              child: Icon(Icons.lock, color: model.paletteColor),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
    ],
  );
}


Widget getActivityBackgroundRowOne(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, ReservationItem reservation, UserProfileModel? activityOwner) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: activityForm.profileService.activityBackground.activityDescription1.value.fold(
            (l) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tell them about the what\'s in store. So far, they know Reservation was made ${getTitleForActivityOption(context, activityForm.activityType.activityId) ?? ''}, tell them how you plan to make the space into a unique experience.', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 2),
                const SizedBox(height: 8),
                Text('You also have the option to Add more details here.', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 2)
              ],
            ),
          (r) => Text(r, style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 2),
        ),
      ),
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
      reservationDatesWrapped(
          context,
          model,
          getGroupBySpaceBookings(reservation.reservationSlotItem),
      )
    ],
  );
}


Widget getActivityBackgroundRowTwo(BuildContext context, double width, DashboardModel model, bool showSuggestions, ActivityManagerForm activityForm, UserProfileModel? activityOwner, ReservationItem reservation) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: showSuggestions && activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly != true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              width: width,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: model.disabledTextColor.withOpacity(0.25)),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Align(
                child: Text('Setup Vendor Support', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
              ),
            ),
          ),
        ),
        Visibility(
          visible: showSuggestions && activityForm.profileService.activityBackground.isPartnersInviteOnly != true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              width: width,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: model.disabledTextColor.withOpacity(0.25)),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Align(
                child: Text('Setup Partnerships', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
              ),
            ),
          ),
        ),

        Visibility(
          visible: activityForm.profileService.activityBackground.isPartnersInviteOnly == true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: InkWell(
              onTap: () {
                if (activityOwner != null) {
                  presentPartnershipRequestAttendee(
                      context,
                      model,
                      reservation,
                      activityForm,
                      activityOwner
                  );
                }
              },
              child: Container(
                width: width,
                height: 60,
                decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  child: Text('Request Partnership', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: activityForm.profileService.activityBackground.isInstructorInviteOnly == true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: InkWell(
              onTap: () {
                if (activityOwner != null) {
                  presentNewInstructorAttendee(
                      context,
                      model,
                      reservation,
                      activityForm,
                      activityOwner
                  );
                }
              },
              child: Container(
                width: width,
                height: 60,
                decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  child: Text('Be an Instructor', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly == true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: InkWell(
              onTap: () {
                if (activityOwner != null) {
                  presentNewVendorAttendee(
                      context,
                      model,
                      reservation,
                      activityForm,
                      activityOwner
                  );
                }
              },
              child: Container(
                width: width,
                height: 60,
                decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  child: Text('Be a Vendor or Merchant', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                ),
              ),
            ),
          ),
        ),
        if (activityForm.profileService.activityRequirements.eventActivityRulesRequirement != null) Visibility(
            visible: (activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantLimit != null),
            child: Text('Looking for ${activityForm.profileService.activityRequirements.eventActivityRulesRequirement!.merchantLimit} Merchants or Vendors', style: TextStyle(color: model.disabledTextColor))
        ),
      ],
    );
}


Widget getActivityRequirementsColumn(BuildContext context, DashboardModel model, bool showSuggestions, bool isLessThanMain, UserProfileModel? activityOwner, ActivityManagerForm activityForm, Widget? getListOfVendors) {
  bool activityAgeSetting = activityForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !activityForm.profileService.activityRequirements.isSeventeenAndUnder;
  bool rowOneProvisions = activityForm.profileService.activityRequirements.isSeventeenAndUnder ||
      activityForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !(activityForm.profileService.activityRequirements.isSeventeenAndUnder) ||
      activityForm.profileService.activityRequirements.isMensOnly == true ||
      activityForm.profileService.activityRequirements.isWomenOnly == true ||
      activityForm.profileService.activityRequirements.isCoEdOnly == true ||
      activityForm.profileService.activityRequirements.skillLevelExpectation?.isNotEmpty == true;
  bool hasProvisions = activityForm.profileService.activityRequirements.isGearProvided == true ||
      activityForm.profileService.activityRequirements.isEquipmentProvided == true ||
      activityForm.profileService.activityRequirements.isAnalyticsProvided == true ||
      activityForm.profileService.activityRequirements.isOfficiatorProvided == true ||
      activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided == true ||
      activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided == true ||
      activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided == true;

  bool rowTwoProvisions = activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale == true ||
      hasProvisions ||
      activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale == true && activityAgeSetting;
  return Visibility(
    visible:
      rowOneProvisions ||
      hasProvisions ||
      activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale == true ||
      activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale == true && activityAgeSetting ||
      showSuggestions,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: (kIsWeb) ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Need to know More?', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
            // const SizedBox(height: 4),
            const SizedBox(height: 35),
            Divider(color: model.paletteColor),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text('Need to Know More?', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),

            if (isLessThanMain) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rowOneProvisions) Expanded(
                  child: getActivityRequirementRowOne(
                    context,
                    model,
                    showSuggestions,
                    activityForm
                  ),
                ),
                if (rowOneProvisions == false && showSuggestions) Expanded(
                  child: getActivityRequirementRowOneSuggest(context, model),
                ),
                const SizedBox(width: 15),
                if (rowTwoProvisions) getActivityRequirementRowTwo(
                  context,
                  340,
                  model,
                  showSuggestions,
                  hasProvisions,
                  activityAgeSetting,
                  activityForm
                ),
                if (rowTwoProvisions == false && showSuggestions) getActivityRequirementRowTwoSuggest(context, 340, model)
              ],
            ) else Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: rowOneProvisions,
                  child: getActivityRequirementRowOne(
                      context,
                      model,
                      showSuggestions,
                      activityForm,
                  ),
                ),
                Visibility(
                  visible: rowOneProvisions == false && showSuggestions,
                  child: getActivityRequirementRowOneSuggest(context, model),
                ),
                const SizedBox(height: 15),
                Visibility(
                  visible: rowTwoProvisions,
                  child: getActivityRequirementRowTwo(
                      context,
                      600,
                      model,
                      showSuggestions,
                      hasProvisions,
                      activityAgeSetting,
                      activityForm
                  ),
                ),
                Visibility(
                  visible: rowTwoProvisions == false && showSuggestions,
                  child: getActivityRequirementRowTwoSuggest(context, 600, model),
                )
              ],
            )


            /// events only
            /// offered/provisions, gear, food, drinks, security,
            /// vendors or merchants - invite or allow vendors to join. --- set a fee, contact details, an image (for now...), waiting lists?
            /// TODO: Show icon that says this activity supports & is looking for vendors.
            // Visibility(
            //   visible: getListOfVendors != null,
            //   child:  Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(height: 10),
            //       getListOfVendors!
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}

Widget getActivityRequirementRowOneSuggest(BuildContext context, DashboardModel model) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Some Expectations...', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize), overflow: TextOverflow.ellipsis, maxLines: 1),
      Text('For Example...', style: TextStyle(color: model.disabledTextColor)),
      const SizedBox(height: 15),
      ListTile(
        leading: Icon(Icons.info_outline, color: model.disabledTextColor),
        title: Text('For all ages', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
      ListTile(
        leading: Icon(Icons.assignment_late_outlined, color: model.disabledTextColor),
        title: Text('Please check sign for directions', style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
      /// create your expections
      Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: model.disabledTextColor.withOpacity(0.25)),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Align(
          child: Text('Create Expectations', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 1,),
        ),
      ),
    ],
  );
}

Widget getActivityRequirementRowOne(BuildContext context, DashboardModel model, bool showSuggestions, ActivityManagerForm activityForm) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Some Expectations...', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize), overflow: TextOverflow.ellipsis, maxLines: 1),
      const SizedBox(height: 15),
      Visibility(
        visible: activityForm.profileService.activityRequirements.isSeventeenAndUnder,
        child: ListTile(
          leading: Icon(Icons.info_outline, color: model.paletteColor),
          title: Text('For ages 17 and under', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
          subtitle: Text('This Activity will be catered specifically for kids'),
        ),
      ),

      Visibility(
        visible: activityForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !(activityForm.profileService.activityRequirements.isSeventeenAndUnder),
        child: ListTile(
          leading: Icon(Icons.info_outline, color: model.paletteColor),
          title: Text('Minimum age requirement ${activityForm.profileService.activityRequirements.minimumAgeRequirement}', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
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
          leading: Icon(Icons.transgender_rounded, color: model.paletteColor),
          title: Text('This Activity will be Co-Ed*', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1),
          subtitle: const Text('*This does not exclude those who Identify as Male, Female, or Trans'),
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

      const SizedBox(height: 15),
      Visibility(
          visible: showSuggestions,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: model.disabledTextColor.withOpacity(0.25)),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Align(
              child: Text('Add More Expectations', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ),
      )
    ],
  );
}

Widget getActivityRequirementRowTwoSuggest(BuildContext context, double width, DashboardModel model) {

  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What We Provide:', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize), overflow: TextOverflow.ellipsis, maxLines: 1),
        Text('For Example...', style: TextStyle(color: model.disabledTextColor)),
        const SizedBox(height: 15),
        ListTile(
          leading: Icon(Icons.sports_volleyball_outlined, color: model.disabledTextColor),
          title: Text(AppLocalizations.of(context)!.activityRequirementsCoveredJerseyGear, style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
        ListTile(
          leading: Icon(CupertinoIcons.hammer, color: model.disabledTextColor),
          title: Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
        /// create your provisions
        Container(
          width: width,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: model.disabledTextColor.withOpacity(0.25)),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Align(
            child: Text('Create Provisions', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          ),
        ),
      ],
    ),
  );
}

Widget getActivityRequirementRowTwo(BuildContext context, double width, DashboardModel model, bool showSuggestions, bool hasProvisions, bool activityAgeSetting, ActivityManagerForm activityForm) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text('What We Provide:', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize), overflow: TextOverflow.ellipsis, maxLines: 1),
        const SizedBox(height: 15),
        Visibility(
            visible: hasProvisions,
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.isGearProvided == true,
                        child: ListTile(
                          leading: Icon(Icons.sports_volleyball_outlined, color: model.paletteColor),
                          title: Text(AppLocalizations.of(context)!.activityRequirementsCoveredJerseyGear, style: TextStyle(color: model.paletteColor)),
                        )
                    ),
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.isEquipmentProvided == true,
                        child: ListTile(
                          leading: Icon(CupertinoIcons.hammer, color: model.paletteColor),
                          title: Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(color: model.paletteColor)),
                        )
                    ),
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.isAnalyticsProvided == true,
                        child: ListTile(
                          leading: Icon(Icons.bar_chart_rounded, color: model.paletteColor),
                          title: Text('Analytics & Standings', style: TextStyle(color: model.paletteColor)),
                        )
                    ),
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.isOfficiatorProvided == true,
                        child: ListTile(
                          leading: Icon(Icons.sports, color: model.paletteColor),
                          title: Text('Officiator/Referees', style: TextStyle(color: model.paletteColor)),
                        )
                    ),
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided == true && activityAgeSetting,
                        child: ListTile(
                          leading: Icon(Icons.wine_bar_outlined, color: model.paletteColor),
                          title: Text(AppLocalizations.of(context)!.activityRequirementEventAlcohol, style: TextStyle(color: model.paletteColor)),
                        )
                    ),
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided == true,
                        child: ListTile(
                          leading: Icon(Icons.fastfood_outlined, color: model.paletteColor),
                          title: Text(AppLocalizations.of(context)!.activityRequirementEventFoodOrDrink, style: TextStyle(color: model.paletteColor)),
                        )
                    ),
                    Visibility(
                        visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided == true,
                        child: ListTile(
                          leading: Icon(Icons.lock, color: model.paletteColor),
                          title: Text('Security', style: TextStyle(color: model.paletteColor)
                  ),
                )
              ),
            ],
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

        const SizedBox(height: 15),
        Visibility(
            visible: showSuggestions,
            child: Container(
              width: width,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: model.disabledTextColor.withOpacity(0.25)),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Align(
                child: Text('Add More Provisions', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ),
        ),
      ],
    ),
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
    ActivityTicketOption? selectedTicket,
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
                selectedTicket?.ticketId == activityForm.activityAttendance.defaultActivityTickets?.ticketId,
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
                          selectedTicket?.ticketId == e.ticketId,
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
                    selectedTicket?.ticketId == e.ticketId,
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

Widget getVendorAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, List<AttendeeItem> attendees, {required Function(AttendeeItem) didSelectAttendee}) {
    if (attendees.isEmpty) {
      return Container();
    }
    return ListTile(
      leading: Icon(Icons.storefront_sharp, color: model.paletteColor),
      title: Text('Vendors', style: TextStyle(color: model.paletteColor)),
      subtitle: Container(
        height: 320,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: attendees.map(
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
    );
}


Widget getPartnerAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, List<AttendeeItem> attendees, {required Function(AttendeeItem) didSelectAttendee}) {
    if (attendees.isEmpty) {
      return Container();
    }
    return ListTile(
      leading: Icon(Icons.handshake_outlined, color: model.paletteColor),
      title: Text('Partners', style: TextStyle(color: model.paletteColor)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 85,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: attendees.map(
                      (attendee) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
      ),
    );
}

Widget getInstructorAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, List<AttendeeItem> attendees, {required Function(AttendeeItem) didSelectAttendee}) {
    if (attendees.isEmpty) {
      return Container();
    }
    return Container(
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            leading: Icon(Icons.people_outline, color: model.paletteColor),
            title: Text('Instructors', style: TextStyle(color: model.paletteColor)),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: SingleChildScrollView(
                child: Column(
                  children: attendees.map(
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
      ),
    );
}
//
// Widget getAttendeesForTicketActivity(DashboardModel model, ActivityManagerForm activityForm) {
//   return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.tickets.toString(), activityForm.activityFormId.getOrCrash())),
//     child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
//       builder: (context, state) {
//         return state.maybeMap(
//           loadAllAttendanceFailure: (_) => Container(),
//           loadAllAttendanceSuccess: (item) {
//             return Row(
//               children: [
//                 Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(width: 1, color: model.disabledTextColor)
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           Icon(Icons.airplane_ticket_outlined),
//                           const SizedBox(width: 8),
//                           Text('Attending: ${item.item.length}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1,),
//                       ],
//                     ),
//                   )
//                 ),
//                 const SizedBox(width: 8),
//                 if (activityForm.activityAttendance.isTicketFixed == true) IconButton(onPressed: () {
//                 }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Tickets are limited to ${activityForm.activityAttendance.defaultActivityTickets?.ticketQuantity ?? 1} for this activity',),
//               ],
//             );
//           },
//           orElse: () => Container(),
//         );
//       },
//     ),
//   );
// }


// Widget getAttendeesForFreeActivity(DashboardModel model, ActivityManagerForm activityForm) {
//   return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.free.toString(), activityForm.activityFormId.getOrCrash())),
//     child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
//       builder: (context, state) {
//         return state.maybeMap(
//           attLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
//           loadAllAttendanceFailure: (_) => Container(),
//           loadAllAttendanceSuccess: (item) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(width: 1, color: model.disabledTextColor)
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           Icon(Icons.people_outline),
//                           const SizedBox(width: 8),
//                           Text('Attending: ${item.item.length}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1,),
//                       ],
//                     ),
//                   )
//                 ),
//                 const SizedBox(width: 8),
//                 if (activityForm.activityAttendance.isLimitedAttendance == true) IconButton(onPressed: () {
//                 }, icon: Icon(Icons.info_outline_rounded, color: model.disabledTextColor), tooltip: 'Attendance is limited to ${activityForm.activityAttendance.attendanceLimit ?? 1} for this activity',),
//               ],
//             );
//           },
//           orElse: () => Container(),
//         );
//       },
//     ),
//   );
// }

