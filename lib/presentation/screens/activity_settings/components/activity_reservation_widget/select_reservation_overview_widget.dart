import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;

class ActivityAttendeeSelectType extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivityAttendeeSelectType({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  State<ActivityAttendeeSelectType> createState() => _ActivityAttendeeSelectTypeState();
}

class _ActivityAttendeeSelectTypeState extends State<ActivityAttendeeSelectType> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
    child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
    listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
    listener: (context, state) {

    },
    buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
    builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: widget.model.paletteColor,
            title: Text('Attendance Overview', style: TextStyle(color: widget.model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(AppLocalizations.of(context)!.facilitiesSelect, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  ),
                ),
              ),

                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.model.accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                            return widget.model.paletteColor.withOpacity(0.1);
                                          }
                                          if (states.contains(MaterialState.hovered)) {
                                            return widget.model.paletteColor.withOpacity(0.1);
                                          }
                                          return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true) ? widget.model.accentColor.withOpacity(0.6) : widget.model.paletteColor; // Use the component's default.
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          )
                                      )
                                  ),
                                  onPressed: () {

                                    setState(() {
                                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true) {
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(false));
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                                      } else {
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(true));
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Icon(Icons.crop_free_outlined, size: 40, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true) ? widget.model.paletteColor : widget.model.accentColor),
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendanceNone, style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true) ? widget.model.paletteColor :  widget.model.accentColor , fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                              Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendanceNoneDes, style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true) ? widget.model.paletteColor : widget.model.accentColor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: !(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    Text('Maximum Number of ${AppLocalizations.of(context)!.activityAttendanceTypeTitle}', style: TextStyle(color: widget.model.paletteColor)),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 375,
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                              // offset: const Offset(-10,-15),
                                              isDense: true,
                                              // buttonElevation: 0,
                                              // buttonDecoration: BoxDecoration(
                                              //   color: Colors.transparent,
                                              //   borderRadius: BorderRadius.circular(35),
                                              // ),
                                              customButton: Container(
                                                decoration: BoxDecoration(
                                                  color: widget.model.accentColor,
                                                  borderRadius: BorderRadius.circular(35),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.attendanceLimit ?? 0} ${AppLocalizations.of(context)!.activityAttendanceTypeTitle}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 8.0),
                                                        child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onChanged: (Object? navItem) {
                                              },

                                              // buttonWidth: 80,
                                              // buttonHeight: 70,
                                              // dropdownElevation: 1,
                                              // dropdownPadding: const EdgeInsets.all(1),
                                              // dropdownDecoration: BoxDecoration(
                                              //     boxShadow: [BoxShadow(
                                              //         color: Colors.black.withOpacity(0.11),
                                              //         spreadRadius: 1,
                                              //         blurRadius: 15,
                                              //         offset: Offset(0, 2)
                                              //     )
                                              //     ],
                                              //     color: widget.model.cardColor,
                                              //     borderRadius: BorderRadius.circular(14)),
                                              // itemHeight: 50,
                                              // dropdownWidth: (widget.model.mainContentWidth)! - 100,
                                              // focusColor: Colors.grey.shade100,
                                              items: [for(var i=0; i<100; i+=1) i].where((element) => element != 0).map(
                                                      (e) => DropdownMenuItem<int>(
                                                      onTap: () {
                                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.attendanceLimitChanged(e));
                                                      },
                                                      value: e,
                                                      child: Text('$e ${AppLocalizations.of(context)!.activityAttendanceTypeTitle}', style: TextStyle(color: widget.model.disabledTextColor)
                                              )
                                            )
                                          ).toList()
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),

                              Visibility(
                                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAvailability.sessionType != ActivitySessionType.multiDay && (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAttendance.isLimitedAttendance ?? true),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                              return widget.model.paletteColor.withOpacity(0.1);
                                            }
                                            if (states.contains(MaterialState.hovered)) {
                                              return widget.model.paletteColor.withOpacity(0.1);
                                            }
                                            return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) ? widget.model.paletteColor : widget.model.accentColor.withOpacity(0.6); // Use the component's default.
                                          },
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                        )
                                      )
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) {
                                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                                        } else {
                                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(true));
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Icon(Icons.airplane_ticket_rounded, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) ? widget.model.accentColor : widget.model.paletteColor, size: 40),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicket1, style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                                Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicketDes, style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased ?? false) ? widget.model.accentColor : widget.model.paletteColor)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),


                            Visibility(
                              visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance ?? true,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                            return widget.model.paletteColor.withOpacity(0.1);
                                          }
                                          if (states.contains(MaterialState.hovered)) {
                                            return widget.model.paletteColor.withOpacity(0.1);
                                          }
                                          return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false) ? widget.model.paletteColor : widget.model.accentColor.withOpacity(0.6); // Use the component's default.
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          )
                                      )
                                  ),
                                  onPressed: () {

                                    setState(() {
                                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false) {
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                                      } else {
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(true));
                                      }
                                    });

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Icon(Icons.credit_card_rounded, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false) ? widget.model.accentColor : widget.model.paletteColor, size: 40),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendancePasses1, style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                              Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendancePassesDes, style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased ?? false) ? widget.model.accentColor : widget.model.paletteColor)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
              )
            ),
          );
        }
      )
    );
  }
}