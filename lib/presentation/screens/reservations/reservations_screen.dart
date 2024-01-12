import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
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
  final UniqueId? initialReservationId;
  final Function(ListingManagerForm listing,
      ReservationItem res,
      UserProfileModel profile,
      ActivityManagerForm activityManagerForm,
      AttendeeItem? attendeeItem,
      List<TicketItem> currentUsersTickets) didSelectReservation;

  const ReservationScreen({
    super.key,
    required this.model,
    required this.didSelectReservation,
    this.initialReservationId,
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
                    getCurrentReservations(context, item.profile),
                    getInvitationBasedReservations(context, item.profile),
                    Divider(color: model.accentColor),
                    getConfirmedReservations(context, item.profile),
                    getCompletedReservations(context, item.profile),
                  ],
                )
              ),
              orElse: () {
                return emptyLoadingListView(context, isBrowser);
            }
          );
        },
      ),
    );
  }


  Widget getInvitationBasedReservations(BuildContext context, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchProfileAllAttendingResStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadProfileAttendingResSuccess: (e) {

                final List<AttendeeItem> invitedRes = e.attending.where((e) => e.contactStatus == ContactStatus.invited).toList();
                final List<AttendeeItem> joinedRes = e.attending.where((e) => e.contactStatus == ContactStatus.joined).toList();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: joinedRes.isNotEmpty,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Text('Joined', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                            ...joinedRes.map(
                                    (f) {
                                  return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(f.reservationId.getOrCrash())),
                                      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
                                        builder: (context, state) {
                                          return state.maybeWhen(
                                              loadReservationItemSuccess: (res) {
                                                if (res.reservationOwnerId != currentUser.userId) {
                                                  return getReservationCardListing(
                                                    context,
                                                    false,
                                                    res,
                                                    currentUser,
                                                    model,
                                                    res.reservationState == ReservationSlotState.completed,
                                                    initialReservationId == res.reservationId || ReservationHelperCore.selectedReservationItem == res,
                                                    didSelectReservation: (
                                                        ListingManagerForm listing,
                                                        ReservationItem reservation,
                                                        ActivityManagerForm activity,
                                                        AttendeeItem? attendeeItem,
                                                        List<TicketItem> currentUsersTickets) {

                                                      didSelectReservation(listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets);
                                                },
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                      orElse: () => Container()
                                    );
                                  },
                                )
                              );
                            }
                          )
                        ],
                      )
                    ),

                    Visibility(
                        visible: invitedRes.isNotEmpty,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Invites', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                            ...invitedRes.map(
                                    (f) {
                                  return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(f.reservationId.getOrCrash())),
                                      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
                                        builder: (context, state) {
                                          return state.maybeWhen(
                                              loadReservationItemSuccess: (res) {
                                                return getReservationCardListing(
                                                  context,
                                                  false,
                                                  res,
                                                  currentUser,
                                                  model,
                                                  res.reservationState == ReservationSlotState.completed,
                                                  initialReservationId == res.reservationId || ReservationHelperCore.selectedReservationItem == res,
                                                  didSelectReservation: (
                                                      ListingManagerForm listing,
                                                      ReservationItem reservation,
                                                      ActivityManagerForm activity,
                                                      AttendeeItem? attendeeItem,
                                                      List<TicketItem> currentUsersTickets) {

                                                    didSelectReservation(listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets);
                                              },
                                            );
                                          },
                                          orElse: () => Container()
                                      );
                                    },
                                  )
                                );
                              }
                            )
                          ],
                        )
                    ),

                  ],
                );
              },
          orElse: () => Container()
        );
      })
    );
  }

  Widget getCurrentReservations(BuildContext context, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current], currentUser, false)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
      return state.maybeMap(
          resLoadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
          loadCurrentUserReservationsSuccess: (e) {
              /// happening now!
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    if (e.item.isEmpty) noItemsFound(
                    model,
                    Icons.calendar_today_outlined,
                    'No Reservations Yet!',
                    'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                    'Start Booking',
                    didTapStartButton: () {
                    }),

                    if (e.item.isNotEmpty) Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: model.paletteColor, width: 1),
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text('Happening Now!', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                              const SizedBox(height: 6),
                              ...e.item.map((e) => getReservationCardListing(
                                context,
                                false,
                                e,
                                currentUser,
                                model,
                                false,
                                initialReservationId == e.reservationId || ReservationHelperCore.selectedReservationItem == e,
                                didSelectReservation: (
                                    ListingManagerForm listing,
                                    ReservationItem reservation,
                                    ActivityManagerForm activity,
                                    AttendeeItem? attendeeItem,
                                    List<TicketItem> currentUsersTickets) {
                                    didSelectReservation(listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets);
                                  },
                                )
                              ).toList(),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ]
                );
            },
            orElse: () => noItemsFound(
                model,
                Icons.calendar_today_outlined,
                'No Reservations Yet!',
                'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                'Start Booking',
                didTapStartButton: () {
                }),
          );
        }
      )
    );
  }


  Widget getConfirmedReservations(BuildContext context, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.confirmed], currentUser, false)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadCurrentUserReservationsSuccess: (e) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Coming-Up', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                      const SizedBox(height: 6),
                      ...e.item.map((e) => getReservationCardListing(
                        context,
                        false,
                        e,
                        currentUser,
                        model,
                        false,
                        initialReservationId == e.reservationId || ReservationHelperCore.selectedReservationItem == e,
                        didSelectReservation: (
                            ListingManagerForm listing,
                            ReservationItem reservation,
                            ActivityManagerForm activity,
                            AttendeeItem? attendeeItem,
                            List<TicketItem> currentUsersTickets) {
                          didSelectReservation(listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets);
                        },
                      )
                    ).toList(),
                  ]
                );
              },
            orElse: () => Container()
          );
        }
      )
    );
  }


  // ReservationHelperCore.selectedReservationItem
  Widget getCompletedReservations(BuildContext context, UserProfileModel currentUser) {
      return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.completed], currentUser, false)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              loadCurrentUserReservationsSuccess: (e) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Divider(color: model.disabledTextColor),
                    const SizedBox(height: 8),
                    Text('Where You Went', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                    const SizedBox(height: 6),
                    ...e.item.map((e) => getReservationCardListing(
                      context,
                      false,
                      e,
                      currentUser,
                      model,
                      true,
                      initialReservationId == e.reservationId || ReservationHelperCore.selectedReservationItem == e,
                      didSelectReservation: (
                          ListingManagerForm listing,
                          ReservationItem reservation,
                          ActivityManagerForm activity,
                          AttendeeItem? attendeeItem,
                          List<TicketItem> currentUsersTickets,
                          ) {
                        didSelectReservation(listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets);
                      },
                    )
                    ).toList(),
                  ]
                );
              },
              ///TODO: add failure of type empty
              /// if network call cant be made you should not be allowed to make any new reservation
              orElse: () => Container()
          );
        },
      )
    );
  }
}