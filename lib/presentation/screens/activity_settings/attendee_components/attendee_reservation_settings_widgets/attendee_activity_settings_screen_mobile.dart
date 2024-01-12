import 'package:check_in_application/auth/update_services/listing_update_create_services/attendee_update_create_services/listing_attendee_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/attendee_components/attendee_reservation_settings_widgets/attendee_general_settings.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityAttendeeSettingsMainContainerMobileWidget extends StatelessWidget {

  final DashboardModel model;
  final AttendeeItem attendeeItem;
  final ActivityManagerForm activityManagerForm;
  final UserProfileModel userProfileModel;
  final ReservationItem reservationItem;
  final SettingsItemModel? currentNavItem;

  const ActivityAttendeeSettingsMainContainerMobileWidget({super.key,
    required this.model,
    required this.attendeeItem,
    required this.userProfileModel,
    required this.reservationItem,
    required this.currentNavItem,
    required this.activityManagerForm
  });



  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(reservationItem.reservationOwnerId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadSelectedProfileFailure: (_) => settingsFailureToLoadContainer(model),
                  loadSelectedProfileSuccess: (item) => getMainContainer(context, item.profile),
                  orElse: () => settingsFailureToLoadContainer(model)
              );
            }
        )
    );
  }


  Widget getMainContainer(BuildContext context, UserProfileModel resOwnerModel) {
    return BlocProvider(create: (context) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(bloc.optionOf(attendeeItem), bloc.optionOf(reservationItem), bloc.optionOf(activityManagerForm), bloc.optionOf(resOwnerModel))),
        child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
          listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
          listener: (context, state) {

          },
          buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: model.paletteColor,
                centerTitle: true,
                title: Text('Your Attendance', style: TextStyle(color: model.accentColor)),
                actions: [

                  if (!(state.isSubmitting)) InkWell(
                      onTap: () {
                        if (state.attendeeItem != attendeeItem) {
                          // context.read<AttendeeFormBloc>().add(AttendeeFormEvent)
                        }
                      },
                    child: Center(child: Text('Save', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: (state.attendeeItem != attendeeItem) ? model.accentColor : model.disabledTextColor.withOpacity(0.4)),))
                  ),
                ],
              ),
              body: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),

                    SingleChildScrollView(
                      child: Column(
                        children: [
                          AttendeeGeneralSettingsWidget(
                            model: model,
                            activityForm: activityManagerForm,
                            attendeeItem: attendeeItem,
                            userProfileModel: userProfileModel,
                            reservationItem: reservationItem,
                          ),
                          /// check in forms if exists
                        ],
                      ),
                    ),


                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Column(
                        children: [

                          if (state.isSubmitting) Column(
                            children: [
                              JumpingDots(color: model.paletteColor, radius: 5, numberOfDots: 4),
                              const SizedBox(height: 10),
                              Text(AppLocalizations.of(context)!.saving, style: TextStyle(color: model.disabledTextColor)),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]
              ),
            );
          },
        )
    );
  }
}