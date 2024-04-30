import 'package:check_in_application/auth/update_services/listing_update_create_services/attendee_update_create_services/listing_attendee_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/attendee_components/attendee_reservation_settings_widgets/attendee_general_settings.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings_web/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityAttendeeSettingsMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final AttendeeItem attendeeItem;
  final ActivityManagerForm activityManagerForm;
  final UserProfileModel userProfileModel;
  final ReservationItem reservationItem;
  final SettingsItemModel? currentNavItem;

  const ActivityAttendeeSettingsMainContainerWidget({super.key,
    required this.model,
    required this.attendeeItem,
    required this.userProfileModel,
    required this.reservationItem,
    required this.currentNavItem,
    required this.activityManagerForm
  });


  Widget getMainSettingsContainer(SettingsItemModel? navItem) {
      switch (navItem?.navItem) {
        case SettingNavMarker.reservation:
          return AttendeeGeneralSettingsWidget(
            model: model,
            activityForm: activityManagerForm,
            attendeeItem: attendeeItem,
            userProfileModel: userProfileModel,
            reservationItem: reservationItem,
          );
        case SettingNavMarker.checkIns:
          break;
        default:
          return Container();
      }
      return Container();
  }

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
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 10.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: BlocProvider(create: (context) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(bloc.optionOf(attendeeItem), bloc.optionOf(reservationItem), bloc.optionOf(activityManagerForm), bloc.optionOf(resOwnerModel))),
              child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
                  listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
                  listener: (context, state) {

                    state.authFailureOrSuccessOption.fold(
                            () {},
                            (either) => either.fold((failure) {
                          final snackBar = SnackBar(
                              backgroundColor: model.webBackgroundColor,
                              content: failure.maybeMap(
                                attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor)),
                                attendeePermissionDenied: (e) => Text('Sorry, you dont have permission to do that', style: TextStyle(color: model.disabledTextColor)),
                                orElse: () => Text('A Problem Happened', style: TextStyle(color: model.disabledTextColor)),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        }, (_) {
                          final snackBar = SnackBar(
                              elevation: 4,
                              backgroundColor: model.paletteColor,
                              content: Text('saved', style: TextStyle(color: model.webBackgroundColor))
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }));


              },
             buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
              builder: (context, state) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),

                    SingleChildScrollView(
                      child: getMainSettingsContainer(
                          currentNavItem,
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

                          if (state.attendeeItem != attendeeItem && state.isSubmitting == false) InkWell(
                            onTap: () {
                                context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
                                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(userProfileModel, '', '', ''));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: model.paletteColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text('Save\nChanges', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    )

                ]
              );
            },
          )
        ),
      )
    );
  }

}