import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


import 'package:check_in_presentation/check_in_presentation.dart';

class CheckInSettingWidget extends StatefulWidget {

  final DashboardModel model;

  const CheckInSettingWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<CheckInSettingWidget> createState() => _CheckInSettingWidgetState();
}

class _CheckInSettingWidgetState extends State<CheckInSettingWidget> {

  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              minContainerForCheckIn(
                context: context,
                model: widget.model,
                editSelectCheckInForm: (value) {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
                    barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
                    transitionDuration: Duration(milliseconds: 650),
                    pageBuilder: (BuildContext contexts, anim1, anim2) {
                      return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: widget.model.accentColor,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                              ),
                              width: 600,
                              height: 750,
                              child: CheckInFormEditWidget(
                                model: widget.model,
                                currentCheckInForm: value,
                                spaces: null,
                                reservations: context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem,
                                didSaveCheckIn: (checkIn) {
                                  setState(() {
                                    final List<CheckInSetting> newCheckIn = [];
                                    newCheckIn.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.checkInSetting);
                                    newCheckIn.add(checkIn);

                                    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.checkInSettingsChanged(newCheckIn));
                                  });
                                },
                              ),
                            ),
                          )
                      );
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
                        child: child,
                      );
                    },
                  );
                },
                checkInSettingsChanged: (checkIns) {
                  setState(() {
                    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.checkInSettingsChanged(checkIns));
                  });
                },
                createNewCheckInForm: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
                    barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
                    transitionDuration: Duration(milliseconds: 650),
                    pageBuilder: (BuildContext contexts, anim1, anim2) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.model.accentColor,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                            ),
                            width: 600,
                            height: 750,
                            child: CheckInFormEditWidget(
                              model: widget.model,
                              currentCheckInForm: CheckInSetting.empty(),
                              spaces: null,
                              reservations: context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem,
                              didSaveCheckIn: (checkIn) {
                                setState(() {
                                  final List<CheckInSetting> newCheckIn = [];
                                  newCheckIn.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.checkInSetting);
                                  newCheckIn.add(checkIn);

                                  context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.checkInSettingsChanged(newCheckIn));
                                });
                              },
                            ),
                          ),
                        )
                      );
                    },
                    transitionBuilder: (context, anim1, anim2, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
                        child: child,
                      );
                    },
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}