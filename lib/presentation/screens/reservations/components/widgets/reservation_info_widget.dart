import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ReservationInfoWidget extends StatelessWidget {

  const ReservationInfoWidget({super.key,
    required this.model,
    required this.reservationItem,
    required this.listing,
    required this.users,
    required this.isOwner,
    required this.didSelectAllParticipants,
    required this.didSelectNewInvite
  });

  final DashboardModel model;
  final ListingManagerForm listing;
  final ReservationItem reservationItem;
  final List<UserProfileModel> users;
  final bool isOwner;
  final Function() didSelectAllParticipants;
  final Function() didSelectNewInvite;

  @override
  Widget build(BuildContext context) {

    final Iterable<ContactDetails> affiliatedJoined = reservationItem.reservationAffiliates?.where((element) => element.contactStatus == ContactStatus.joined) ?? [];
    final affiliatedUsersProfiles = users.where((element) => (affiliatedJoined.map((e) => e.contactId).contains(element.userId)));
    final todayReservation = reservationItem.reservationSlotItem.where((element) => element.selectedDate.isSameDay(element.selectedDate, DateTime.now()));


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        SizedBox(
          height: 285,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: PageView.builder(
                itemCount: retrieveReservationSpacesFromListing(reservationItem, listing).length,
                itemBuilder: (_, index) {
                  final SpaceOptionSizeDetail reservationSpace = retrieveReservationSpacesFromListing(reservationItem, listing)[index];

                  if (reservationSpace.spacePhoto != null) {
                    return Image(image: reservationSpace.spacePhoto!.image, fit: BoxFit.cover);
                  }
                  return  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: getActivityTypeTabOption(
                          context,
                          model,
                          100,
                          false,
                          getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                      ),
                    ),
                  );
                }
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('Opened On ${DateFormat.MMMMd().format(listing.listingProfileService.backgroundInfoServices.startEndDate.start)}', style: TextStyle(color: model.disabledTextColor),),
              FutureBuilder<double?>(
                  future: MapHelper.determineDistanceAway(LatLng(listing.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listing.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0)),
                  initialData: 0,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Row(
                        children: [
                          Text('Around ${snap.data?.toInt()}m away •', style: TextStyle(color: model.disabledTextColor)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(' -- slots this week', style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1,)
                          )
                        ],
                      );
                    }
                    return Container();
                  }),
              const SizedBox(height: 5),
              Text(listing.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on_outlined, color: model.paletteColor),
          title: Text('${listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${listing.listingProfileService.listingLocationSetting.countryRegion}'),
          subtitle: Text('Facility Location'),
        ),
        const SizedBox(height: 5),
        Divider(color: model.paletteColor),
        const SizedBox(height: 5),
        // Row(
        //   children: [
        //     if (isOwner) Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 border: Border.all(color: model.disabledTextColor, width: 1.5),
        //                 borderRadius: BorderRadius.circular(30)
        //             ),
        //             child: IconButton(
        //               padding: EdgeInsets.zero,
        //               onPressed: () {
        //                 didSelectNewInvite();
        //               },
        //               icon: Icon(Icons.add, color: model.disabledTextColor),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(height: 10),
        //         Text('Send Invites', style: TextStyle(color: model.disabledTextColor.withOpacity(0.8), fontSize: 13.5, fontWeight: FontWeight.bold)),
        //
        //         // Text('Send Invites', style: TextStyle(color: model.paletteColor, fontSize: 15, fontWeight: FontWeight.bold)),
        //       ],
        //     ),

        //     if (affiliatedUsersProfiles.isNotEmpty) Expanded(
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             InkWell(
        //               onTap: () {
        //                 didSelectAllParticipants();
        //               },
        //               child: AvatarStack(
        //                 height: 50,
        //                 width: MediaQuery.of(context).size.width,
        //                 infoWidgetBuilder: (surplus) {
        //                   return InkWell(
        //                     onTap: () {
        //                       didSelectAllParticipants();
        //                     },
        //                     child: Container(
        //                       height: 50,
        //                       width: 50,
        //                       decoration: BoxDecoration(
        //                           color: model.accentColor,
        //                           borderRadius: BorderRadius.circular(50)
        //                       ),
        //                       child: Center(
        //                         child: Text('+$surplus', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
        //                       ),
        //                     ),
        //                   );
        //                 },
        //                 avatars: [
        //                   if (affiliatedUsersProfiles.isNotEmpty) for (var n = 0; n < affiliatedUsersProfiles.length; n++) (affiliatedUsersProfiles.toList()[n].profileImage != null) ? affiliatedUsersProfiles.toList()[n].profileImage!.image : Image.asset('assets/profile-avatar.png').image
        //                 ],
        //               ),
        //             ),
        //             const SizedBox(height: 10),
        //             if (affiliatedUsersProfiles.isNotEmpty) Center(child: Text('Participating: ${affiliatedUsersProfiles.length} Guests', style: TextStyle(color: model.disabledTextColor.withOpacity(0.8), fontSize: 13.5, fontWeight: FontWeight.bold))),
        //
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 10),
        // if (isOwner) Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Row(
        //           children: [
        //             Icon(Icons.chat_bubble_outline_outlined, color: model.paletteColor),
        //             const SizedBox(width: 18.0),
        //             Text('Message Host', style: TextStyle(color: model.paletteColor)),
        //           ],
        //         ),
        //       ),
        //       const SizedBox(width: 10),
        //       Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor)
        //     ],
        //   ),
        // ),
        // Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //             child: Row(
        //               children: [
        //                 Icon(Icons.home_outlined, color: model.paletteColor),
        //                 const SizedBox(width: 18.0),
        //                 Column(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text('Show Listing', style: TextStyle(color: model.paletteColor)),
        //                     Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: model.disabledTextColor))
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //       Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor)
        //     ]
        //   )
        // ),

        ListTile(
          leading: Icon(Icons.calendar_today_outlined, color: model.paletteColor),
          title: Text('Dates Booked', style: TextStyle(color: model.paletteColor)),
          trailing: (reservationItem.reservationState == ReservationSlotState.completed) ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: model.paletteColor
              ),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Completed', style: TextStyle(color: model.accentColor, fontSize: 14, fontWeight: FontWeight.bold,))
              )
          ) : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: model.accentColor
              ),
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.disabledTextColor, fontSize: 14, fontWeight: FontWeight.bold,)) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontSize: 14, fontWeight: FontWeight.bold,))
              )),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Row(
        //           children: [
        //             Icon(Icons.calendar_today_outlined, color: model.paletteColor),
        //             const SizedBox(width: 18.0),
        //             Text('Dates Booked', style: TextStyle(color: model.paletteColor)),
        //           ],
        //         ),
        //       ),
        //
        //       const SizedBox(width: 10),
        //       if (reservationItem.reservationState == ReservationSlotState.completed) Container(
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(50),
        //             color: model.paletteColor
        //         ),
        //         child: Padding(
        //             padding: const EdgeInsets.all(4.0),
        //             child: Text('Completed', style: TextStyle(color: model.accentColor, fontSize: 14, fontWeight: FontWeight.bold,))
        //           )
        //         ),
        //       if (reservationItem.reservationState != ReservationSlotState.completed) Container(
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(50),
        //               color: model.accentColor
        //           ),
        //           child: Padding(
        //               padding: const EdgeInsets.all(4.0),
        //               child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.disabledTextColor, fontSize: 14, fontWeight: FontWeight.bold,)) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontSize: 14, fontWeight: FontWeight.bold,))
        //           )),
        //     ],
        //   ),
        // ),
        /// message host


        const SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 470
                ),
                child: viewListOfSelectedSlots(
                    context,
                    model,
                    [],
                    reservationItem.reservationSlotItem,
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }

}