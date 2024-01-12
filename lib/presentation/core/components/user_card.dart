import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/edit_selected_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget getSingleUserCard() {
  return Container();
}

Widget getMultiUserCard() {
  return Container();
}

Widget getOrganizationWithUsersCard() {
  return Container();
}

Widget getHostColumn(BuildContext context, UserProfileModel hostProfile, DashboardModel model) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Hosted By ${hostProfile.legalName.getOrCrash()}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 2,),
                Text('Joined ${DateFormat.MMMM().format(hostProfile.joinedDate)} ${DateFormat.y().format(hostProfile.joinedDate)}', style: TextStyle(color: model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1),
              ],
            ),
          ),
          if (hostProfile.profileImage != null) CircleAvatar(radius: 30, foregroundImage: (hostProfile.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image)),
          if (hostProfile.profileImage == null) Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: model.paletteColor)
            ),
            child: Center(
              child: Text(hostProfile.legalName.getOrCrash()[0], style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize)),
            ),
          ),
        ],
      ),
      /// include organization if exists, and all listing owners

      const SizedBox(height: 14),
      Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                if (hostProfile.isEmailAuth && hostProfile.isPhoneAuth) Row(
                  children: [
                    Icon(Icons.verified, color: model.paletteColor,),
                    const SizedBox(width: 6),
                    Text('Verified Listing Host', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                  ],
                ),
                if (!(hostProfile.isEmailAuth && hostProfile.isPhoneAuth)) Row(
                  children: [
                    Icon(Icons.verified_outlined, color: model.disabledTextColor),
                    const SizedBox(width: 6),
                    Text('Host is not yet Verified', style: TextStyle(color: model.disabledTextColor),)
                  ],
                )

              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: model.disabledTextColor),
                    const SizedBox(width: 6),
                    Text('No Reviews Yet', style: TextStyle(color: model.disabledTextColor))
                  ],
                )
              ],
            )
          ],
        ),
      ),
      const SizedBox(height: 16),
      Text('Response Rate: --', style: TextStyle(color: model.paletteColor)),
      const SizedBox(height: 8),
      Text('Response Time: --', style: TextStyle(color: model.paletteColor)),

      const SizedBox(height: 18),
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ReviewCurrentProfile(
                currentUser: hostProfile,
                model: model,
                didSelectEditProfile: (profile) {

                },
              );
            })
          );
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: model.paletteColor, width: 0.5)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Contact Now', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))),
          ),
        ),
      ),
      const SizedBox(height: 18),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_rounded, color: model.disabledTextColor),
          const SizedBox(width: 4),
          Expanded(
              child: Text('To protect all payments between you and the host, never send or transfer money outside of the CICO app or website.', style: TextStyle(color: model.disabledTextColor)))
        ],
      ),
    ],
  );
}