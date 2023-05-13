import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;

class ActivityAttendeeCreateTicket extends StatelessWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityAttendeeCreateTicket({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityCreatorForm))),
      child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
      listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
      listener: (context, state) {

      },
      buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityCreatorForm != c.activityCreatorForm,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: model.paletteColor,
            title: Text('Ticket Attendees', style: TextStyle(color: model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('${AppLocalizations.of(context)!.activityAttendanceTypeGenerate} ${AppLocalizations.of(context)!.activityAttendanceTypeTickets}', style: TextStyle(
                color: model.paletteColor,
                fontWeight: FontWeight.bold,
                fontSize: model.secondaryQuestionTitleFontSize)),
            Text(AppLocalizations.of(context)!.activityAttendanceTypeGenerateHint, style: TextStyle(
                color: model.paletteColor)),
            const SizedBox(height: 50),


            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isDayBased ?? false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('${AppLocalizations.of(context)!.activityAttendanceTypeTickets} ${AppLocalizations.of(context)!.activityAttendanceTypeQuantity} Per ${AppLocalizations.of(context)!.days} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
                          color: model.paletteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: model.secondaryQuestionTitleFontSize)),
                      Text(AppLocalizations.of(context)!.activityAttendanceTypeQuantityHint(AppLocalizations.of(context)!.activityAttendanceTypeTickets, AppLocalizations.of(context)!.activityAvailabilitySessions), style: TextStyle(color: model.paletteColor)),
                      const SizedBox(height: 10),

                      Container(
                        width: 375,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                                offset: const Offset(-10,-15),
                                isDense: true,
                                buttonElevation: 0,
                                buttonDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                customButton: Container(
                                  decoration: BoxDecoration(
                                    color: model.accentColor,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text('${context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAttendance.activityTickets?.ticketQuantity ?? 0} ${AppLocalizations.of(context)!.activityAttendanceTypeTickets}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: model.disabledTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onChanged: (Object? navItem) {
                                },
                                buttonWidth: 80,
                                buttonHeight: 70,
                                dropdownElevation: 1,
                                dropdownPadding: const EdgeInsets.all(1),
                                dropdownDecoration: BoxDecoration(
                                    boxShadow: [BoxShadow(
                                        color: Colors.black.withOpacity(0.11),
                                        spreadRadius: 1,
                                        blurRadius: 15,
                                        offset: Offset(0, 2)
                                    )
                                    ],
                                    color: model.cardColor,
                                    borderRadius: BorderRadius.circular(14)),
                                itemHeight: 50,
                                // dropdownWidth: (model.mainContentWidth)! - 100,
                                focusColor: Colors.grey.shade100,
                                items: [for(var i=0; i<100; i+=1) i].where((element) => element != 0).map(
                                        (e) => DropdownMenuItem<int>(
                                        onTap: () {
                                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.ticketQuantityChanged(e));
                                        },
                                        value: e,
                                        child: Text('$e ${AppLocalizations.of(context)!.activityAttendanceTypeTickets}', style: TextStyle(color: model.disabledTextColor)
                                )
                              )
                            ).toList()
                          )
                        ),
                      ),

                    ],
                  ),
                ),


                Visibility(
                  visible: true,
                  // visible: !(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isDayBased ?? true),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Visibility(
                        // visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isThirtyMinutesPer ?? false,
                        child: Text('${AppLocalizations.of(context)!.activityAttendanceTypeTickets} ${AppLocalizations.of(context)!.activityAttendanceTypeQuantity} Per 30 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
                            color: model.paletteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: model.secondaryQuestionTitleFontSize)),
                      ),

                      Visibility(
                          visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isSixtyMinutesPer ?? false,
                          child: Text('${AppLocalizations.of(context)!.activityAttendanceTypeTickets} ${AppLocalizations.of(context)!.activityAttendanceTypeQuantity} Per 60 ${AppLocalizations.of(context)!.facilityAvailableSlotMinutes} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
                            color: model.paletteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: model.secondaryQuestionTitleFontSize)),
                      ),

                      Visibility(
                        visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.isTwoHoursPer ?? false,
                        child: Text('${AppLocalizations.of(context)!.activityAttendanceTypeTickets} ${AppLocalizations.of(context)!.activityAttendanceTypeQuantity} Per 2 ${AppLocalizations.of(context)!.facilityAvailableSlotHours} ${AppLocalizations.of(context)!.activityAvailabilitySessions}', style: TextStyle(
                            color: model.paletteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: model.secondaryQuestionTitleFontSize)),
                      ),

                      Text(AppLocalizations.of(context)!.activityAttendanceTypeQuantityHint(AppLocalizations.of(context)!.activityAttendanceTypeTickets, AppLocalizations.of(context)!.activityAvailabilitySessions), style: TextStyle(color: model.paletteColor)),
                      SizedBox(height: 10),

                      Container(
                        width: 375,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                                offset: const Offset(-10,-15),
                                isDense: true,
                                buttonElevation: 0,
                                buttonDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                customButton: Container(
                                  decoration: BoxDecoration(
                                    color: model.accentColor,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text('${context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAttendance.activityTickets?.ticketQuantity ?? 0} ${AppLocalizations.of(context)!.activityAttendanceTypeTickets}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: model.disabledTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onChanged: (Object? navItem) {
                                },
                                buttonWidth: 80,
                                buttonHeight: 70,
                                dropdownElevation: 1,
                                dropdownPadding: const EdgeInsets.all(1),
                                dropdownDecoration: BoxDecoration(
                                    boxShadow: [BoxShadow(
                                        color: Colors.black.withOpacity(0.11),
                                        spreadRadius: 1,
                                        blurRadius: 15,
                                        offset: Offset(0, 2)
                                      )
                                    ],
                                    color: model.cardColor,
                                    borderRadius: BorderRadius.circular(14)),
                                itemHeight: 50,
                                // dropdownWidth: (model.mainContentWidth)! - 100,
                                focusColor: Colors.grey.shade100,
                                items: [for(var i=0; i<100; i+=1) i].where((element) => element != 0).map(
                                        (e) => DropdownMenuItem<int>(
                                        onTap: () {
                                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.ticketQuantityChanged(e));
                                        },
                                        value: e,
                                        child: Text('$e ${AppLocalizations.of(context)!.activityAttendanceTypeTickets}', style: TextStyle(color: model.disabledTextColor)
                                      )
                                    )
                                  ).toList()
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
        );
        }
      )
    );
  }
}