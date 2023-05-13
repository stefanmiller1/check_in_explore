import 'dart:io';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/sign_in_loading_page.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/create_new_with_steps/create_new_main.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/add_new_reservation_slots.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/map_listing_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_where_when_pop_over.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class FacilityPreviewScreen extends StatefulWidget {

  final DashboardModel model;
  final Marker marker;
  final ListingManagerForm listing;
  final bool isAutoImplyLeading;
  final List<ReservationTimeFeeSlotItem>? selectedReservationsSlots;

  const FacilityPreviewScreen({super.key, required this.model, required this.listing, required this.marker, required this.isAutoImplyLeading, required this.selectedReservationsSlots});

  @override
  State<FacilityPreviewScreen> createState() => _FacilityPreviewScreenState();
}

class _FacilityPreviewScreenState extends State<FacilityPreviewScreen> {

  int durationType = 30;
  late ScrollController _scrollController;
  late bool isSubmittingSignIn = false;
  late bool userIsFound = false;
  late bool didAddAvailableSearchSlots = false;
  late PageController _pageController = PageController(initialPage: 0);
  late int _currentPageIndex = 0;
  ReservationMobileCreateNewMarker reservationMarker = ReservationMobileCreateNewMarker.listingDetails;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }


  void showBookingSlots(BuildContext context, ReservationFormState state, List<ReservationItem> reservations) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(bloc.optionOf(state.newFacilityBooking), bloc.optionOf(widget.listing))),
            child: AddNewReservationSlots(
              model: widget.model,
              listing: widget.listing,
              reservations: reservations,
              selectedSpace: context.read<ReservationFormBloc>().state.currentSelectedSpace ?? widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => SpaceOption.empty(), (r) => r.first),
              selectedSportSpace: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption,
              didSaveReservation: (reservation) {
                setState(() {
                  Navigator.of(context).pop();
                  context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(reservation.reservationSlotItem, widget.listing.listingProfileService.backgroundInfoServices.currency));
                });
              },
            ),
          );
        }
      )
    );
  }


  Widget getMainContainerForFacilityDetails(
      BuildContext context,
      DashboardModel model,
      ReservationFormState state,
      UserProfileModel listingProfile,
      List<ReservationItem> reservations
      ) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listingSpacesPagePreview(
                context,
                widget.model,
                400,
                _pageController,
                _currentPageIndex,
                widget.listing.listingProfileService.spaceSetting.spaceTypes.getOrCrash(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPageIndex = page;
                });
              }
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                                    Expanded(child: Text(' -- slots this week', style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1,)
                                    )
                                  ],
                                );
                              }
                              return Text(' -- open slots this week', style: TextStyle(color: widget.model.paletteColor));
                            }),
                        const SizedBox(height: 5),
                        Text('${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}', style: TextStyle(color: widget.model.paletteColor)),
                        const SizedBox(height: 10),
                        Text(widget.listing.listingProfileService.backgroundInfoServices.listingDescription.getOrCrash(), style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Uses Offered By ${listingProfile.legalName.getOrCrash()}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  if (state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isNotEmpty ?? false) ...?state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.map(
                          (e) => getActivityTypeTabOption(
                          context,
                          widget.model,
                          100,
                          ((state.currentListingActivityOption ?? FacilityActivityCreatorForm.empty()) == e),
                          e.activity
                      )
                  ).toList(),

                  if (state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty ?? false || state.currentSelectedSpaceOption?.activitySettings?.facilityActivityOptions.isEmpty == null) getActivityTypeTabOption(
                      context,
                      widget.model,
                      100,
                      false,
                      FacilityActivityCreatorForm.empty().activity
                  ),


                  /// ---------------------------------------------------- ///
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
                      currentSpace: state.currentSelectedSpace,
                      currentSpaceOption: state.currentSelectedSpaceOption,
                      didSelectSpace: (space) {
                        setState(() {
                          context.read<ReservationFormBloc>().add(ReservationFormEvent.spaceDetailChanged(space));
                          context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(space.quantity[0]));
                        });
                      },
                      didSelectSpaceOption: (spaceOption) {
                        context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(spaceOption));
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
                        reservations,
                        getReservationSlotItemForSearch(
                            context,
                            widget.selectedReservationsSlots ?? [],
                            context.read<ReservationFormBloc>().state.selectedActivityType,
                            context.read<ReservationFormBloc>().state.currentSelectedSpace?.uid,
                            context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId,
                            context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceTitle,
                        ),
                        context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [],
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
                              context.read<ReservationFormBloc>().state.selectedActivityType,
                              context.read<ReservationFormBloc>().state.currentSelectedSpace?.uid,
                              context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId,
                              context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceTitle,
                            )) {
                              AvailabilityHoursSettings? availabilityHours = widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => null, (r) => r.where((element) => element.uid == resSlotItem.selectedSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == resSlotItem.selectedSpaceId).quantity.where((element) => element.spaceId == resSlotItem.selectedSportSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == resSlotItem.selectedSpaceId).quantity.firstWhere((element) => element.spaceId == resSlotItem.selectedSportSpaceId).availabilityHoursSettings : null : null);
                              ReservationItem? reservationItem = (reservations.where((element) => element.reservationSlotItem.map((slot) => DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day)).contains(DateTime(resSlotItem.selectedDate.year, resSlotItem.selectedDate.month, resSlotItem.selectedDate.day))).isNotEmpty) ? reservations.where((element) => element.reservationSlotItem.map((slot) => DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day)).contains(DateTime(resSlotItem.selectedDate.year, resSlotItem.selectedDate.month, resSlotItem.selectedDate.day))).first : null;
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
                                        context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId ?? UniqueId()))/STRIPE_FEE_TO_CENTS)} ${NumberFormat.simpleCurrency(locale: currency).currencyName ?? ''}',
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

                            print(resSlotItems);

                            context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(resSlotItems, widget.listing.listingProfileService.backgroundInfoServices.currency));

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
                      if (context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem.isNotEmpty) Text('Selecting Add Available Slots will Remove Current Slots')
                    ],
                  ),

                  /// ---------------------------------------------------- ///
                  /// join any internal programs? ///
                  Visibility(
                      visible: reservations.where((element) => element.reservationOwnerId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid && (element.isInternalProgram ?? false)).isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Divider(color: widget.model.paletteColor),
                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Icon(Icons.wysiwyg_sharp, color: model.paletteColor,),
                              Text('${reservations.where((element) => element.reservationOwnerId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid && (element.isInternalProgram ?? false)).length} Internal Programs')
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
                        Container(
                          height: 300,
                          width: 300,
                          child: MapListingComponent(
                            locationMarker: widget.marker,
                            model: model,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 38,
                            width: 300,
                            color: model.paletteColor,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text('location will be provided after booking.', style: TextStyle(color: model.accentColor),))),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),


                  /// ---------------------------------------------------- ///
                  /// reviews/reservations - or be the first...

                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),

                  couldNotRetrieveReviews(context, model),


                  /// ---------------------------------------------------- ///
                  /// hosted by info
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),

                  getHostColumn(context, listingProfile, widget.model),

                  /// ---------------------------------------------------- ///
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  /// reserve slots
                  /// number of availability this week (or within filter date range)
                  Text('Select Booking Slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  profileSettingItemWidget(
                      widget.model,
                      Icons.calendar_today_outlined,
                      '-- Open Slots This Week',
                      true,
                      didSelectItem: () {
                        showBookingSlots(
                            context,
                            state,
                            reservations
                        );
                      }
                  ),
                  /// when a space is selected - check if that specific space has the slots selected available
                  /// highlight or give the option to add any available slots to your reservation automatically - based on the space selected.
                  /// show button - add to reservation...
                  viewListOfSelectedSlots(
                    context,
                    widget.model,
                    [],
                    context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem,
                    context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [],
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
                        getPricingWithFeeCancellation(context, widget.model, state.newFacilityBooking.reservationSlotItem,
                            widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions ?? []),
                      if ((widget.listing.listingReservationService.cancellationSetting.isAllowedTimeBasedChanges ?? false) &&
                          (widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions?.isNotEmpty ?? false))
                        getPricingWithTimeCancellation(context, widget.model, state.newFacilityBooking.reservationSlotItem, widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions ?? [])
                    ],
                  ),

                  /// ---------------------------------------------------- ///
                  /// custom rules / forms / check-ins
                  Visibility(
                    visible: widget.listing.listingReservationService.customFieldRuleSetting.isNotEmpty,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        Divider(color: widget.model.paletteColor),
                        const SizedBox(height: 5),

                        Text('Rules To Know', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                        const SizedBox(height: 4),
                        ...widget.listing.listingReservationService.customFieldRuleSetting.map(
                                (e) => Row(
                              children: [
                                Icon(getRuleTypeIcon(e.customRuleType ?? CustomRuleObjectType.checkBoxRule), color: model.paletteColor,),
                                const SizedBox(width: 5),
                                Text(e.customRuleTitleLabel, style: TextStyle(color: model.paletteColor),)
                              ],
                            )
                        ).toList()

                      ],
                    ),
                  ),

                  Visibility(
                    visible: widget.listing.listingReservationService.checkInSetting.isNotEmpty,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        Divider(color: widget.model.paletteColor),
                        const SizedBox(height: 5),

                        Text('Before You Check-In', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: model.paletteColor,),
                            const SizedBox(width: 5),
                            Text('A check-in form will have to be completed before listing begins', style: TextStyle(color: model.paletteColor),)
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


                  /// ---------------------------------------------------- ///
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  /// report

                  Row(
                    children: [
                      Icon(Icons.flag, color: model.paletteColor),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {

                        },
                        child: Text('Report This Listing', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      )
                    ],
                  ),

                  /// ---------------------------------------------------- ///
                  Container(
                    height: 120,
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget getMainContainerForPaymentReview(BuildContext context, DashboardModel model, ReservationFormState state, UserProfileModel listingProfile) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: model.mobileBackgroundColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  /// ------------------------ ///
                  /// image booking space/name/where/review
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                          children: getSpacesFromSelectedReservationSlot(context, widget.listing, state.newFacilityBooking).map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: getSelectedSpaces(context, e, widget.model),
                          )
                        ).toList()
                      ),
                    ),
                  ),

                  /// ------------------------ ///
                  /// your booking
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),

                  Text('Your Booking Slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  viewListOfSelectedSlots(
                      context,
                      widget.model,
                      [],
                      context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem,
                      context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [],
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

                  /// ------------------------ ///
                  /// choose how to pay

                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Choose How to Pay', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  /// if any payment options exist
                  /// if payment wants to be split amongst other registered CICO users

                  Column(
                    children: [
                      RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        toggleable: false,
                        value: 'FullPayment',
                        groupValue: 'FullPayment',
                        onChanged: (String? value) {

                        },
                        activeColor: model.paletteColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Row(
                          children: [
                            Icon(Icons.payments, color: model.paletteColor),
                            const SizedBox(width: 16),
                            Text('Full Payment', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        subtitle: Text('Pay the complete amount (${completeTotalPriceWithCurrency(
                                getTotalPriceDouble(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []) +
                                getTotalPriceDouble(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])*CICOReservationPercentageFee +
                                getTotalPriceDouble(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])*CICOTaxesFee, widget.listing.listingProfileService.backgroundInfoServices.currency)}) now and have your slots secured', style: TextStyle(color: model.disabledTextColor)),
                      ),
                      const SizedBox(height: 8),
                      RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        toggleable: false,
                        value: 'FullPayment',
                        groupValue: 'FullPayment',
                        onChanged: (String? value) {

                        },
                        activeColor: model.paletteColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Row(
                          children: [
                            Icon(Icons.payments_outlined, color: model.paletteColor),
                            const SizedBox(width: 16),
                            Text('Pay a bit Now, a bit Later', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        subtitle: Text('Pay half now, and the remaining balance after your first reservation has begun.', style: TextStyle(color: model.disabledTextColor)),
                      ),
                      const SizedBox(height: 8),
                      RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        toggleable: false,
                        value: 'FullPayment',
                        groupValue: 'FullPayment',
                        onChanged: (String? value) {

                        },
                        activeColor: model.paletteColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Row(
                          children: [
                            Icon(Icons.call_split, color: model.paletteColor),
                            const SizedBox(width: 16),
                            Text('Split Payment', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        subtitle: Text('Sharing the space with someone? add everyone to your list and split the payment with eachother', style: TextStyle(color: model.disabledTextColor)),
                      ),
                    ],
                  ),


                  /// ------------------------ ///
                  /// price details
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Pricing Info', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  getPricingDetails(
                      widget.model,
                      state.newFacilityBooking.reservationSlotItem,
                      state.newFacilityBooking.cancelledSlotItem ?? [],
                      numberOfSlotsSelected(state.newFacilityBooking.reservationSlotItem),
                      widget.listing.listingProfileService.backgroundInfoServices.currency
                  ),

                  /// ------------------------ ///
                  /// cencellation policy
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Cancellations', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  if (widget.listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false)
                    getPricingCancellationForNoCancellations(context, widget.model),
                  if (!(widget.listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false))
                    getPricingCancellationWithChangesCancellation(context, widget.model, widget.listing.listingReservationService.cancellationSetting.isAllowedChangeNotEarlyEnd ?? false,
                        widget.listing.listingReservationService.cancellationSetting.isAllowedEarlyEndAndChanges ?? false),
                  if ((widget.listing.listingReservationService.cancellationSetting.isAllowedFeeBasedChanges ?? false) &&
                      (widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithFeeCancellation(context, widget.model, state.newFacilityBooking.reservationSlotItem,
                        widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions ?? []),
                  if ((widget.listing.listingReservationService.cancellationSetting.isAllowedTimeBasedChanges ?? false) &&
                      (widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithTimeCancellation(context, widget.model, state.newFacilityBooking.reservationSlotItem, widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions ?? []),

                  /// ------------------------ ///
                  /// policy & guidelines
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),

                  Text('When Selecting Confirm Reservation, I agree to the Rules made by the Listing Owner, Ground Rules for Guests, Cancellatio, Rebooking, and Refunding Policy defined by CICO and the Listing Owner.', style: TextStyle(color: model.disabledTextColor)),
                  const SizedBox(height: 34),
                ],
              ),
            ),


            Container(
              height: 10,
              color: model.accentColor,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: retrieveAuthenticationState(
                context,
                state,
                listingProfile
              ),
            ),

            const SizedBox(height: 120)
          ],
        )
      ),
    );
  }


  Widget getBottomContainer(BuildContext context, ReservationMobileCreateNewMarker marker, ReservationFormState  state, List<ReservationItem> reservations, UserProfileModel listingOwnerProfile) {
    switch (marker) {

      case ReservationMobileCreateNewMarker.listingDetails:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!(checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []))) Expanded(
                child: Container(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(completeTotalPriceWithCurrency(double.parse(getPricingForSlot(widget.listing.listingRulesService.pricingRuleSettings, widget.listing.listingRulesService.isPricingRuleFixed, widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(), context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId ?? UniqueId())), widget.listing.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Expanded(child: Text('per slot', style: TextStyle(color: widget.model.paletteColor,), maxLines: 1, overflow: TextOverflow.ellipsis,))
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('dates', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),

              if (checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])) Expanded(
                child: Container(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          getTotalPriceOnly(
                              widget.model,
                              state.newFacilityBooking.reservationSlotItem,
                              state.newFacilityBooking.cancelledSlotItem ?? [],
                              numberOfSlotsSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem),
                              widget.listing.listingProfileService.backgroundInfoServices.currency
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('dates', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {

                    switch (reservationMarker) {

                      case ReservationMobileCreateNewMarker.listingDetails:
                        if (!(checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []))) {
                          showBookingSlots(
                              context,
                              state,
                              reservations
                          );
                        } else if (state.newFacilityBooking.customFieldRuleSetting?.isNotEmpty ?? false) {
                          reservationMarker = ReservationMobileCreateNewMarker.additionalDetails;
                        } else {
                          reservationMarker = ReservationMobileCreateNewMarker.paymentReview;
                        }
                        break;
                      case ReservationMobileCreateNewMarker.additionalDetails:
                      // TODO: Handle this case.
                        break;
                      case ReservationMobileCreateNewMarker.paymentReview:
                      // TODO: Handle this case.
                        break;
                      case ReservationMobileCreateNewMarker.listingNoLongerAvailable:
                      // TODO: Handle this case.
                        break;
                    }

                  });
                },
                child: Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    color: widget.model.paletteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text((checkIfReservationSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])) ? 'Book Now' : 'Select Slots', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                    ),
                  ),
                ),
              ),
            ],
          );
      case ReservationMobileCreateNewMarker.additionalDetails:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    reservationMarker = ReservationMobileCreateNewMarker.listingDetails;
                  });
                },
              icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor)
            )
          ],
        );
        break;
      case ReservationMobileCreateNewMarker.paymentReview:
        break;
      case ReservationMobileCreateNewMarker.listingNoLongerAvailable:
        break;
    }
    return Container();
  }


  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
        startingOpacity: 0.75,
        backgroundColor: Colors.transparent,
        direction: DismissiblePageDismissDirection.startToEnd,
        isFullScreen: true,
        onDismissed: () {
          Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: widget.model.paletteColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: widget.isAutoImplyLeading,
            centerTitle: true,
            toolbarHeight: widget.isAutoImplyLeading ? 60 : 0 ,
            title: Text(getAppBarTitle(reservationMarker)),
            titleTextStyle: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
            actions: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
              const SizedBox(width: 10),
            ],
          ),
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
              BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([widget.listing.listingServiceId.getOrCrash()], null, null, [ReservationSlotState.requested, ReservationSlotState.cancelled, ReservationSlotState.refunded, ReservationSlotState.current, ReservationSlotState.completed]))),
              BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash()))),
              BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(bloc.optionOf(ReservationItem(
                reservationId: ReservationItem.empty().reservationId,
                reservationOwnerId: UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
                instanceId: widget.listing.listingServiceId,
                reservationCost: widget.listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
                reservationState: (widget.listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false) ? ReservationSlotState.requested : ReservationSlotState.confirmed,
                paymentStatus: ReservationItem.empty().paymentStatus,
                paymentIntentId: ReservationItem.empty().paymentIntentId,
                reservationSlotItem: [],
                customFieldRuleSetting: widget.listing.listingReservationService.customFieldRuleSetting,
                dateCreated: ReservationItem.empty().dateCreated,
                )),
                bloc.optionOf(widget.listing)))),
            ],
            child: retrieveExistingReservations(),
        ),
      ),
    );
  }


  Widget retrieveExistingReservations() {
    return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            resLoadInProgress: (_) => progressOverlay(widget.model),
            loadReservationListSuccess: (e) => retrieveFacilityOwner(e.item),
            loadReservationListFailure: (_) => retrieveFacilityOwner([]),
            ///TODO: add failure of type empty
            /// if network call cant be made you should not be allowed to make any new reservation
            orElse: () => retrieveFacilityOwner([]));
      },
    );
  }

  Widget retrieveFacilityOwner(List<ReservationItem> reservations) {
    return BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
        loadInProgress: (_) => loadingListingProfile(widget.listing),
        loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
        loadSelectedProfileSuccess: (item) => retrieveMainContainerForReservation(reservations, item.profile),
        orElse: () => couldNotRetrieveListingProfile()
      );
    });
  }

  Widget retrieveAuthenticationState(BuildContext context, ReservationFormState  state, UserProfileModel listingOwnerProfile) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
            loadInProgress: (_) => loadingConfirmReservation(),
            loadProfileFailure: (_) => GetLoginSignUpWidget(model: widget.model),
            loadUserProfileSuccess: (item) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          reservationMarker = ReservationMobileCreateNewMarker.listingDetails;
                        });
                      },
                    icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor)
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         context.read<AuthBloc>()..add(const AuthEvent.signedOut());
                  //       });
                  //     },
                  //     icon: Icon(Icons.outbond_rounded, color: widget.model.paletteColor)
                  // ),

                  if (!(context.read<ReservationFormBloc>().state.isSubmitting)) InkWell(
                    onTap: () {
                      context.read<ReservationFormBloc>().add(ReservationFormEvent.isFinishedCreatingBooking(
                          item.profile,
                          (getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) + getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOReservationPercentageFee + getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOTaxesFee).toString(),
                          (NumberFormat.simpleCurrency(locale: widget.listing.listingProfileService.backgroundInfoServices.currency).currencyName ?? 'cad').toLowerCase(),
                          null,
                          widget.listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false)
                      );
                    },
                    child: Container(
                      height: 60,
                      // width: 200,
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Confirm Reservation', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                        ),
                      ),
                    ),
                  ),

                  if (context.read<ReservationFormBloc>().state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor, radius: 8)
                ],
              );
            },
            orElse: () => GetLoginSignUpWidget(model: widget.model)
          );
        },
      ),
    );
  }


  Widget retrieveMainContainerForReservation(List<ReservationItem> reservations, UserProfileModel listingOwnerProfile) {
    return BlocConsumer<ReservationFormBloc, ReservationFormState>(
      listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
                () {},
                (either) => either.fold((failure) {

              final snackBar = SnackBar(
                  backgroundColor: widget.model.webBackgroundColor,
                  content: failure.maybeMap(
                    invalidDate: (_) => Text('Sorry, the Date(s) You Have Selected are Conflicting', style: TextStyle(color: widget.model.disabledTextColor)),
                    waitingForPaymentConfirmation: (_) => Text('Waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                    // waitingForPaymentConfirmation: (_) => Text('Sorry, You will Need to first Agree to the Terms and Conditions Before Completing Your Reservation', style: TextStyle(color: widget.model.disabledTextColor)),
                    paymentResultError: (_) => Text('Please Fill Out Payment Method Details', style: TextStyle(color: widget.model.disabledTextColor)),
                    // cancelled: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle( color: widget.model.disabledTextColor)),

                    reservationServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                    orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                  ));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (_) {

              // final snackBar = SnackBar(
              //     elevation: 4,
              //     backgroundColor: widget.model.paletteColor,
              //     /// booking successful - confirmation e-mail sent!
              //     content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // Navigator.of(context).pop(context);
            }));

        state.authPaymentFailureOrSuccessOption.fold(
          () => {},
          (either) => either.fold(
            (failure) {
              final snackBar = SnackBar(
                  backgroundColor: widget.model.webBackgroundColor,
                  content: failure.maybeMap(
                    couldNotRetrievePaymentMethod: (_) => Text('Could not retrieve payment details', style: TextStyle(color: widget.model.disabledTextColor)),
                    paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                    orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                )
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (success) {
             
              Navigator.of(context).pop();

            }
          )
        );
      },
      buildWhen: (p,c) =>  p.newFacilityBooking != c.newFacilityBooking ||
        p.isTermsConditionsAccepted != c.isTermsConditionsAccepted ||
        p.currentSelectedSpace != c.currentSelectedSpace ||
        p.currentSelectedSpaceOption != c.currentSelectedSpaceOption ||
        p.cardItem != c.cardItem ||
        p.isSavingCard != c.isSavingCard ||
        p.isSubmitting != c.isSubmitting,
      builder: (context, state) {

        List<NewReservationModel> reservationContainerModel = [
          NewReservationModel(
            markerItem: ReservationMobileCreateNewMarker.listingDetails,
              childWidget: getMainContainerForFacilityDetails(
                context,
                widget.model,
                state,
                listingOwnerProfile,
                reservations)
          ),
          NewReservationModel(markerItem: ReservationMobileCreateNewMarker.additionalDetails, childWidget: InkWell(
            onTap: () {Navigator.of(context).pop();},
              child: Container(color: Colors.red,))),
          NewReservationModel(
              markerItem: ReservationMobileCreateNewMarker.paymentReview,
              childWidget: getMainContainerForPaymentReview(
                  context,
                  widget.model,
                  state,
                  listingOwnerProfile)
          ),
        ];
        if (context.read<ReservationFormBloc>().state.currentSelectedSpace == null && context.read<ReservationFormBloc>().state.currentSelectedSpaceOption == null) {
          (context.read<ReservationFormBloc>().add(ReservationFormEvent.spaceDetailChanged(widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)[0])));
          context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(widget.listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)[0].quantity[0]));
        }

        return Stack(
          children: [
            CreateNewMain(
                child: reservationContainerModel.firstWhere((element) => element.markerItem == reservationMarker).childWidget),

            if (reservationMarker != ReservationMobileCreateNewMarker.paymentReview) Positioned(
                bottom: 0,
                child: Container(
                  color: widget.model.accentColor,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: getBottomContainer(
                        context,
                        reservationMarker,
                        state,
                        reservations,
                        listingOwnerProfile
                  )
                ),
              )
            )
          ],
        );
      }
    );
  }
}