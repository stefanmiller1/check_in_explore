import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

Widget reservationInviteNotificationTitle(DashboardModel model, Widget title, int notificationCount) {
  if (notificationCount != 0) {
    return badges.Badge(
        position: badges.BadgePosition.custom(end: -25, top: -5),
        showBadge: true,
        badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
        badgeContent: Text(notificationCount.toString(), style: TextStyle(color: model.accentColor)),
        child: title
      );
    } else {
    return title;
  }
}
