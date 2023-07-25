import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/loading_containers/loading_widgets.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_results_main.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class ReservationScreen extends StatelessWidget {

  final DashboardModel model;
  final Function(ListingManagerForm listing, ReservationItem res, UserProfileModel profile, ActivityManagerForm activityManagerForm) didSelectReservation;

  const ReservationScreen({
    super.key,
    required this.model,
    required this.didSelectReservation,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: retrieveAuthenticationState(context, Responsive.isMobile(context)),
        ),
        tablet: retrieveAuthenticationState(context, !Responsive.isMobile(context)),
        desktop: retrieveAuthenticationState(context, !Responsive.isMobile(context)),
    );
  }


  Widget retrieveAuthenticationState(BuildContext context, bool isBrowser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => emptyLoadingListView(context, isBrowser),
              loadProfileFailure: (_) => (isBrowser) ? GetLoginSignUpWidget(model: model) : emptyLoadingListView(context, true),
              loadUserProfileSuccess: (item) => SingleChildScrollView(child: Column(
                children: [
                  getInvitedToReservations(context, item.profile),
                  getAllReservations(context, item.profile),
                ],
              )),
              orElse: () {
                return emptyLoadingListView(context, isBrowser);
            }
          );
        },
      ),
    );
  }

  Widget getInvitedToReservations(BuildContext context, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations(currentUser, true)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadCurrentUserReservationsSuccess: (e) {

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invites', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                    ...e.item.map((e) => getReservationCard(
                      context,
                      false,
                      e,
                      currentUser,
                      model,
                      e.reservationState == ReservationSlotState.completed,
                      ReservationHelperCore.selectedReservationItem == e,
                      didSelectReservation: (ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity) {
                        didSelectReservation(listing, reservation, currentUser, activity);
                      },
                    )
                    ).toList(),
                  ],
                );
              },
            orElse: () => Container()
          );
        })
      );
  }

  Widget getAllReservations(BuildContext context, UserProfileModel currentUser) {
      return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations(currentUser, false)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              resLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
              loadCurrentUserReservationsSuccess: (e) {
                return Column(
                  children: [

                  if (e.item.where((element) => getNumberOfSlotsToGo(element) != 0).isEmpty) noReservationsFound(
                      model,
                      Icons.calendar_today_outlined,
                      'No Reservations Yet!',
                      'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                      'Start Booking',
                      didTapStartButton: () {
                  }),

                  if (e.item.where((element) => getNumberOfSlotsToGo(element) != 0).isNotEmpty) Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Coming-Up', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                      const SizedBox(height: 6),
                      ...e.item.where((element) => getNumberOfSlotsToGo(element) != 0).map((e) => getReservationCard(
                        context,
                        false,
                        e,
                        currentUser,
                        model,
                        false,
                        ReservationHelperCore.selectedReservationItem == e,
                        didSelectReservation: (ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity) {
                            didSelectReservation(listing, reservation, currentUser, activity);
                          },
                        )
                      ).toList(),
                    ],
                  ),

                  if (e.item.where((element) => getNumberOfSlotsToGo(element) == 0).isNotEmpty) Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Divider(color: model.disabledTextColor),
                        const SizedBox(height: 8),
                        Text('Where You Went', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                        const SizedBox(height: 6),
                        ...e.item.where((element) => getNumberOfSlotsToGo(element) == 0).map((e) => getReservationCard(
                          context,
                          false,
                          e,
                          currentUser,
                          model,
                          true,
                          ReservationHelperCore.selectedReservationItem == e,
                          didSelectReservation: (
                              ListingManagerForm listing,
                              ReservationItem reservation,
                              ActivityManagerForm activity) {
                                didSelectReservation(listing, reservation, currentUser, activity);
                            },
                          )
                        ).toList(),
                      ],
                    )
                  ]
                );
              },
              loadCurrentUserReservationsFailure: (_) => noReservationsFound(
                  model,
                  Icons.calendar_today_outlined,
                  'No Reservations Yet!',
                  'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                  'Start Booking',
                  didTapStartButton: () {
                  }
                ),
              ///TODO: add failure of type empty
              /// if network call cant be made you should not be allowed to make any new reservation
              orElse: () => noReservationsFound(
                  model,
                  Icons.calendar_today_outlined,
                  'No Reservations Yet!',
                  'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                  'Start Booking',
                  didTapStartButton: () {
                  }
                ),
          );
        },
      )
    );
  }
}