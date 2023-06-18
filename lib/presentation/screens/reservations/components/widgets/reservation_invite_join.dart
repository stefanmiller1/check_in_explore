import 'dart:ui';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getInviteToJoinWidget(BuildContext context, DashboardModel model, UserProfileModel resOwner, {required Function didSelectJoinBooking, required Function didSelectCancel}) {
  return ClipRRect(
      child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        /// review reservation
        /// show res owner
        color: Colors.grey.shade200.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: Padding(
          
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
                const SizedBox(height: 15),
                /// res owner
                CircleAvatar(
                  radius: 30,
                  backgroundImage: resOwner.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image,
                ),
                const SizedBox(height: 10),
                Text('${resOwner.legalName.getOrCrash()} wants you to Join their Reservation'),
                const SizedBox(height: 25),
                InkWell(
                    onTap: () {
                      didSelectJoinBooking();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: model.paletteColor,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Center(child: Text('Join Booking', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      didSelectCancel();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: model.accentColor,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Center(child: Text('Go Back', style: TextStyle(color: model.paletteColor ))),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    )
  );
}