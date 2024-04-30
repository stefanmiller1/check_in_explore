import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';

class ProfileMainContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;

  const ProfileMainContainerWidget({super.key, required this.model, required this.currentUser});

  @override
  State<ProfileMainContainerWidget> createState() => _ProfileMainContainerWidgetState();
}

class _ProfileMainContainerWidgetState extends State<ProfileMainContainerWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: widget.model.accentColor,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: ReviewCurrentProfile(
          currentUser: widget.currentUser,
          model: widget.model,
          didSelectEditProfile: (profile) {

          },
          showBack: true,
        )
      )
    );
  }
}