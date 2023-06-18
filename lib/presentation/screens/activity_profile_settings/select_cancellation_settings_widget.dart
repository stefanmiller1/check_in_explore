import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationSettingsWidget extends StatefulWidget {

  final DashboardModel model;

  const CancellationSettingsWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<CancellationSettingsWidget> createState() => _CancellationSettingsWidgetState();
}

class _CancellationSettingsWidgetState extends State<CancellationSettingsWidget> {

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
        width: 675,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              mainContainerSectionOneCancel(
                  context: context,
                  model: widget.model,
                  state: context.read<UpdateActivityFormBloc>().state,
                  isNotAllowedCancellation: () {
                    setState(() {
                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isNotAllowedCancellation ?? false) {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isNotAllowedCancellation(false));
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedEarlyEndChange(true));
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedChangeWithoutEarlyEnd(true));
                      } else {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isNotAllowedCancellation(true));
                      }
                    });
                  },
                  isAllowedFeeBasedChanges: () {
                    setState(() {
                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedFeeBasedChanges ?? false) {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedFeeBasedCancellation(false));
                        if (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedChangeNotEarlyEnd ?? false) &&
                            (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedEarlyEndAndChanges ?? false)) &&
                            (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedTimeBasedChanges ?? false))
                        ) {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isNotAllowedCancellation(true));
                        }
                      } else {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedFeeBasedCancellation(true));
                      }
                    });
                  },
                  feeBasedCancellationChanged: (cancellations) {
                    setState(() {
                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.feeBasedCancellationChanged(cancellations));
                    });
                  },
                  createCancellationWidget: () {
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
                                height: 550,
                                child: CancellationEditFeeWidget(
                                  model: widget.model,
                                  didUpdateFee: (fee) {
                                    setState(() {
                                      final List<FeeBasedCancellation> feeCancellations = [];
                                      feeCancellations.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.feeBasedCancellationOptions ?? []);
                                      feeCancellations.add(fee);

                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.feeBasedCancellationChanged(feeCancellations));
                                    });
                                  },
                                ),
                              ),
                            )
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset(0, 0.15)).animate(anim1),
                          child: child,
                        );
                      },
                    );
                  },
                  isAllowedTimeBasedChanges: () {
                    setState(() {
                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedTimeBasedChanges ?? false) {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedTimeBasedCancellation(false));
                        if (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedChangeNotEarlyEnd ?? false) &&
                            (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedEarlyEndAndChanges ?? false)) &&
                            (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedFeeBasedChanges ?? false))
                        ) {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isNotAllowedCancellation(true));
                        }
                      } else {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAllowedTimeBasedCancellation(true));
                      }
                    });
                  },
                  timeBasedCancellationChanged: () {
                    setState(() {
                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.timeBasedCancellationChanged([]));
                    });
                  },
                  createCancellationEditWidget: () {
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
                                height: 550,
                                child: CancellationEditTimeWidget(
                                  model: widget.model,
                                  didUpdateFee: (time) {
                                    setState(() {
                                      final List<TimeBasedCancellation> timeCancellation = [];
                                      timeCancellation.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.timeBasedCancellationOptions ?? []);
                                      timeCancellation.add(time);

                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.timeBasedCancellationChanged(timeCancellation));
                                    });
                                  },
                                ),
                              ),
                            )
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset(0, 0.15)).animate(anim1),
                          child: child,
                        );
                      },
                    );
                  }
              )

            ],
          ),
        ),
      ),
    );
  }
}