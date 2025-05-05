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
  final ReservationItem? initialReservation;
  // final ListingManagerForm? listingForm;
  // final ReservationItem? reservationItem;
  final UserProfileModel? currentUser;
  // final ActivityManagerForm? activityManagerForm;
  final SettingsItemModel? currentNavItem;
  final Function() rebuild;
  final Function() didPresentSidePanel;

  const ActivitySettingsMainContainerWidget({super.key, required this.model,  this.currentUser, required this.currentNavItem, required this.rebuild, required this.didPresentSidePanel, this.initialReservation});


  @override
  Widget build(BuildContext context) {
    return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
      color: model.accentColor,
      borderRadius: BorderRadius.all(Radius.circular(20))
    ),
      child: retrieveReservationSource(),
          );
  }

  Widget retrieveReservationSource() {
    if (initialReservation != null) {
      return getReservationListing(initialReservation!);
    } else {
      return settingsFailureToLoadContainer(model);
    }
  }

  Widget getReservationListing(ReservationItem reservation) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservation.instanceId.getOrCrash()))),
        BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservation.reservationId.getOrCrash()))),
        BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()))
      ],
        child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadListingManagerItemSuccess: (item) {
                  return getActivityForm(reservation, item.failure);
                },
                orElse: () => settingsFailureToLoadContainer(model)
          );
        },
      ),
    );
  }

  Widget getActivityForm(ReservationItem reservation, ListingManagerForm listingForm) {
    return BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
            loadActivityManagerFormSuccess: (item) {
              return getMainContainer(reservation, listingForm, item.item);
            },
            orElse: () => getMainContainer(reservation, listingForm, ActivityManagerForm.empty())
        );
      },
    );
  }

  Widget getMainContainer(ReservationItem reservation, ListingManagerForm listingForm, ActivityManagerForm activityManagerForm) {
    return BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
      builder: (context, authState) {
        return authState.maybeMap(
            loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
            loadProfileFailure: (_) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetLoginSignUpWidget(showFullScreen: true, model: model, didLoginSuccess: () {  },),
            ),
            loadUserProfileSuccess: (item) {
                if (reservation.reservationOwnerId == item.profile.userId) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SettingsMainContainerWidget(
                        model: model,
                        userProfileModel: item.profile,
                        activityForm: activityManagerForm,
                        reservationItem: reservation,
                        listingForm: listingForm,
                        currentNavItem: currentNavItem,
                        rebuild: rebuild,
                        didPresentSidePanel: () {
                          didPresentSidePanel();
                        }
                    ),
                  );
                } else {
                  return retrieveCurrentAttendee(reservation, activityManagerForm, item.profile);
                }
            },
            orElse: () {
              return JumpingDots(color: model.paletteColor, numberOfDots: 3);
            }
        );
      },
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