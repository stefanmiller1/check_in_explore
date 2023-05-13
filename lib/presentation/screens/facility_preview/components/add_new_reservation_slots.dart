import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewReservationSlots extends StatefulWidget {

  final DashboardModel model;
  // final ReservationFormState state;
  final List<ReservationItem> reservations;
  final Function(ReservationItem) didSaveReservation;
  final SpaceOption selectedSpace;
  final SpaceOptionSizeDetail? selectedSportSpace;
  final ListingManagerForm listing;

  const AddNewReservationSlots({super.key, required this.model, required this.listing, required this.reservations, required this.didSaveReservation, required this.selectedSpace, required this.selectedSportSpace});

  @override
  State<AddNewReservationSlots> createState() => _AddNewReservationSlotsState();
}

class _AddNewReservationSlotsState extends State<AddNewReservationSlots> {

  ScrollController? _scrollController;
  DateRangePickerController? _calendarController;
  DateTime? currentDateTime;
  int durationType = 30;
  bool isShowingFeeDetails = false;

  @override
  void initState() {
    _calendarController = DateRangePickerController();
    _scrollController = ScrollController();
    currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    super.initState();
  }

  @override
  void dispose() {
    _calendarController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  Widget getMainContainer(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How Will You Use The Space?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          if (context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isNotEmpty ?? false) ...?context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.map(
                  (e) => getActivityTypeTabOption(
                  context,
                  widget.model,
                  100,
                  ((context.read<ReservationFormBloc>().state.currentListingActivityOption ?? FacilityActivityCreatorForm.empty()) == e),
                  e.activity
              )
          ).toList(),

          if (context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty ?? false || context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty == null) getActivityTypeTabOption(
              context,
              widget.model,
              100,
              false,
              FacilityActivityCreatorForm.empty().activity
          ),

          const SizedBox(height: 5),
          Divider(color: widget.model.paletteColor),
          const SizedBox(height: 5),

          Text('Select a Space', style: TextStyle(
              color: widget.model.paletteColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.questionTitleFontSize)),
          const SizedBox(height: 4),
          spaceOptionsForListingToSelect(
              context,
              widget.model,
              widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
              currentSpace: context.read<ReservationFormBloc>().state.currentSelectedSpace ?? widget.selectedSpace,
              currentSpaceOption: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption ?? widget.selectedSportSpace,
              didSelectSpace: (space) {
                setState(() {
                  context.read<ReservationFormBloc>().add(ReservationFormEvent.spaceDetailChanged(space));
                  context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(space.quantity[0]));
                });
              },
              didSelectSpaceOption: (spaceOption) {
                context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(spaceOption));
              }),
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),
          Text('Available Slot Times', style: TextStyle(
              color: widget.model.paletteColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.questionTitleFontSize)),
          const SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width,
            // height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  visible: (getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [],
                      currentDateTime?.weekday ?? 1).isTwentyFourHour || (!(getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isTwentyFourHour) &&
                      !(getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isClosed))),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('Hours on ${DateFormat.EEEE().format(currentDateTime ?? DateTime.now())}: ',
                        style: TextStyle(color: widget.model.disabledTextColor)),
                  ),
                ),
                Visibility(visible: getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [],
                    currentDateTime?.weekday ?? 1).isTwentyFourHour,
                  child: Text('Open All Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                ),
                Visibility(
                    visible: (!(getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isTwentyFourHour) &&
                        !(getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isClosed)),
                    child: Expanded(
                      child: Wrap(
                        children: getDayOptionFromList(context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).hoursOpen.map(
                                (e) => Padding(padding:
                            const EdgeInsets.only(right: 4.0),
                              child: Text('${DateFormat.jm().format(e.start)} - ${DateFormat.jm().format(e.end)} ||',
                                  style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                            ))
                            .toList(),
                    ),
                  )
                )
              ],
            ),
          ),
          const SizedBox(height: 5),

          selectedCalendarDatesSlotReservations(
              widget.model,
              DateTime.now(),
              getClosedDatesForCalendar(
                widget.model,
                context.read<ReservationFormBloc>().state,
                durationType,
                widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
              ),
              _calendarController,
              widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
              selectedDateTime: (date) {
                setState(() {
                  currentDateTime = date;
              });
          }),

          const SizedBox(height: 10),
          calendarListOfSelectableReservations(
            context,
            widget.model,
            durationType,
            widget.reservations,
            context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId ?? UniqueId(),
            getLiveCalendarList(
              model: widget.model,
              fee: widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
              currency: widget.listing.listingProfileService.backgroundInfoServices.currency,
              durationType: durationType,
              minHour: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.startHour.toInt() ?? 0,
              maxHour: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.endHour.toInt() ?? 0,
              weekDaysToRemove: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.hideCalendarDays ?? [],
              currentDateTime: currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
              pricingRulesSettings: widget.listing.listingRulesService.pricingRuleSettings,
              isPricingRuleFixed: widget.listing.listingRulesService.isPricingRuleFixed,
              startEnd: widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
              hours: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [],
              spaceId: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId ?? UniqueId(),
            ),
            getSelectedDates(
            context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem,
            context.read<ReservationFormBloc>().state,
            currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
            false,
            AppLocalizations.of(context)!.profileFacilitySlotTime,
            AppLocalizations.of(context)!.facilityLocationAdd,
            selectedReservation: (e) {
              setState(() {

                final List<ReservationSlotItem> slotItems = [];
                final List<ReservationTimeFeeSlotItem> timeSlotItems = [];
                final ReservationTimeFeeSlotItem newTime = ReservationTimeFeeSlotItem(slotRange: DateTimeRange(
                        start: e.slotRange.start,
                        end: e.slotRange.start.add(Duration(minutes: durationType))), fee: e.fee);

                slotItems.addAll(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem);

                if (context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem.where((element) =>
                    element.selectedActivityType == (context.read<ReservationFormBloc>().state.currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId) &&
                    element.selectedDate == (currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
                    element.selectedSpaceId == (context.read<ReservationFormBloc>().state.currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId) &&
                    element.selectedSportSpaceId == context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId).isNotEmpty) {
                  timeSlotItems.addAll(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem.where((element) =>
                      element.selectedActivityType == (context.read<ReservationFormBloc>().state.currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId) &&
                      element.selectedDate == (currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
                      element.selectedSpaceId == (context.read<ReservationFormBloc>().state.currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId) && element.selectedSportSpaceId == context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId).first.selectedSlots);
                }

                late ReservationSlotItem newSlot = ReservationSlotItem(
                    selectedActivityType: context.read<ReservationFormBloc>().state.currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId,
                    selectedSpaceId: context.read<ReservationFormBloc>().state.currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId,
                    selectedSportSpaceId: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption!.spaceId,
                    selectedDate: currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), selectedSlots: timeSlotItems);

                if (slotItems.where((element) => element.selectedActivityType == newSlot.selectedActivityType && element.selectedDate == newSlot.selectedDate && element.selectedSpaceId == newSlot.selectedSpaceId && element.selectedSportSpaceId == newSlot.selectedSportSpaceId).isNotEmpty) {
                  /// use existing slot item to replace reservation slot item with new slot time list (which will either remove or add a new slot time depending on existing list already containing or not containing time slot item)
                  if (timeSlotItems.map((e) => e.slotRange.start).contains(newTime.slotRange.start)) {
                    timeSlotItems.remove(newTime);
                  } else {
                    timeSlotItems.add(newTime);
                  }

                  newSlot = newSlot.copyWith(selectedSlots: timeSlotItems);

                  final int indexForSlot = slotItems.indexWhere((element) => element.selectedActivityType == newSlot.selectedActivityType && element.selectedDate == newSlot.selectedDate && element.selectedSpaceId == newSlot.selectedSpaceId && element.selectedSportSpaceId == newSlot.selectedSportSpaceId);

                  slotItems.replaceRange(indexForSlot, indexForSlot + 1, [newSlot]);
                } else {
                  /// create a new reservation slot item if slot item is not already contained
                  newSlot = newSlot.copyWith(selectedSlots: [newTime]);

                  slotItems.add(newSlot);
                }

                context.read<ReservationFormBloc>()..add(ReservationFormEvent.updateBookingItemList(slotItems, widget.listing.listingProfileService.backgroundInfoServices.currency));
              });
            },
          ),

          const SizedBox(height: 120)
        ],
      ),
    );
  }

  void checkSelectedSpaceDetail(BuildContext context, ReservationFormState state) {
    if (state.currentSelectedSpace == null) {
      context.read<ReservationFormBloc>().add(ReservationFormEvent.spaceDetailChanged(widget.selectedSpace));
      if (state.currentSelectedSpaceOption == null) {
        context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(widget.selectedSportSpace));
      }
    }
    print(state.currentSelectedSpaceOption);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.model.mobileBackgroundColor,
        appBar: AppBar(
        backgroundColor: widget.model.mobileBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: widget.model.paletteColor
        ),
      ),
      body: BlocConsumer<ReservationFormBloc, ReservationFormState>(
        listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
        listener: (context, state) {

        },
          buildWhen: (p, c) => p.currentSelectedSpaceOption != c.currentSelectedSpaceOption || p.currentSelectedSpace != c.currentSelectedSpace || p.newFacilityBooking != c.newFacilityBooking,
        builder: (context, state) {
          checkSelectedSpaceDetail(context, state);

          return Container(
            child: Stack(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: getMainContainer(context),
                ),
                Positioned(
                  bottom: 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      color: widget.model.accentColor,
                      height: isShowingFeeDetails ? 500 : 110,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])) InkWell(
                                          onTap: () {
                                            setState(() {
                                              isShowingFeeDetails = !isShowingFeeDetails;
                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: widget.model.paletteColor
                                            ),
                                            child: Icon(
                                              isShowingFeeDetails ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up_rounded,
                                              color: widget.model.accentColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (!(checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []))) Expanded(
                                          child: Row(
                                            children: [
                                              Text(completeTotalPriceWithCurrency(double.parse(getPricingForSlot(widget.listing.listingRulesService.pricingRuleSettings, widget.listing.listingRulesService.isPricingRuleFixed, widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(), context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId ?? UniqueId())), widget.listing.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                              const SizedBox(width: 4),
                                              Expanded(child: Text('per slot', style: TextStyle(color: widget.model.paletteColor,), maxLines: 1, overflow: TextOverflow.ellipsis,))
                                            ],
                                          ),
                                        ),
                                        if (checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])) Expanded(
                                          child: getTotalPriceOnly(
                                              widget.model,
                                              context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem,
                                              context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [],
                                              numberOfSlotsSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem),
                                              widget.listing.listingProfileService.backgroundInfoServices.currency
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])) {
                                          widget.didSaveReservation(context.read<ReservationFormBloc>().state.newFacilityBooking);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        color: checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []) ? widget.model.paletteColor : Colors.transparent,
                                        border: Border.all(color: widget.model.paletteColor, width: 0.5),
                                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []) ? 'Save' : 'Select Slots', style: TextStyle(color: checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                          Visibility(
                            visible: isShowingFeeDetails,
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                Divider(color: widget.model.paletteColor),
                                const SizedBox(height: 5),

                                Container(
                                  height: 390,
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    child: viewListOfSelectedSlots(
                                      context,
                                      widget.model,
                                      [],
                                      context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem,
                                      context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [],
                                      true,
                                      AppLocalizations.of(context)!.profileFacilitySlotTime,
                                      AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                                      AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                                      widget.listing,
                                      didSelectReservation: (e) {
                                        setState(() {
                                          _calendarController?.selectedDate = e.selectedDate;
                                        });
                                      },
                                      didSelectCancelResSlot: (e, f) {
                                        setState(() {});
                                      },
                                      didSelectRemoveResSlot: (e, f) {
                                        setState(() {
                                          final List<ReservationSlotItem> slotItems = [];
                                          final List<ReservationTimeFeeSlotItem> timeSlotItems = [];
                                          final ReservationTimeFeeSlotItem newTime = ReservationTimeFeeSlotItem(slotRange: DateTimeRange(
                                                  start: e.slotRange.start,
                                                  end: e.slotRange.start.add(Duration(minutes: durationType))),
                                              fee: e.fee);

                                          slotItems.addAll(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem);

                                          if (context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem.where((element) =>
                                          element.selectedActivityType == (f.selectedActivityType) && element.selectedDate == (f.selectedDate) &&
                                              element.selectedSpaceId == (f.selectedSpaceId) &&
                                              element.selectedSportSpaceId == f.selectedSportSpaceId).isNotEmpty) {
                                            timeSlotItems.addAll(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem.where((element) =>
                                            element.selectedActivityType == (f.selectedActivityType) &&
                                                element.selectedDate == (f.selectedDate) &&
                                                element.selectedSpaceId == (f.selectedSpaceId) &&
                                                element.selectedSportSpaceId == f.selectedSportSpaceId).first.selectedSlots);
                                          }

                                          late ReservationSlotItem newSlot = ReservationSlotItem(
                                              selectedActivityType: f.selectedActivityType,
                                              selectedSpaceId: f.selectedSpaceId,
                                              selectedSportSpaceId: f.selectedSportSpaceId,
                                              selectedDate: f.selectedDate,
                                              selectedSlots: timeSlotItems);

                                          if (slotItems.where((element) =>
                                              element.selectedActivityType == newSlot.selectedActivityType &&
                                              element.selectedDate == newSlot.selectedDate &&
                                              element.selectedSpaceId == newSlot.selectedSpaceId &&
                                              element.selectedSportSpaceId == newSlot.selectedSportSpaceId).isNotEmpty) {
                                            /// use existing slot item to replace reservation slot item with new slot time list (which will either remove or add a new slot time depending on existing list already containing or not containing time slot item)
                                            if (timeSlotItems.map((e) => e.slotRange.start).contains(newTime.slotRange.start)) {
                                              timeSlotItems.remove(newTime);
                                            } else {
                                              timeSlotItems.add(newTime);
                                            }

                                            newSlot = newSlot.copyWith(selectedSlots: timeSlotItems);

                                            final int indexForSlot = slotItems.indexWhere((element) =>
                                                element.selectedActivityType == newSlot.selectedActivityType &&
                                                element.selectedDate == newSlot.selectedDate &&
                                                element.selectedSpaceId == newSlot.selectedSpaceId &&
                                                element.selectedSportSpaceId == newSlot.selectedSportSpaceId);

                                            slotItems.replaceRange(indexForSlot, indexForSlot + 1, [newSlot]);
                                          } else {
                                            /// create a new reservation slot item if slot item is not already contained
                                            newSlot = newSlot.copyWith(selectedSlots: [newTime]);
                                            slotItems.add(newSlot);
                                          }

                                          context.read<ReservationFormBloc>()..add(ReservationFormEvent.updateBookingItemList(slotItems, widget.listing.listingProfileService.backgroundInfoServices.currency));
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  )
              ],
            ),
          );
        }
      ),
    );
  }
}