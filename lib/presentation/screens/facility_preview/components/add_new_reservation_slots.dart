import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:check_in_facade/check_in_facade.dart' as facade;

class AddNewReservationSlots extends StatefulWidget {

  final DashboardModel model;
  final bool isPopOver;
  final ListingManagerForm listing;
  final ReservationItem selectedFacilityBooking;
  final UserProfileModel listingOwnerProfile;
  final List<ReservationItem> reservations;
  final SpaceOption selectedSpace;
  final SpaceOptionSizeDetail? selectedSportSpace;
  final FacilityActivityCreatorForm? selectedListingActivityOption;
  final Function(ReservationItem) didSaveReservation;

  const AddNewReservationSlots({super.key, required this.model, required this.listing, required this.reservations, required this.didSaveReservation, required this.selectedSpace, required this.selectedSportSpace, required this.listingOwnerProfile, this.selectedListingActivityOption, required this.selectedFacilityBooking, required this.isPopOver});

  @override
  State<AddNewReservationSlots> createState() => _AddNewReservationSlotsState();
}

class _AddNewReservationSlotsState extends State<AddNewReservationSlots> {

  ScrollController? _scrollController;
  DateRangePickerController? _calendarController;
  DateTime? currentDateTime;
  // int durationType = 30;
  bool isShowingFeeDetails = false;
  UniqueId? selectedActivityType;
  SpaceOption? currentSelectedSpace;
  SpaceOptionSizeDetail? currentSelectedSpaceOption;
  FacilityActivityCreatorForm? currentListingActivityOption;
  ReservationItem? currentFacilityBooking;


  @override
  void initState() {
    _calendarController = DateRangePickerController();
    _scrollController = ScrollController();
    currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    currentSelectedSpaceOption = widget.selectedSportSpace;
    currentSelectedSpace = widget.selectedSpace;
    currentListingActivityOption = widget.selectedListingActivityOption;
    currentFacilityBooking = widget.selectedFacilityBooking;

    super.initState();
  }

