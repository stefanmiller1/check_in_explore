import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_attendees/activity_attendees_result_main.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class ActivityAttendeeMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final AttendeeItem? attendee;
  final UserProfileModel? selectedProfile;
  final Function() rebuild;

  const ActivityAttendeeMainContainerWidget({super.key, required this.model, required this.rebuild, this.attendee, this.selectedProfile});

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
              loadUserProfileSuccess: (item) => (selectedProfile != null && attendee != null) ?  ActivityAttendeesResultMain(
                  model: model,
                  attendee: attendee,
                  selectedProfile: selectedProfile
              ) : defaultPagePreview(),
              orElse: () {
                return JumpingDots(color: model.paletteColor, numberOfDots: 3);
            }
          );
        },
      ),
    );
  }

  Widget defaultPagePreview() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.person_2_outlined, color: model.disabledTextColor, size: 85),
          const SizedBox(height: 10),
          Text('Attendees', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 10),
          Text('Select any attendee from the list and preview their Profile!', style: TextStyle(color: model.disabledTextColor)),
        ],
      ),
    );
  }
}


  /// you can...
  /// search
  /// go to profile
  /// (manager can)..
  /// remove attendee
  /// confirm attendance (or deny)
  /// organize by attendee type (optional)? (show attendee type)
