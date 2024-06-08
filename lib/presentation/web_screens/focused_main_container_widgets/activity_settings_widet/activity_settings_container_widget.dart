import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/activity_attendee_settings_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/activity_owner_settings_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitySettingsMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final ReservationItem? reservationItem;
  final UserProfileModel? currentUser;
  final ActivityManagerForm? activityManagerForm;
  final SettingsItemModel? currentNavItem;
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
                child: GetLoginSignUpWidget(showFullScreen: true, model: model, didLoginSuccess: () {  },),
              ),
              loadUserProfileSuccess: (item) {
                  if (reservationItem != null && activityManagerForm != null) {
                      if (reservationItem?.reservationOwnerId == item.profile.userId) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SettingsMainContainerWidget(
                                  model: model,
                                  userProfileModel: item.profile,
                                  activityForm: activityManagerForm!,
                                  reservationItem: reservationItem!,
                                  currentNavItem: currentNavItem,
                                  rebuild: rebuild,
                                  didPresentSidePanel: () {
                                    didPresentSidePanel();
                                  }
                              ),
                            );
                        } else {
                         return retrieveCurrentAttendee(reservationItem!, activityManagerForm!, item.profile);
                      }
                    }
                  return settingsFailureToLoadContainer(model);
                },
              orElse: () {
                return JumpingDots(color: model.paletteColor, numberOfDots: 3);
              }
          );
        },
      ),
    );
  }


  Widget retrieveCurrentAttendee(ReservationItem reservationItem, ActivityManagerForm activityManagerForm, UserProfileModel user) {
    return BlocProvider(create: (_) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(reservationItem.reservationId.getOrCrash(), user.userId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadAttendeeItemSuccess: (item) {
              return ActivityAttendeeSettingsMainContainerWidget(
                  model: model,
                  activityManagerForm: activityManagerForm,
                  attendeeItem: item.item,
                  userProfileModel: user,
                  reservationItem: reservationItem,
                  currentNavItem: currentNavItem
              );
            },
            orElse: () => settingsFailureToLoadContainer(model),
          );
        },
      ),
    );
  }
  
}