import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:flutter/material.dart';

/// top header component - reservation details, title, join, create, message, watching, participating/members, likes
/// feed
/// each created post or res/listing update - leading with automated widgets based on upcoming, past and current reservations?
/// create feed posts in-between (posts can be: polls, images (bereal, snapchat, story), chat/thread, leaderboard


Widget flexibleReservationProfileHeader(BuildContext context, DashboardModel model, ReservationItem reservationItem, ListingManagerForm listing) {
  print(retrieveReservationSpacesFromListing(reservationItem, listing).length);
  return FlexibleSpaceBar(
    collapseMode: CollapseMode.parallax,
    centerTitle: true,
    stretchModes: [StretchMode.blurBackground, StretchMode.zoomBackground],
    title: Text('Title Here'),
    background: PageView.builder(
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
          return Image(image: reservationSpace.spacePhoto!.image);
      }
    ),
    expandedTitleScale: 1,
  );
}

