// import 'dart:ui';

// import 'package:avatar_stack/avatar_stack.dart';
// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// top header component - reservation details, title, join, create, message, watching, participating/members, likes
/// feed
/// each created post or res/listing update - leading with automated widgets based on upcoming, past and current reservations?
/// create feed posts in-between (posts can be: polls, images (bereal, snapchat, story), chat/thread, leaderboard


// Widget flexibleReservationProfileHeader(BuildContext context, DashboardModel model, Widget mainTitleWidget, ReservationItem reservationItem, ListingManagerForm listing) {
//
//
//   return FlexibleSpaceBar(
//     collapseMode: CollapseMode.parallax,
//     centerTitle: true,
//     stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
//     title: mainTitleWidget,
//     background: Container(
//       foregroundDecoration: BoxDecoration(
//         color: model.paletteColor.withOpacity(0.25),
//       ),
//       child: PageView.builder(
//           itemCount: retrieveReservationSpacesFromListing(reservationItem, listing).length,
//           itemBuilder: (_, index) {
//             final SpaceOptionSizeDetail reservationSpace = retrieveReservationSpacesFromListing(reservationItem, listing)[index];
//
//             if (reservationSpace.photoUri != null) {
//               return CachedNetworkImage(
//                 imageUrl: reservationSpace.photoUri ?? '',
//
//               );
//               return Image(image: reservationSpace.spacePhoto!.image, fit: BoxFit.cover);
//             }
//            return  getActivityTypeTabOption(
//                 context,
//                 model,
//                 200,
//                 false,
//                 getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
//             );
//         }
//       ),
//     ),
//     expandedTitleScale: 1,
//   );
// }
