import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchByTimeSlots extends StatefulWidget {

  final DashboardModel model;
  final String heroTag;
  final String buttonTitle;
  final int durationType;

  const SearchByTimeSlots({super.key, required this.model, required this.heroTag, required this.durationType, required this.buttonTitle});

  @override
  State<SearchByTimeSlots> createState() => _SearchByTimeSlotsState();
}

class _SearchByTimeSlotsState extends State<SearchByTimeSlots> with TickerProviderStateMixin {

  late DateRangePickerController dController;
  late DateTime currentDateTime;
  // List<String> tabWhenTime = ['30/min', '60/min', 'A Day'];

  @override
  void initState() {
    dController = DateRangePickerController();
    currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    super.initState();
  }

  @override
  void dispose() {
    dController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: searchSettingsButton(
                      widget.model,
                      didSelectButton: () {
                        setState(() {

                        });
                      },
                      iconItem: Icons.navigate_next,
                      buttonTitle: widget.buttonTitle,
                      isSelected: false
                  ),
                ),
                const SizedBox(height: 15),
                Text('select slots  below - we will try to show Listings that have the slots you selected available', style: TextStyle(color: widget.model.disabledTextColor),),
                const SizedBox(height: 05),
                getHourBasedTimeSlotView(
                  context,
                  widget.model,
                  dController,
                  DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 365))),
                  widget.durationType,
                  currentDateTime,
                  context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                  selectedDateTime: (date) {
                    setState(() {
                      currentDateTime = date;
                    });
                  },
                  selectedRes: (slot) {
                    setState(() {
                      List<ReservationTimeFeeSlotItem> slots = [];
                      slots.addAll(context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? []);

                      if (slots.contains(slot)) {
                        slots.remove(slot);
                      } else {
                        slots.add(slot);
                      }
                      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));

                      context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged(slots));
                      context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.searchDurationTypeChanged(widget.durationType));
                    });
                  }
              ),
            ],
          ),
        )
      )
    );
  }
}

Widget getHourBasedTimeSlotView(
    BuildContext context,
    DashboardModel model,
    DateRangePickerController? controller,
    DateTimeRange endStartDates,
    int durationType,
    DateTime currentDate,
    List<ReservationTimeFeeSlotItem> listOfSelectedReservations, {
     required Function(DateTime date) selectedDateTime,
     required Function(ReservationTimeFeeSlotItem res) selectedRes,
    }
    ) {
  return Container(
    // height: 300,
    width: MediaQuery.of(context).size.width,
    /// generate hours list based on selected day of week & date
    child: Column(
      children: [
        Container(
          height: 135,
          width: MediaQuery.of(context).size.width,
          child: selectedCalendarDatesSlotReservations(
              model,
              DateTime.now(),
              [],
              controller,
              endStartDates,
              selectedDateTime: (date) {
                return selectedDateTime(date);
            }
          ),
        ),
        const SizedBox(height: 10),
        calendarListOfSelectableReservations(
            context,
            model,
            durationType,
            [],
            UniqueId(),
            getBaseCalendarList(
                durationType: durationType,
                minHour: 0,
                maxHour: 24,
                currentDateTime: currentDate
            ),
            listOfSelectedReservations,
            false,
            AppLocalizations.of(context)!.profileFacilitySlotTime,
            AppLocalizations.of(context)!.facilityLocationAdd,
            selectedReservation: (resSlot) {
              selectedRes(resSlot);
            }
        )

      ],
    ),
  );
}
