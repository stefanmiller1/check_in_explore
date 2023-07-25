import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/activity_profile_settings_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_profile_settings/settings_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitySettingsMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final ReservationItem? reservationItem;
  final UserProfileModel? currentUser;
  final ActivityManagerForm? activityManagerForm;
  final SettingsItemModel currentNavItem;
  final Function() rebuild;
  final Function() didPresentSidePanel;

  const ActivitySettingsMainContainerWidget({super.key, required this.model, this.reservationItem, this.currentUser, this.activityManagerForm, required this.currentNavItem, required this.rebuild, required this.didPresentSidePanel});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: retrieveAuthenticationState(context)
        )
    );
  }


  Widget retrieveAuthenticationState(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
              loadProfileFailure: (_) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetLoginSignUpWidget(model: model),
              ),
              loadUserProfileSuccess: (item) => (reservationItem != null && currentUser != null && activityManagerForm != null) ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SettingsMainContainerWidget(
                      model: model,
                      userProfileModel: currentUser!,
                      activityForm: activityManagerForm!,
                      reservationItem: reservationItem!,
                      currentNavItem: currentNavItem,
                      rebuild: rebuild,
                      didPresentSidePanel: () {
                        didPresentSidePanel();
                      }
                ),
              ) : settingsFailureToLoadContainer(model),
              orElse: () {
                return JumpingDots(color: model.paletteColor, numberOfDots: 3);
              }
          );
        },
      ),
    );
  }




}