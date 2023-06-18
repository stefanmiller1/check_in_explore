import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

class CreateTicketAttendee extends StatefulWidget {

  final DashboardModel model;

  const CreateTicketAttendee({Key? key, required this.model}) : super(key: key);

  @override
  State<CreateTicketAttendee> createState() => _CreateTicketAttendeeState();
}

class _CreateTicketAttendeeState extends State<CreateTicketAttendee> {

  ScrollController? _scrollController;
  ReservationSlotItem? _selectedReservationSlot;

  late TextEditingController _firstTextEditingController;
  late TextEditingController _secondTextEditingController;
  late ActivityTicketOption _currentTicketOption = ActivityTicketOption.empty();

  @override
  void initState() {
    _scrollController = ScrollController();
    _firstTextEditingController = TextEditingController();
    _secondTextEditingController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController?.dispose();
    _secondTextEditingController.dispose();
    _firstTextEditingController.dispose();
    super.dispose();
  }

  void checkSelectedReservation(List<ReservationSlotItem> reservationSlots) {
    if (reservationSlots.isNotEmpty) {
        _selectedReservationSlot = reservationSlots[0];
      }
  }

  void rebuildPrice(BuildContext context) {

    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == true) {
      if (_firstTextEditingController.text != context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketFee.toString()) {
        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketFee == null && context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketFee.toString() == 'null') {
          _firstTextEditingController.text = '';
        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets != null) {
          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets!.ticketFee.toString();
        }
      }
    }
    else {
      if (_selectedReservationSlot == null) checkSelectedReservation(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem);
          if (_firstTextEditingController.text != context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString()) {
            if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                    (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketFee == null) {
                _firstTextEditingController.text = '';
            } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets != null) {
              _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                      (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString();
        }
      }
    }
  }

  void rebuildQuantity(BuildContext context) {
    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == true) {
      if (_secondTextEditingController.text != context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity.toString()) {
        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity == null && context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity.toString() == 'null') {
          _secondTextEditingController.text = '';
        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets != null) {
          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets!.ticketQuantity.toString();
        }
      }
    } else {
      if (_selectedReservationSlot == null) checkSelectedReservation(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem);
        if (_secondTextEditingController.text != context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
              (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString()) {
        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity == null) {
          _secondTextEditingController.text = '';
        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets != null) {
          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString();
        }
      }
    }
  }

  void createNewSlotsObject(BuildContext context) {

    if (!(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.map((e) => e.reservationSlot).contains(_selectedReservationSlot) ?? false)) {
      final List<ActivityTicketOption> newTickets = [];
      late ActivityTicketOption ticketOption = ActivityTicketOption(
          isAllowedGroupAttendance: ActivityTicketOption.empty().isAllowedGroupAttendance,
          minimumGroupQuantity: ActivityTicketOption.empty().minimumGroupQuantity,
          maximumGroupQuantity: ActivityTicketOption.empty().maximumGroupQuantity,
          ticketQuantity: ActivityTicketOption.empty().ticketQuantity,
          reservationSlot: _selectedReservationSlot,
          ticketFee: null,
      );

      newTickets.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);
      newTickets.add(ticketOption);

      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTickets));
    }

  }


  @override
  Widget build(BuildContext context) {

    rebuildPrice(context);
    rebuildQuantity(context);
    if (_firstTextEditingController.text == 'null') _firstTextEditingController.text = '';
    if (_secondTextEditingController.text == 'null') _secondTextEditingController.text = '';

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
                mainContainerTicket(
                    context: context,
                    model: widget.model,
                    state: context.read<UpdateActivityFormBloc>().state,
                    didSelectTicketFixed: () {
                      setState(() {
                        createNewSlotsObject(context);

                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == true) {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketFixedChanged(false));
                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString();
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString();
                        } else {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketFixedChanged(true));
                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketFee.toString() ?? '';
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity.toString() ?? '';
                        }
                      });
                    },
                    selectedReservationSlot: _selectedReservationSlot,
                    didSelectRes: (res) {
                      setState(() {
                        _selectedReservationSlot = res;

                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.isNotEmpty == true) {
                          createNewSlotsObject(context);

                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == res, orElse: () => ActivityTicketOption.empty()).ticketFee.toString();
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == res, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString();
                        }
                      });
                    },
                    firstTextEditingController: _firstTextEditingController,
                    didSelectFirstLabel: (e) {
                      setState(() {
                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == true && e != '') {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets != null) {
                            _currentTicketOption = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets!;
                          }
                          _currentTicketOption = _currentTicketOption.copyWith(
                              ticketFee: int.parse(e)
                          );
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.defaultTicketChanged(_currentTicketOption));


                        } else {

                          late List<ActivityTicketOption> newTicketList = [];
                          newTicketList.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);

                          createNewSlotsObject(context);

                          late int index = newTicketList.indexWhere((element) => element.reservationSlot == _selectedReservationSlot);
                          late ActivityTicketOption currentTicket = newTicketList[index];
                          currentTicket = currentTicket.copyWith(
                              reservationSlot: _selectedReservationSlot,
                              ticketFee: int.parse(e)
                          );

                          newTicketList.replaceRange(index, index+1, [currentTicket]);
                          print(newTicketList);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTicketList));

                        }
                      });
                    },
                    secondTextEditingController: _secondTextEditingController,
                    didSelectSecondLabel: (e) {
                      setState(() {
                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == true && e != '') {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets != null) {
                            _currentTicketOption = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets!;
                          }
                          _currentTicketOption = _currentTicketOption.copyWith(
                              ticketQuantity: int.parse(e)
                          );
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.defaultTicketChanged(_currentTicketOption));


                        } else {

                          late List<ActivityTicketOption> newTicketList = [];
                          newTicketList.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);

                          createNewSlotsObject(context);

                          late int index = newTicketList.indexWhere((element) => element.reservationSlot == _selectedReservationSlot);
                          late ActivityTicketOption currentTicket = newTicketList[index];
                          currentTicket = currentTicket.copyWith(
                              reservationSlot: _selectedReservationSlot,
                              ticketQuantity: int.parse(e)
                          );

                          newTicketList.replaceRange(index, index+1, [currentTicket]);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTicketList));

                        }
                      });
                    }
                )
            ],
          )
        ),
      )
    );
  }
}