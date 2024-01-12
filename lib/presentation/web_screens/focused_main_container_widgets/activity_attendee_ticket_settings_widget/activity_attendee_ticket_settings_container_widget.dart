import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/activity_tickets/activity_attendee_ticket_results_main.dart';

class ActivityAttendeeTicketSettingMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final List<TicketItem> attendeeTickets;
  final ReservationItem? reservationItem;
  final ActivityManagerForm? activityManagerForm;
  final Function() rebuild;

  const ActivityAttendeeTicketSettingMainContainerWidget({super.key, required this.model, required this.reservationItem, required this.activityManagerForm, required this.rebuild, required this.attendeeTickets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!(kIsWeb)) ? AppBar(
        backgroundColor: model.paletteColor,
        title: const Text('Manage Tickets'),
        centerTitle: true,
      ) : null,
      body: Padding(
          padding: (kIsWeb) ? const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0) : EdgeInsets.zero,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
            ),
          child: retrieveAuthenticationState(context)
        )
      ),
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
              loadUserProfileSuccess: (item) => (reservationItem != null && activityManagerForm != null) ?  ActivityAttendeeTicketsResultMain(
                  model: model,
                  tickets: attendeeTickets,
                  reservationItem: reservationItem!,
                  currentUser: item.profile,
                  activityManagerForm: activityManagerForm!) : settingsFailureToLoadContainer(),
              orElse: () {
                return JumpingDots(color: model.paletteColor, numberOfDots: 3);
              }
          );
        },
      ),
    );
  }

  Widget settingsFailureToLoadContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: model.disabledTextColor, size: 85),
          const SizedBox(height: 10),
          Text('Sorry, Cannot Manage Tickets', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 10),
          Text('Start your own reservation and be able to see & manage your tickets', style: TextStyle(color: model.disabledTextColor)),
        ],
      ),
    );
  }

}