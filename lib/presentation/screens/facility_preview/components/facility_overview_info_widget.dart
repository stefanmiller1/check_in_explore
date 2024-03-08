import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/map_listing_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_components/listing_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FacilityOverviewInfoWidget extends StatefulWidget {

  final DashboardModel model;
  final FacilityPreviewState overViewState;
  final UniqueId? selectedActivityType;
  final SpaceOption? currentSelectedSpace;
  final SpaceOptionSizeDetail? currentSelectedSpaceOption;
  final FacilityActivityCreatorForm? currentListingActivityOption;
  final ListingManagerForm listing;
  final ReservationItem newFacilityBooking;
  final List<ReservationItem> reservations;
  final UserProfileModel listingOwnerProfile;
  final List<ReservationTimeFeeSlotItem>? selectedReservationsSlots;
  final Marker marker;
  final bool isAttendee;
  final Function() didSelectItem;
  final Function(SpaceOption) didSelectSpace;
  final Function(SpaceOptionSizeDetail) didSelectSpaceOption;
  final Function(List<ReservationSlotItem> slotItem, String currency) updateBookingItemList;

  const FacilityOverviewInfoWidget({super.key, required this.model, required this.reservations, required this.listingOwnerProfile, required this.listing, this.selectedReservationsSlots, required this.marker, required this.didSelectItem, this.currentSelectedSpace, this.currentSelectedSpaceOption, this.currentListingActivityOption, required this.newFacilityBooking, this.selectedActivityType, required this.didSelectSpace, required this.didSelectSpaceOption, required this.updateBookingItemList, required this.overViewState, required this.isAttendee});

  @override
  State<FacilityOverviewInfoWidget> createState() => _FacilityOverviewInfoWidgetState();
}

class _FacilityOverviewInfoWidgetState extends State<FacilityOverviewInfoWidget> {

