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
  ReservationTimeFeeSlotItem? _selectedReservationTimeSlot;

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

  void checkSelectedReservationSlot(List<ReservationSlotItem> reservationSlots) {
    if (reservationSlots.isNotEmpty) {
      if (reservationSlots[0].selectedSlots.isNotEmpty) {
        _selectedReservationTimeSlot = reservationSlots[0].selectedSlots[0];
      }
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
    else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketPerSlotBased == false) {
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
    } else {
      if (_selectedReservationSlot == null) checkSelectedReservation(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem);
      if (_selectedReservationTimeSlot == null) checkSelectedReservationSlot(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem);
      if (_firstTextEditingController.text != context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
              (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString()) {
        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketFee == null) {
          _firstTextEditingController.text = '';
        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets != null) {
          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                  (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString();
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
    } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketPerSlotBased == false) {
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
    } else {
      if (_selectedReservationSlot == null) checkSelectedReservation(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem);
      if (_selectedReservationTimeSlot == null) checkSelectedReservationSlot(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem);
      if (_secondTextEditingController.text != context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
              (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString()) {
        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity == null) {
          _secondTextEditingController.text = '';
        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets != null) {
          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                  (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString();
        }
      }
    }
  }

  void createNewSlotsObject(BuildContext context) {

    final List<ActivityTicketOption> newTickets = [];

    for (ReservationSlotItem resSlot in context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem) {
      late ActivityTicketOption ticketOption = ActivityTicketOption(
        ticketId: UniqueId(),
        isAllowedGroupAttendance: ActivityTicketOption.empty().isAllowedGroupAttendance,
        minimumGroupQuantity: ActivityTicketOption.empty().minimumGroupQuantity,
        maximumGroupQuantity: ActivityTicketOption.empty().maximumGroupQuantity,
        ticketQuantity: ActivityTicketOption.empty().ticketQuantity,
        reservationSlot: resSlot,
        reservationTimeSlot: null,
        ticketTitle: null,
        ticketFee: null,
      );
      newTickets.add(ticketOption);
    }

    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTickets));

  }

  void createNewSlotBasedObject(BuildContext context) {

    final List<ActivityTicketOption> newTickets = [];

    for (ReservationSlotItem resSlot in context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem) {
      for (ReservationTimeFeeSlotItem slotTime in resSlot.selectedSlots) {
        late ActivityTicketOption ticketOption = ActivityTicketOption(
          ticketId: UniqueId(),
          isAllowedGroupAttendance: ActivityTicketOption.empty().isAllowedGroupAttendance,
          minimumGroupQuantity: ActivityTicketOption.empty().minimumGroupQuantity,
          maximumGroupQuantity: ActivityTicketOption.empty().maximumGroupQuantity,
          ticketQuantity: ActivityTicketOption.empty().ticketQuantity,
          reservationSlot: resSlot,
          reservationTimeSlot: slotTime,
          ticketTitle: null,
          ticketFee: null,
        );

        newTickets.add(ticketOption);

      }
    }
    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTickets));

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

                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == true) {
                          createNewSlotsObject(context);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketFixedChanged(false));
                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString() ?? '';
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString() ?? '';
                        } else {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketFixedChanged(true));
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketSlotBasedOnly(false));
                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketFee.toString() ?? '';
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.defaultActivityTickets?.ticketQuantity.toString() ?? '';
                        }
                      });
                    },
                    didSelectTicketPerSlotBased: () {

                      setState(() {



                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketPerSlotBased == true) {
                          createNewSlotsObject(context);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketSlotBasedOnly(false));
                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString();
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString();
                        } else {
                          createNewSlotBasedObject(context);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isTicketSlotBasedOnly(true));
                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString();
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets!.firstWhere(
                                  (element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString();
                        }
                      });
                    },
                    selectedReservationSlot: _selectedReservationSlot,
                    selectedResTimeSlot: _selectedReservationTimeSlot,
                    didSelectRes: (res) {
                      setState(() {
                        _selectedReservationSlot = res;
                        _selectedReservationTimeSlot = null;

                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.isNotEmpty == true) {
                          // createNewSlotsObject(context);

                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                                  (element) => element.reservationSlot == res, orElse: () => ActivityTicketOption.empty()).ticketFee.toString() ?? '';
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                                  (element) => element.reservationSlot == res, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString() ?? '';
                        }
                      });
                    },
                    didSelectSlotRes: (res , slot) {
                      setState(() {
                        _selectedReservationSlot = res;
                        _selectedReservationTimeSlot = slot;

                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.isNotEmpty == true) {
                          // createNewSlotBasedObject(context);

                          _firstTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                                  (element) => element.reservationSlot == res && element.reservationTimeSlot == slot, orElse: () => ActivityTicketOption.empty()).ticketFee.toString() ?? '';
                          _secondTextEditingController.text = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets?.firstWhere(
                                  (element) => element.reservationSlot == res && element.reservationTimeSlot == slot, orElse: () => ActivityTicketOption.empty()).ticketQuantity.toString() ?? '';

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


                        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketPerSlotBased == false) {

                            late List<ActivityTicketOption> newTicketList = [];
                            newTicketList.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);

                            // createNewSlotsObject(context);

                            late int index = newTicketList.indexWhere((element) => element.reservationSlot == _selectedReservationSlot);
                            late ActivityTicketOption currentTicket = newTicketList[index];
                            currentTicket = currentTicket.copyWith(
                                reservationSlot: _selectedReservationSlot,
                                ticketFee: int.parse(e)
                            );

                            newTicketList.replaceRange(index, index+1, [currentTicket]);
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTicketList));
                          } else {

                          late List<ActivityTicketOption> newTicketList = [];
                          newTicketList.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);

                          // createNewSlotBasedObject(context);

                          late int index = newTicketList.indexWhere((element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot);
                          late ActivityTicketOption currentTicket = newTicketList[index];
                          currentTicket = currentTicket.copyWith(
                              reservationSlot: _selectedReservationSlot,
                              reservationTimeSlot: _selectedReservationTimeSlot,
                              ticketFee: int.parse(e)
                          );

                          newTicketList.replaceRange(index, index+1, [currentTicket]);
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


                        } else if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketPerSlotBased == false) {

                          late List<ActivityTicketOption> newTicketList = [];
                          newTicketList.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);

                          // createNewSlotsObject(context);

                          late int index = newTicketList.indexWhere((element) => element.reservationSlot == _selectedReservationSlot);
                          late ActivityTicketOption currentTicket = newTicketList[index];
                          currentTicket = currentTicket.copyWith(
                              reservationSlot: _selectedReservationSlot,
                              ticketQuantity: int.parse(e)
                          );

                          newTicketList.replaceRange(index, index+1, [currentTicket]);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTicketList));

                        } else {

                          late List<ActivityTicketOption> newTicketList = [];
                          newTicketList.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.activityTickets ?? []);

                          // createNewSlotBasedObject(context);

                          late int index = newTicketList.indexWhere((element) => element.reservationSlot == _selectedReservationSlot && element.reservationTimeSlot == _selectedReservationTimeSlot);
                          late ActivityTicketOption currentTicket = newTicketList[index];
                          currentTicket = currentTicket.copyWith(
                              reservationSlot: _selectedReservationSlot,
                              reservationTimeSlot: _selectedReservationTimeSlot,
                              ticketQuantity: int.parse(e)
                          );

                          newTicketList.replaceRange(index, index+1, [currentTicket]);
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTicketsChanged(newTicketList));

                        }
                  });
                },
              )
            ],
          )
        ),
      )
    );
  }
}