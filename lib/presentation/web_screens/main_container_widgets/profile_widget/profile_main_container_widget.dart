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
    return ProfileMainContainer(
        model: widget.model,
        currentUserId: widget.currentUser.userId.getOrCrash(),
        currentUserProfile: widget.currentUser,
    );
  }
}