  int durationType = 30;
  late int _currentPageIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);
  late bool didAddAvailableSearchSlots = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kIsWeb) const SizedBox(height: 80),
        if (!(kIsWeb)) const SizedBox(height: 155),
        SizedBox(
          height: 285,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: listingSpacesPagePreview(
                context,
                widget.model,
                400,
                _pageController,
                _currentPageIndex,
                widget.listing.listingProfileService.spaceSetting.spaceTypes.getOrCrash(),
                true,
                onPageChanged: (page, spaceOption) {
                  setState(() {
                    _currentPageIndex = page;
                  });
                },
                didSelectItem: () {

                },
            ),
          ),
        ),

        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    FutureBuilder<double?>(
                        future: MapHelper.determineDistanceAway(widget.marker.position),
                        initialData: 0,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return Row(
                              children: [
                                Text('Around ${snap.data?.toInt()}m away •', style: TextStyle(color: widget.model.disabledTextColor)),
                                const SizedBox(width: 10),
                                // Expanded(child: Text(' -- slots this week', style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1,)
                                // )
                              ],
                            );
                          }
                          return Container();
                        }),
                    const SizedBox(height: 5),
                    Text('${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}', style: TextStyle(color: widget.model.paletteColor)),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: widget.overViewState == FacilityPreviewState.listing,
                        child: Text(widget.listing.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2)),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Visibility(
                  visible: widget.overViewState == FacilityPreviewState.listing,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: widget.model.paletteColor),
                      const SizedBox(height: 5),
                      Text('Uses Offered By ${widget.listingOwnerProfile.legalName.getOrCrash()}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      if (widget.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isNotEmpty ?? false) ...?widget.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.map(
                              (e) => getActivityTypeTabOption(
                              context,
                              widget.model,
                              80,
                              ((widget.currentListingActivityOption ?? FacilityActivityCreatorForm.empty()) == e),
                              e.activity
                          )
                      ).toList(),

                      if (widget.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty ?? false || widget.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty == null) getActivityTypeTabOption(
                          context,
                          widget.model,
                          80,
                          false,
                          FacilityActivityCreatorForm.empty().activity
                      ),
                  ],
                )
              ),


              /// ---------------------------------------------------- ///
              Visibility(
                  visible: widget.overViewState == FacilityPreviewState.listing,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Divider(color: widget.model.paletteColor),
                      const SizedBox(height: 5),
                      Text('Available Spaces', style: TextStyle(
                          color: widget.model.paletteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.model.questionTitleFontSize)),
                      const SizedBox(height: 4),
                      spaceOptionsForListingToSelect(
                          context,
                          widget.model,
                          widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r),
                          currentSpace: widget.currentSelectedSpace,
                          currentSpaceOption: widget.currentSelectedSpaceOption,
                          didSelectSpace: (space) {
                            widget.didSelectSpace(space);
                          },
                          didSelectSpaceOption: (spaceOption) {
                            widget.didSelectSpaceOption(spaceOption);
                          }),
                      /// show slots from search for selected space ///
                      if (widget.selectedReservationsSlots?.isNotEmpty ?? false)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12.5),
                            Text('Slots From Your Search Filter', style: TextStyle(color: widget.model.disabledTextColor),),
                            /// available
                            viewListOfSelectedSlots(
                                context,
                                widget.model,
                                widget.reservations,
                                getReservationSlotItemForSearch(
                                  context,
                                  widget.selectedReservationsSlots ?? [],
                                  widget.selectedActivityType,
                                  widget.currentSelectedSpace?.uid,
                                  widget.currentSelectedSpaceOption?.spaceId,
                                  widget.currentSelectedSpaceOption?.spaceTitle,
                                ),
                                widget.newFacilityBooking.cancelledSlotItem ?? [],
                                false,
                                AppLocalizations.of(context)!.profileFacilitySlotTime,
                                AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                                AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                                widget.listing,
                                didSelectReservation: (e) {
                                },
                                didSelectCancelResSlot: (e, f) {
                                  setState(() {});
                                },
                                didSelectRemoveResSlot: (e, f) {

                                }
                            ),


                            InkWell(
                                onTap: () {

                                  setState(() {
                                    didAddAvailableSearchSlots = true;

                                    List<ReservationSlotItem> resSlotItems = [];


                                    for (ReservationSlotItem resSlotItem in getReservationSlotItemForSearch(
                                      context,
                                      widget.selectedReservationsSlots ?? [],
                                      widget.selectedActivityType,
                                      widget.currentSelectedSpace?.uid,
                                      widget.currentSelectedSpaceOption?.spaceId,
                                      widget.currentSelectedSpaceOption?.spaceTitle,
                                    )) {
                                      AvailabilityHoursSettings? availabilityHours = widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => null, (r) => r.where((element) => element.uid == resSlotItem.selectedSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == resSlotItem.selectedSpaceId).quantity.where((element) => element.spaceId == resSlotItem.selectedSportSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == resSlotItem.selectedSpaceId).quantity.firstWhere((element) => element.spaceId == resSlotItem.selectedSportSpaceId).availabilityHoursSettings : null : null);
                                      ReservationItem? reservationItem = (widget.reservations.where((element) => element.reservationSlotItem.map((slot) => DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day)).contains(DateTime(resSlotItem.selectedDate.year, resSlotItem.selectedDate.month, resSlotItem.selectedDate.day))).isNotEmpty) ? widget.reservations.where((element) => element.reservationSlotItem.map((slot) => DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day)).contains(DateTime(resSlotItem.selectedDate.year, resSlotItem.selectedDate.month, resSlotItem.selectedDate.day))).first : null;
                                      List<ReservationTimeFeeSlotItem> slotItems = [];
                                      final String currency = widget.listing.listingProfileService.backgroundInfoServices.currency;
                                      var numberFormat = NumberFormat('#,##0.00', currency);

                                      for (ReservationTimeFeeSlotItem timeSlot in resSlotItem.selectedSlots) {

                                        /// TODO: *** CREATE FUNCTION FOR GENERATING FEE BASED ON SELECTED SPACE FEE
                                        slotItems.add(ReservationTimeFeeSlotItem(
                                            fee: '${NumberFormat.simpleCurrency(locale: currency).currencySymbol}${numberFormat.format(double.parse(getPricingForSlot(
                                                widget.listing.listingRulesService.pricingRuleSettings,
                                                widget.listing.listingRulesService.isPricingRuleFixed,
                                                widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
                                                widget.currentSelectedSpaceOption?.spaceId ?? UniqueId()))/STRIPE_FEE_TO_CENTS)} ${NumberFormat.simpleCurrency(locale: currency).currencyName ?? ''}',
                                            slotRange: timeSlot.slotRange)
                                        );

                                        if (isReservationBooked(
                                            currentRes: resSlotItem,
                                            reservations: reservationItem?.reservationSlotItem ?? [],
                                            currentSlot: timeSlot,
                                            reservationTimeSlots: retrieveReservationTimeSlots(
                                                reservationItem?.reservationSlotItem ?? [], resSlotItem)) ||
                                            isSlotUnavailableBasedOnHours(availabilityHours, timeSlot) ||
                                            timeSlot.slotRange.start.isBefore(DateTime.now())
                                        ) {
                                          slotItems.removeWhere((element) => element.slotRange.start == timeSlot.slotRange.start);
                                        }

                                      }

                                      resSlotItems.add(ReservationSlotItem(
                                          selectedActivityType: resSlotItem.selectedActivityType,
                                          selectedSpaceId: resSlotItem.selectedSpaceId,
                                          selectedDate: resSlotItem.selectedDate,
                                          selectedSideOption: resSlotItem.selectedSideOption,
                                          selectedSportSpaceId: resSlotItem.selectedSportSpaceId,
                                          selectedSlots: slotItems
                                      )
                                      );
                                    }

                                    widget.updateBookingItemList(resSlotItems, widget.listing.listingProfileService.backgroundInfoServices.currency);

                                  });
                                },
                                child: Container(
                                    height: 60,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: (didAddAvailableSearchSlots) ? widget.model.accentColor : widget.model.paletteColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                                    ),
                                    child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Add Available Slots', style: TextStyle(color: (didAddAvailableSearchSlots) ? widget.model.disabledTextColor : widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                        )
                                    )
                                )
                            ),
                            /// remove all existing if slot dates already exist
                            if (widget.newFacilityBooking.reservationSlotItem.isNotEmpty) Text('Selecting Add Available Slots will Remove Current Slots')
                      ],
                    ),
                  ],
                )
              ),


              Visibility(
                visible: widget.overViewState == FacilityPreviewState.reservation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),
                    Text('Space Reserved', style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.questionTitleFontSize)),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                            children: getSpacesFromSelectedReservationSlot(context, widget.listing, widget.newFacilityBooking).map(
                                    (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: getSelectedSpaces(context, e, widget.model),
                                )
                            ).toList()
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),
                    ListTile(
                      leading: Icon(Icons.calendar_today_outlined, color: widget.model.paletteColor),
                      title: Text('Dates Booked', style: TextStyle(color: widget.model.paletteColor)),
                      trailing: (widget.newFacilityBooking.reservationState == ReservationSlotState.completed) ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: widget.model.paletteColor
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Completed', style: TextStyle(color: widget.model.accentColor, fontSize: 14, fontWeight: FontWeight.bold,))
                          )
                      ) : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: widget.model.accentColor
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: (getNumberOfSlotsToGo(widget.newFacilityBooking) == 1) ? Text('${getNumberOfSlotsToGo(widget.newFacilityBooking)} Slot Remaining', style: TextStyle(color: widget.model.disabledTextColor, fontSize: 14, fontWeight: FontWeight.bold,)) : Text('${getNumberOfSlotsToGo(widget.newFacilityBooking)} Slots Remaining', style: TextStyle(color: widget.model.paletteColor, fontSize: 14, fontWeight: FontWeight.bold,))
                        )
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 470
                            ),
                            child: viewListOfSelectedSlots(
                                context,
                                widget.model,
                                [],
                                widget.newFacilityBooking.reservationSlotItem,
                                widget.newFacilityBooking.cancelledSlotItem ?? [],
                                false,
                                AppLocalizations.of(context)!.profileFacilitySlotTime,
                                AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                                AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                                widget.listing,
                                didSelectReservation: (e) {
                                },
                                didSelectCancelResSlot: (e, f) {
                                },
                                didSelectRemoveResSlot: (e, f) {
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),

              /// ---------------------------------------------------- ///
              /// join any internal programs? ///
              Visibility(
                  visible: widget.reservations.where((element) => element.reservationOwnerId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner || (element.isInternalProgram == true)).isNotEmpty,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Divider(color: widget.model.paletteColor),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(Icons.wysiwyg_sharp, color: widget.model.paletteColor,),
                          Text('${widget.reservations.where((element) => element.reservationOwnerId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner || (element.isInternalProgram == true)).length} Internal Programs')
                      ],
                    )
                  ],
                )
              ),


              /// ---------------------------------------------------- ///
              /// background... ///
              const SizedBox(height: 5),
              Divider(color: widget.model.paletteColor),
              const SizedBox(height: 5),
              Text(widget.listing.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),


              /// ---------------------------------------------------- ///
              /// reviews/reservations - or be the first...
              Visibility(
                visible: widget.overViewState == FacilityPreviewState.listing,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),

                    couldNotRetrieveReviews(context, widget.model),

                    /// ---------------------------------------------------- ///
                    /// hosted by info
                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),

                    getHostColumn(context, widget.listingOwnerProfile, true, widget.model),

                  ],
                ),
              ),

              /// ---------------------------------------------------- ///
              /// reserve slots
              /// number of availability this week (or within filter date range)
              Visibility(
                visible: widget.overViewState == FacilityPreviewState.listing,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),
                    Text('Select Booking Slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    profileSettingItemWidget(
                        widget.model,
                        Icons.calendar_today_outlined,
                        '-- Open Slots This Week',
                        true,
                        didSelectItem: () {
                          widget.didSelectItem();
                        }
                    ),
                    /// when a space is selected - check if that specific space has the slots selected available
                    /// highlight or give the option to add any available slots to your reservation automatically - based on the space selected.
                    /// show button - add to reservation...
                    viewListOfSelectedSlots(
                      context,
                      widget.model,
                      [],
                      widget.newFacilityBooking.reservationSlotItem,
                      widget.newFacilityBooking.cancelledSlotItem ?? [],
                      false,
                      AppLocalizations.of(context)!.profileFacilitySlotTime,
                      AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                      AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                      widget.listing,
                      didSelectReservation: (e) {
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

                          slotItems.addAll(widget.newFacilityBooking.reservationSlotItem);

                          if (widget.newFacilityBooking.reservationSlotItem.where((element) =>
                          element.selectedActivityType == (f.selectedActivityType) && element.selectedDate == (f.selectedDate) &&
                              element.selectedSpaceId == (f.selectedSpaceId) &&
                              element.selectedSportSpaceId == f.selectedSportSpaceId).isNotEmpty) {
                            timeSlotItems.addAll(widget.newFacilityBooking.reservationSlotItem.where((element) =>
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

                          widget.updateBookingItemList(slotItems, widget.listing.listingProfileService.backgroundInfoServices.currency);

                        });
                      },
                    ),
                  ],
                ),
              ),


              /// ---------------------------------------------------- ///
              /// cancellation policy
              const SizedBox(height: 5),
              Divider(color: widget.model.paletteColor),
              const SizedBox(height: 5),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cancellations', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                  const SizedBox(height: 4),
                  if (widget.listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false)
                    getPricingCancellationForNoCancellations(context, widget.model),
                  if (!(widget.listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false))
                    getPricingCancellationWithChangesCancellation(context, widget.model, widget.listing.listingReservationService.cancellationSetting.isAllowedChangeNotEarlyEnd ?? false,
                        widget.listing.listingReservationService.cancellationSetting.isAllowedEarlyEndAndChanges ?? false),
                  if ((widget.listing.listingReservationService.cancellationSetting.isAllowedFeeBasedChanges ?? false) &&
                      (widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithFeeCancellation(context, widget.model, widget.newFacilityBooking.reservationSlotItem.map((e) => e.selectedDate).toList(),
                        widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions ?? []),
                  if ((widget.listing.listingReservationService.cancellationSetting.isAllowedTimeBasedChanges ?? false) &&
                      (widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithTimeCancellation(context, widget.model, widget.newFacilityBooking.reservationSlotItem.map((e) => e.selectedDate).toList(), widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions ?? [])
                ],
              ),

              /// ---------------------------------------------------- ///
              /// custom rules / forms / check-ins
              Visibility(
                visible: widget.listing.listingReservationService.customFieldRuleSetting.isNotEmpty,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),

                    Text('Rules To Know', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                    const SizedBox(height: 4),
                    ...widget.listing.listingReservationService.customFieldRuleSetting.map(
                            (e) => Row(
                          children: [
                            Icon(getRuleTypeIcon(e.customRuleType ?? CustomRuleObjectType.checkBoxRule), color: widget.model.paletteColor,),
                            const SizedBox(width: 5),
                            Text(e.customRuleTitleLabel, style: TextStyle(color: widget.model.paletteColor),)
                          ],
                        )
                    ).toList()

                  ],
                ),
              ),

              Visibility(
                visible: widget.listing.listingReservationService.checkInSetting.isNotEmpty,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Divider(color: widget.model.paletteColor),
                    const SizedBox(height: 5),

                    Text('Before You Check-In', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: widget.model.paletteColor,),
                        const SizedBox(width: 5),
                        Text('A check-in form will have to be completed before listing begins', style: TextStyle(color: widget.model.paletteColor),)
                      ],
                    )
                  ],
                ),
              ),

              /// ---------------------------------------------------- ///
              // const SizedBox(height: 5),
              // Divider(color: widget.model.paletteColor),
              // const SizedBox(height: 5),
              // /// safety & security
              //


              //// --------------------------------------------------- ///
              /// pricing ///
              Visibility(
                visible: widget.overViewState == FacilityPreviewState.reservation,
                child: Visibility(
                  visible: widget.newFacilityBooking.reservationOwnerId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: widget.model.paletteColor),
                      const SizedBox(height: 5),
                      Text('Pricing Info', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text('This is only visible to Reservation Owner.', style: TextStyle(color: widget.model.paletteColor),),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Text('Total:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize,)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(completeTotalPriceWithCurrency((getListingTotalPriceDouble(widget.newFacilityBooking.reservationSlotItem, widget.newFacilityBooking.cancelledSlotItem ?? []) +
                                getListingTotalPriceDouble(widget.newFacilityBooking.reservationSlotItem, widget.newFacilityBooking.cancelledSlotItem ?? [])*CICOReservationPercentageFee +
                                getListingTotalPriceDouble(widget.newFacilityBooking.reservationSlotItem, widget.newFacilityBooking.cancelledSlotItem ?? [])*CICOTaxesFee), widget.listing.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),

                      /// get receipt ///
                      InkWell(
                          onTap: () async {
                            if (widget.newFacilityBooking.receipt_link != null) {
                              if (kIsWeb) {
                                if (await canLaunchUrlString(widget.newFacilityBooking.receipt_link!)) {
                                  await launchUrlString(widget.newFacilityBooking.receipt_link!);
                                }
                              } else {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) {
                                    return WebViewWidgetComponent(
                                      urlString: widget.newFacilityBooking.receipt_link!,
                                      model: widget.model,
                                    );
                                  })
                                );
                              }
                            }
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.receipt_long_rounded, color: widget.model.paletteColor),
                                          const SizedBox(width: 18.0),
                                          Text('Review Receipt', style: TextStyle(color: widget.model.paletteColor)),
                                        ],
                                      ),
                                    ),
                                Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                            ]
                          )
                        )
                      ),
                    ],
                  ),
                ),
              ),


              /// ---------------------------------------------------- ///
              const SizedBox(height: 5),
              Divider(color: widget.model.paletteColor),
              const SizedBox(height: 5),
              /// location map

              Text('Where To Go', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                     ClipRRect(
                      child: SizedBox(
                        height: 275,
                        width: 550,
                        child: MapListingComponent(
                          locationMarker: widget.marker,
                          model: widget.model,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.isAttendee == false,
                      child: Positioned(
                        bottom: 0,
                        child: Container(
                          height: 38,
                          width: 550,
                          color: widget.model.paletteColor,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text('location will be provided after booking.', style: TextStyle(color: widget.model.accentColor),))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Text('${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
              Visibility(
                visible: widget.overViewState == FacilityPreviewState.reservation && widget.isAttendee,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined, color: widget.model.paletteColor),
                      title: Text('${widget.listing.listingProfileService.listingLocationSetting.street.getOrCrash()}\n${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}'),
                      subtitle: Text('Select to Copy Facility Location', style: TextStyle(color: widget.model.disabledTextColor)),
                      trailing: Icon(Icons.copy, color: widget.model.disabledTextColor),
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: '${widget.listing.listingProfileService.listingLocationSetting.street.getOrCrash()} ${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}'));
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: Text('Copied!', style: TextStyle(color: widget.model.disabledTextColor)),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                    /// show directions
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: widget.model.accentColor,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Align(
                          child: Text('Get Directions', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                )
              ),

              /// ---------------------------------------------------- ///
              const SizedBox(height: 5),
              Divider(color: widget.model.paletteColor),
              const SizedBox(height: 5),
              /// report & help

              Row(
                children: [
                  Icon(Icons.flag, color: widget.model.paletteColor),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {

                    },
                    child: Text('Report This Listing', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ),
                ],
              ),

              Visibility(
                visible: widget.overViewState == FacilityPreviewState.reservation,
                child: Visibility(
                  visible: widget.newFacilityBooking.reservationOwnerId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text('Help & Support', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 12),
                      Text('Contact us at anytime for help or support on this reservation', style: TextStyle(color: widget.model.disabledTextColor)),
                      profileSettingItemWidget(
                          widget.model,
                          Icons.verified_user,
                          'Contact CICO Support',
                          false,
                          didSelectItem: () {

                          }
                      ),

                    ],
                  ),
                ),
              ),

              /// ---------------------------------------------------- ///
              Container(
                height: 120,
              )
            ],
          ),
        ),

      ],
    );
  }
}