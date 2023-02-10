import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget profileHeaderContainer(UserProfileModel profile, DashboardModel model, bool isCurrentUser, int listingCount, int reservationCount, {required Function() editProfile}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (profile.profileImage != null) ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: SizedBox(
              height: 80,
              width: 80,
              child: Image(image: profile.profileImage!.image, fit: BoxFit.cover),
            ),
          ),
          if (profile.profileImage == null) Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Center(child: Text(profile.legalName.getOrCrash()[0], style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize))),
              ),
              if (profile.isEmailAuth) Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: model.webBackgroundColor
                  ),
                  child: Icon(Icons.verified, color: Colors.deepOrange, size: 20),
                ),
              )
            ],
          ),

          Row(
            children: [
              Column(
                children: [
                  Icon(Icons.home_outlined, color: model.paletteColor),
                  Text('Hosting'),
                  Text(listingCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(width: 14),
              Column(
                children: [
                  Icon(Icons.calendar_today_outlined, color: model.paletteColor),
                  Text('Reservations'),
                  Text(reservationCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(width: 14),
              Column(
                children: [
                  Icon(Icons.accessibility_new_rounded, color: model.paletteColor),
                  Text('Joined')
                ],
              )
            ],
          )
        ],
      ),
      SizedBox(height: 12),
      Text(profile.legalName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
      SizedBox(height: 2),
      Text('Joined in ${DateFormat.y().format(profile.joinedDate)}', style: TextStyle(color: model.disabledTextColor)),
      SizedBox(height: 12),

      if (isCurrentUser) InkWell(
        onTap: () {
          editProfile();
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: model.accentColor
          ),
          child: Center(
            child: Text('Edit Profile', style: TextStyle(color: model.paletteColor)),
          ),
        ),
      )
    ],
  );
}


Widget verificationsAndConfirmations(DashboardModel model, UserProfileModel profile) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text('Confirmations', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 18),
      if (profile.isPhoneAuth && profile.isEmailAuth) Row(
        children: [
          Icon(Icons.verified, color: model.paletteColor,),
          const SizedBox(width: 8),
          Text('Verified Identity', style: TextStyle(color: model.paletteColor))
        ],
      ),
      if (profile.isPhoneAuth && !profile.isEmailAuth || !profile.isPhoneAuth && profile.isEmailAuth || !profile.isPhoneAuth && !profile.isEmailAuth) Row(
        children: [
          Icon(Icons.verified_outlined, color: model.disabledTextColor),
          const SizedBox(width: 8),
          Text('Identity Not Yet Verified', style: TextStyle(color: model.disabledTextColor))
        ],
      ),
      const SizedBox(height: 12),
      if (profile.isPhoneAuth) Row(
        children: [
          Icon(Icons.info, color: model.paletteColor,),
          const SizedBox(width: 8),
          Text('Verified Phone Number', style: TextStyle(color: model.paletteColor))
        ],
      ),
      if (!profile.isPhoneAuth) Row(
        children: [
          Icon(Icons.info, color: model.disabledTextColor,),
          const SizedBox(width: 8),
          Text('Phone Number Not Yet Verified', style: TextStyle(color: model.disabledTextColor))
        ],
      ),

      const SizedBox(height: 12),
      if (profile.isEmailAuth) Row(
        children: [
          Icon(Icons.privacy_tip, color: model.paletteColor,),
          const SizedBox(width: 8),
          Text('Verified Email', style: TextStyle(color: model.paletteColor))
        ],
      ),
      if (!profile.isEmailAuth) Row(
        children: [
          Icon(Icons.privacy_tip, color: model.disabledTextColor,),
          const SizedBox(width: 8),
          Text('Email Not Yet Verified', style: TextStyle(color: model.disabledTextColor))
        ],
      ),

    ],
  );
}

Widget getHostingListings(BuildContext context, UserProfileModel profile, List<ListingManagerForm> listings, DashboardModel model) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${profile.legalName.getOrCrash()}\'s Listings', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
        const SizedBox(height: 18),
        if (listings.isEmpty) Container(
          // height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.home_outlined, color: model.disabledTextColor),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No Listings Yet!', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                      const SizedBox(height: 8),
                      Text('Make your space available for any activity you\'d like to support, if the space is yours let people temporarily co-opt it into their needs.', style: TextStyle(color: model.disabledTextColor)),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),

      ],
    ),
  );
}

Widget getUpComingReservations(BuildContext context, UserProfileModel profile, List<ReservationItem> reservations, DashboardModel model) {
  return Container(
    height: 150,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${profile.legalName.getOrCrash()}\'s Reservations', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
        const SizedBox(height: 18),

        if (reservations.isEmpty) Container(
          // height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.event, color: model.disabledTextColor),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No Reservations Yet', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                      const SizedBox(height: 8),
                      Text('Start a Pop-Up Shop in your backyard or rent out a studio space to work out of for the night', style: TextStyle(color: model.disabledTextColor)),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),

        if (reservations.isNotEmpty) Expanded(
          child: PageView.builder(
              itemCount: reservations.length,
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              itemBuilder: (_, index) {
                final ReservationItem reservation = reservations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: getReservationCard(
                    context,
                    reservation,
                    model,
                    reservation.reservationSlotItem.map((e) => e.selectedDate).where((element) => element.isBefore(DateTime.now())).isNotEmpty,
                    didSelectReservation: (listing, reservation) {

                  }
                ),
              );
            }
          ),
        )
      ],
    ),
  );
}


// Widget getConversations(List<> profile, DashboardModel model) {
//   return Column(
//     children: [
//       Text('Conversations', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
//
//     ],
//   );
// }