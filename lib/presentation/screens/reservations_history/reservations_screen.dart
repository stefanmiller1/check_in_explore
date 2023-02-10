import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/listing_preview/listing_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations_history/components/reservation_results_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationScreen extends StatelessWidget {

  final DashboardModel model;

  const ReservationScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: retrieveAuthenticationState(context),
        ),
        tablet: Container(),
        desktop: Container()
    );
  }


  Widget retrieveAuthenticationState(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => progressOverlay(model),
              loadProfileFailure: (_) => GetLoginSignUpWidget(model: model),
              loadUserProfileSuccess: (item) => getAllReservations(context),
              orElse: () {
                return progressOverlay(model);
            }
          );
        },
      ),
    );
  }


  Widget getAllReservations(BuildContext context) {
      return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchCurrentUsersReservations(null)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              resLoadInProgress: (_) => progressOverlay(model),
              loadCurrentUserReservationsSuccess: (e) {
                return SingleChildScrollView(
                  child: Column(
                    children: [

                    if (e.item.where((element) => getNumberOfSlotsToGo(element) != 0).isEmpty) noReservationsFound(
                        model,
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
                          e,
                          model,
                          false,
                          didSelectReservation: (ListingManagerForm listing, ReservationItem reservation) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) {
                                  return ReservationResultMain(
                                    model: model,
                                    reservation: reservation,
                                    listing: listing,
                                    );
                                  }
                                )
                              );
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
                            e,
                            model,
                            true,
                            didSelectReservation: (ListingManagerForm listing, ReservationItem reservation) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) {
                                    return ReservationResultMain(
                                      model: model,
                                      reservation: reservation,
                                      listing: listing,
                                      );
                                    }
                                  )
                                );
                              },
                            )
                          ).toList(),
                        ],
                      )
                    ]
                  ),
                );
              },
              loadCurrentUserReservationsFailure: (_) => noReservationsFound(
                  model,
                  didTapStartButton: () {
              }),
              ///TODO: add failure of type empty
              /// if network call cant be made you should not be allowed to make any new reservation
              orElse: () => noReservationsFound(
                  model,
                  didTapStartButton: () {

            })
          );
        },
      )
    );
  }
}