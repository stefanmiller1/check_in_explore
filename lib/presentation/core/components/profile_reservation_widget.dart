import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// top header component - reservation details, title, join, create, message, watching, participating/members, likes
/// feed
/// each created post or res/listing update - leading with automated widgets based on upcoming, past and current reservations?
/// create feed posts in-between (posts can be: polls, images (bereal, snapchat, story), chat/thread, leaderboard


Widget flexibleReservationProfileHeader(BuildContext context, DashboardModel model, ReservationItem reservationItem, ListingManagerForm listing, bool isOwner, List<UserProfileModel> users, {required Function didSelectNewInvite, required Function didSelectAllParticipants}) {

  final Iterable<ContactDetails> affiliatedJoined = reservationItem.reservationAffiliates?.where((element) => element.contactStatus == ContactStatus.joined) ?? [];

  final affiliatedUsersProfiles = users.where((element) => (affiliatedJoined.map((e) => e.contactId).contains(element.userId)));
  final todayReservation = reservationItem.reservationSlotItem.where((element) => element.selectedDate.isSameDay(element.selectedDate, DateTime.now()));
  final nextReservationSlot = reservationItem.reservationSlotItem.where((element) => element.selectedDate.isAfter(DateTime.now()));

  return FlexibleSpaceBar(
    collapseMode: CollapseMode.parallax,
    centerTitle: true,
    stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],

    title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Container(
            // height: 325,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: getActivityFromSelectedReservation(reservationItem.reservationSlotItem).map(
                            (e) => getActivityTabForReservation(
                                context,
                                model,
                                getActivityOptions(context).firstWhere((element) => element.activityId == e
                        )
                      ),
                    ).toList()
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (isOwner) Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: model.accentColor, width: 1.5),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                didSelectNewInvite();
                              },
                              icon: Icon(Icons.add, color: model.accentColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Send Invites', style: TextStyle(color: model.accentColor.withOpacity(0.8), fontSize: 13.5, fontWeight: FontWeight.bold)),

                        // Text('Send Invites', style: TextStyle(color: model.paletteColor, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                didSelectAllParticipants();
                              },
                              child: AvatarStack(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                infoWidgetBuilder: (surplus) {
                                  return InkWell(
                                    onTap: () {
                                      didSelectAllParticipants();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: model.accentColor,
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Center(
                                        child: Text('+$surplus', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                                      ),
                                    ),
                                  );
                                },
                                avatars: [
                                  if (affiliatedUsersProfiles.isNotEmpty) for (var n = 0; n < affiliatedUsersProfiles.length; n++) (affiliatedUsersProfiles.toList()[n].profileImage != null) ? affiliatedUsersProfiles.toList()[n].profileImage!.image : Image.asset('assets/profile-avatar.png').image
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (affiliatedUsersProfiles.isNotEmpty) Center(child: Text('Participating: ${affiliatedUsersProfiles.length} Guests', style: TextStyle(color: model.accentColor.withOpacity(0.8), fontSize: 13.5, fontWeight: FontWeight.bold))),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 18),
                /// mini calendar view - show next booking date if booking has not completed yet.
                if (reservationItem.reservationState != ReservationSlotState.completed) Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.calendar_today_outlined, color: model.accentColor),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Dates Booked', style: TextStyle(fontSize: 15, color: model.accentColor))),
                    const SizedBox(width: 10),
                    if (reservationItem.reservationState != ReservationSlotState.completed) Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: model.accentColor
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.paletteColor, fontSize: 14, fontWeight: FontWeight.bold,)) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontSize: 14, fontWeight: FontWeight.bold,))
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                /// paging listview
                if (todayReservation.isNotEmpty) viewListOfSelectedSlots(
                  context,
                  model,
                  [],
                  todayReservation.toList(),
                  reservationItem.cancelledSlotItem ?? [],
                  false,
                    AppLocalizations.of(context)!.profileFacilitySlotTime,
                    AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                    AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                    listing,
                    didSelectReservation: (e) {
                    },
                    didSelectCancelResSlot: (e, f) {
                    },
                    didSelectRemoveResSlot: (e, f) {
                  }
                ),

                if (todayReservation.isEmpty && nextReservationSlot.isNotEmpty) viewListOfSelectedSlots(
                    context,
                    model,
                    [],
                    nextReservationSlot.toList(),
                    reservationItem.cancelledSlotItem ?? [],
                    false,
                    AppLocalizations.of(context)!.profileFacilitySlotTime,
                    AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                    AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                    listing,
                    didSelectReservation: (e) {
                    },
                    didSelectCancelResSlot: (e, f) {
                    },
                    didSelectRemoveResSlot: (e, f) {
                  }
                ),
                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
        ),
      ),
    background: Container(
      foregroundDecoration: BoxDecoration(
        color: model.paletteColor.withOpacity(0.25),
      ),
      child: PageView.builder(
          itemCount: retrieveReservationSpacesFromListing(reservationItem, listing).length,
          itemBuilder: (_, index) {
            final SpaceOptionSizeDetail reservationSpace = retrieveReservationSpacesFromListing(reservationItem, listing)[index];

            if (reservationSpace.spacePhoto != null) {
              return Image(image: reservationSpace.spacePhoto!.image, fit: BoxFit.cover);
            }
           return  getActivityTypeTabOption(
                context,
                model,
                200,
                false,
                getActivityOptions(context).firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
            );
        }
      ),
    ),
    expandedTitleScale: 1,
  );
}