  @override
  void dispose() {
    _calendarController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  Widget getMainContainer(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isPopOver) Column(
                children: [
                  Text('How Will You Use The Space?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  if (currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isNotEmpty ?? false) ...?currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.map(
                      (e) => getActivityTypeTabOption(
                      context,
                      widget.model,
                      100,
                      ((currentListingActivityOption ?? FacilityActivityCreatorForm.empty()) == e),
                      e.activity
                    )
                  ).toList(),

                  if (currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty ?? false || currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty == null) getActivityTypeTabOption(
                      context,
                      widget.model,
                      100,
                      false,
                      FacilityActivityCreatorForm.empty().activity
                  ),

                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                ],
              ),


              Text('Select a Space', style: TextStyle(
                  color: widget.model.paletteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.model.questionTitleFontSize)),
              const SizedBox(height: 4),
              spaceOptionsForListingToSelect(
                  context,
                  widget.model,
                  widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
                  currentSpace: currentSelectedSpace ?? widget.selectedSpace,
                  currentSpaceOption: currentSelectedSpaceOption ?? widget.selectedSportSpace,
                  didSelectSpace: (space) {
                    setState(() {
                      currentSelectedSpace = space;
                      currentSelectedSpaceOption = space.quantity[0];
                    });
                  },
                  didSelectSpaceOption: (spaceOption) {
                    setState(() {
                      currentSelectedSpaceOption = spaceOption;
                    });
                  }),
              const SizedBox(height: 5),
              Divider(color: widget.model.paletteColor),
              const SizedBox(height: 5),
              Text('Available Slot Times', style: TextStyle(
                  color: widget.model.paletteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.model.questionTitleFontSize)),
              const SizedBox(height: 8),
            ],
          )
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            child: Container(
              color: widget.model.webBackgroundColor,
              child: Column(
                children: [
                  selectedCalendarDatesSlotReservations(
                    widget.model,
                    DateTime.now(),
                    getClosedDatesForCalendar(
                      widget.model,
                      currentSelectedSpaceOption,
                      currentSelectedSpaceOption?.durationType ?? 30,
                      widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
                    ),
                    _calendarController,
                    widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
                    selectedDateTime: (date) {
                      setState(() {
                        currentDateTime = date;
                      });
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [],
                              currentDateTime?.weekday ?? 1).isTwentyFourHour || (!(getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isTwentyFourHour) &&
                              !(getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isClosed))),
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text('Hours on ${DateFormat.EEEE().format(currentDateTime ?? DateTime.now())}: ',
                                style: TextStyle(color: widget.model.disabledTextColor)),
                          ),
                        ),
                        Visibility(visible: getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [],
                            currentDateTime?.weekday ?? 1).isTwentyFourHour,
                          child: Text('Open All Day', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                        ),
                        Visibility(
                            visible: (!(getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isTwentyFourHour) &&
                                !(getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).isClosed)),
                            child: Expanded(
                              child: Wrap(
                                children: getDayOptionFromList(currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [], currentDateTime?.weekday ?? 1).hoursOpen.map(
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
                ],
              ),
            ),
          ),
        ),
        SliverList(
        delegate: SliverChildListDelegate(
          [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // const SizedBox(height: 5),
                //
                // selectedCalendarDatesSlotReservations(
                //     widget.model,
                //     DateTime.now(),
                //     getClosedDatesForCalendar(
                //       widget.model,
                //       currentSelectedSpaceOption,
                //       currentSelectedSpaceOption?.durationType ?? 30,
                //       widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
                //     ),
                //     _calendarController,
                //     widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
                //     selectedDateTime: (date) {
                //       setState(() {
                //         currentDateTime = date;
                //       });
                //     }),

                const SizedBox(height: 10),
                calendarListOfSelectableReservations(
                  context,
                  widget.model,
                  currentSelectedSpaceOption?.durationType ?? 30,
                  widget.reservations,
                  currentSelectedSpaceOption?.spaceId ?? UniqueId(),
                  getLiveCalendarList(
                    model: widget.model,
                    fee: widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
                    currency: widget.listing.listingProfileService.backgroundInfoServices.currency,
                    durationType: currentSelectedSpaceOption?.durationType ?? 30,
                    minHour: currentSelectedSpaceOption?.availabilityHoursSettings?.startHour.toInt() ?? 0,
                    maxHour: currentSelectedSpaceOption?.availabilityHoursSettings?.endHour.toInt() ?? 0,
                    weekDaysToRemove: currentSelectedSpaceOption?.availabilityHoursSettings?.hideCalendarDays ?? [],
                    currentDateTime: currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    pricingRulesSettings: widget.listing.listingRulesService.pricingRuleSettings,
                    isPricingRuleFixed: widget.listing.listingRulesService.isPricingRuleFixed,
                    startEnd: widget.listing.listingProfileService.backgroundInfoServices.startEndDate,
                    hours: currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? [],
                    spaceId: currentSelectedSpaceOption?.spaceId ?? UniqueId(),
                  ),
                  getSelectedDates(
                      currentFacilityBooking?.reservationSlotItem ?? [],
                      currentSelectedSpaceOption,
                      currentListingActivityOption,
                      currentSelectedSpace,
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
                          end: e.slotRange.start.add(Duration(minutes: currentSelectedSpaceOption?.durationType ?? 30))), fee: e.fee);

                      slotItems.addAll(currentFacilityBooking?.reservationSlotItem ?? []);

                      if ((currentFacilityBooking?.reservationSlotItem ?? []).where((element) =>
                      element.selectedActivityType == (currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId) &&
                          element.selectedDate == (currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
                          element.selectedSpaceId == (currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId) &&
                          element.selectedSportSpaceId == currentSelectedSpaceOption?.spaceId).isNotEmpty) {
                        timeSlotItems.addAll((currentFacilityBooking?.reservationSlotItem ?? []).where((element) =>
                        element.selectedActivityType == (currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId) &&
                            element.selectedDate == (currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
                            element.selectedSpaceId == (currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId) &&
                            element.selectedSportSpaceId == currentSelectedSpaceOption?.spaceId).first.selectedSlots);
                      }

                      late ReservationSlotItem newSlot = ReservationSlotItem(
                          selectedActivityType: currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId,
                          selectedSpaceId: currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId,
                          selectedSportSpaceId: currentSelectedSpaceOption!.spaceId,
                          selectedDate: currentDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), selectedSlots: timeSlotItems);

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


                      currentFacilityBooking = currentFacilityBooking?.copyWith(
                          reservationSlotItem: slotItems,
                          reservationCost: completeTotalPriceWithCurrency(getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? []) + getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? [])*CICOReservationPercentageFee + getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? [])*CICOTaxesFee, widget.listing.listingProfileService.backgroundInfoServices.currency)
                      );

                      if (widget.isPopOver == false) {
                        if (currentFacilityBooking != null && checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? [])) {
                          widget.didSaveReservation(currentFacilityBooking!);
                        }
                      }
                      // currentFacilityBooking = reservationitem;
                      // context.read<ReservationFormBloc>()..add(ReservationFormEvent.updateBookingItemList(slotItems, widget.listing.listingProfileService.backgroundInfoServices.currency));
                      // currentFacilityBooking?.reservationSlotItem.addAll(slotItems);
                      // currentFacilityBooking = currentFacilityBooking?.copyWith(
                      //     // reservationSlotItem: slotItems,
                      //     reservationCost: completeTotalPriceWithCurrency(getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? []) + getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? [])*CICOReservationPercentageFee + getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? [])*CICOTaxesFee, widget.listing.listingProfileService.backgroundInfoServices.currency)
                      // );
                    });
                  },
                ),

                const SizedBox(height: 120)
                ],
              ),
            ]
          )
        )
      ]
    );
  }

  void checkSelectedSpaceDetail(BuildContext context, SpaceOption? currentSelectedSpaceOnLoad, SpaceOptionSizeDetail? currentSelectedSpaceOptionOnLoad) {
      currentSelectedSpace ??= currentSelectedSpaceOnLoad;
      currentSelectedSpaceOption ??= currentSelectedSpaceOptionOnLoad;
  }


  @override
  Widget build(BuildContext context) {

    // checkSelectedSpaceDetail(context, currentSelectedSpace, currentSelectedSpaceOption);

    return Scaffold(
      backgroundColor: (widget.isPopOver) ? widget.model.mobileBackgroundColor : Colors.transparent,
        appBar: (widget.isPopOver) ? AppBar(
        backgroundColor: widget.model.mobileBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: widget.model.paletteColor
        ),
      ) : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: getMainContainer(context),
                  ),
                  if (widget.isPopOver) AnimatedContainer(
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
                                      if (checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? [])) InkWell(
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
                                      if (!(checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? []))) Expanded(
                                        child: Row(
                                          children: [
                                            Text(completeTotalPriceWithCurrency(double.parse(getPricingForSlot(widget.listing.listingRulesService.pricingRuleSettings, widget.listing.listingRulesService.isPricingRuleFixed, widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(), currentSelectedSpaceOption?.spaceId ?? UniqueId())), widget.listing.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 4),
                                            Expanded(child: Text('per slot', style: TextStyle(color: widget.model.paletteColor,), maxLines: 1, overflow: TextOverflow.ellipsis,))
                                          ],
                                        ),
                                      ),
                                      if (checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? [])) Expanded(
                                        child: getTotalPriceOnly(
                                            widget.model,
                                            currentFacilityBooking?.reservationSlotItem ?? [],
                                            widget.selectedFacilityBooking.cancelledSlotItem ?? [],
                                            numberOfSlotsSelected(currentFacilityBooking?.reservationSlotItem ?? []),
                                            widget.listing.listingProfileService.backgroundInfoServices.currency
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (currentFacilityBooking != null && checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? [])) {
                                        widget.didSaveReservation(currentFacilityBooking!);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 220,
                                    decoration: BoxDecoration(
                                      color: checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? []) ? widget.model.paletteColor : Colors.transparent,
                                      border: Border.all(color: widget.model.paletteColor, width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? []) ? 'Save' : 'Select Slots', style: TextStyle(color: checkIfReservationSelected(currentFacilityBooking?.reservationSlotItem ?? [], widget.selectedFacilityBooking.cancelledSlotItem ?? []) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        if (widget.isPopOver) Visibility(
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
                                    currentFacilityBooking?.reservationSlotItem ?? [],
                                    widget.selectedFacilityBooking.cancelledSlotItem ?? [],
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
                                                end: e.slotRange.start.add(Duration(minutes: currentSelectedSpaceOption?.durationType ?? 30))),
                                            fee: e.fee);

                                        slotItems.addAll(currentFacilityBooking?.reservationSlotItem ??[]);

                                        if ((currentFacilityBooking?.reservationSlotItem ?? []).where((element) =>
                                        element.selectedActivityType == (f.selectedActivityType) && element.selectedDate == (f.selectedDate) &&
                                            element.selectedSpaceId == (f.selectedSpaceId) &&
                                            element.selectedSportSpaceId == f.selectedSportSpaceId).isNotEmpty) {
                                          timeSlotItems.addAll(currentFacilityBooking?.reservationSlotItem ?? [].where((element) =>
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

                                        // currentFacilityBooking = currentFacilityBooking?.copyWith(
                                        //   reservationSlotItem: slotItems,
                                        //   reservationCost: completeTotalPriceWithCurrency(getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? []) + getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? [])*CICOReservationPercentageFee + getListingTotalPriceDouble(slotItems, currentFacilityBooking?.cancelledSlotItem ?? [])*CICOTaxesFee, widget.listing.listingProfileService.backgroundInfoServices.currency)
                                        // );

                                  }
                                );
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
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 160.0; // Height of the sticky header
  @override
  double get minExtent => 160.0; // Height of the sticky header

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
}