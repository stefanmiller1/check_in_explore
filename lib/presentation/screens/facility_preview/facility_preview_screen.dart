import 'dart:ui';

// import 'package:blur/blur.dart';
import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/add_new_reservation_slots.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/facility_activity_programming.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FacilityPreviewScreen extends StatefulWidget {

  final DashboardModel model;
  // final Marker marker;
  final UniqueId listingId;
  final ListingManagerForm? listing;
  final bool isAutoImplyLeading;
  final List<ReservationTimeFeeSlotItem>? selectedReservationsSlots;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectReservation;
  final Function() didSelectBack;

  const FacilityPreviewScreen({super.key, required this.model, required this.listing, required this.isAutoImplyLeading, required this.selectedReservationsSlots, required this.didSelectBack, required this.didSelectReservation, required this.listingId});

  @override
  State<FacilityPreviewScreen> createState() => _FacilityPreviewScreenState();
}

class _FacilityPreviewScreenState extends State<FacilityPreviewScreen> with SingleTickerProviderStateMixin {

  late TabController? _tabController;
  late ScrollController _scrollController;
  late bool isSubmittingSignIn = false;
  late bool userIsFound = false;
  ListingOverviewMarker listingOverviewMarker = ListingOverviewMarker.listing;
  ReservationMobileCreateNewMarker reservationMarker = ReservationMobileCreateNewMarker.listingDetails;
  late PageController? pageController;

  @override
  void initState() {
    _scrollController = ScrollController();
    pageController = PageController(initialPage: 0, keepPage: true);
    _tabController = TabController(initialIndex: 0, length: ListingOverviewMarker.values.length, vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleCreateCheckOutForWeb(BuildContext context, UserProfileModel currentUser, UserProfileModel owner, ReservationFormState state, ListingManagerForm listing) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        width: 600,
                        height: 750,
                        child: WebCheckOutPaymentWidget(
                            model: widget.model,
                            currentUser: currentUser,
                            ownerUser: owner,
                            reservation: state.newFacilityBooking,
                            amount: completeTotalPriceForCheckoutFormat(getListingTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) + getListingTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOReservationPercentageFee + getListingTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOTaxesFee, listing.listingProfileService.backgroundInfoServices.currency),
                            currency: listing.listingProfileService.backgroundInfoServices.currency,
                            description: 'Ticket to be sold and to be made redeemable for a specific Reservation',
                            didFinishPayment: (e) {
                              context.read<ReservationFormBloc>().add(ReservationFormEvent.isFinishedCreatingReservationWeb(e));
                            },
                            didPressFinished: () {
                              setState(() {
                              Beamer.of(context).update(
                                  configuration: const RouteInformation(
                                      location: '/reservations'
                                  ),
                                  rebuild: false
                              );
                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.reservations));
                              });

                              final snackBar = SnackBar(
                                  elevation: 4,
                                  backgroundColor: widget.model.paletteColor,
                                  /// booking successful - confirmation e-mail sent!
                                  content: Text('You\'re Done! - Check Out You\'re New Reservation.', style: TextStyle(color: widget.model.webBackgroundColor))
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                        )
                    )
                )
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  }

  void showBookingSlots(BuildContext context, ReservationFormState state, UserProfileModel listingOwnerProfile, List<ReservationItem> reservations, ListingManagerForm listing) {
    if (kIsWeb) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Search Location',
        // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 750,
                  width: 600,
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: AddNewReservationSlots(
                    model: widget.model,
                    listing: listing,
                    reservations: reservations,
                    isPopOver: true,
                    listingOwnerProfile: listingOwnerProfile,
                    selectedFacilityBooking: context.read<ReservationFormBloc>().state.newFacilityBooking,
                    selectedSpace: context.read<ReservationFormBloc>().state.currentSelectedSpace ?? listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => SpaceOption.empty(), (r) => r.first),
                    selectedSportSpace: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption,
                    selectedListingActivityOption: context.read<ReservationFormBloc>().state.currentListingActivityOption,
                    didSaveReservation: (reservation) {
                      setState(() {
                        context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(reservation.reservationSlotItem, listing.listingProfileService.backgroundInfoServices.currency));
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        },
      );
    } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(bloc.optionOf(state.newFacilityBooking), bloc.optionOf(widget.listing), bloc.optionOf(state.listingOwner))),
            child: AddNewReservationSlots(
              model: widget.model,
              listing: listing,
              reservations: reservations,
              listingOwnerProfile: listingOwnerProfile,
              isPopOver: true,
              selectedFacilityBooking: context.read<ReservationFormBloc>().state.newFacilityBooking,
              selectedSpace: context.read<ReservationFormBloc>().state.currentSelectedSpace ?? listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => SpaceOption.empty(), (r) => r.first),
              selectedSportSpace: context.read<ReservationFormBloc>().state.currentSelectedSpaceOption,
              selectedListingActivityOption: context.read<ReservationFormBloc>().state.currentListingActivityOption,
              didSaveReservation: (reservation) {
                setState(() {
                  Navigator.of(context).pop();
                  context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(reservation.reservationSlotItem, listing.listingProfileService.backgroundInfoServices.currency));
                  });
                },
              ),
            );
          }
        )
      );
    }
  }

  Widget getMainContainerForFacilityDetails(BuildContext context,
      DashboardModel model,
      ReservationFormState state,
      UserProfileModel listingProfile,
      List<ReservationItem> reservations,
      UserProfileModel listingOwnerProfile,
      ListingManagerForm listing,
      Marker marker
      ) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: getMainContainerPageView(
                  context,
                  model,
                  state,
                  listingProfile,
                  reservations,
                  listingOwnerProfile,
                  listing,
                  marker
                ),
              ),
            ),
          ],
        ),

        if (reservationMarker != ReservationMobileCreateNewMarker.paymentReview) Positioned(
          bottom: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: widget.model.accentColor.withOpacity(0.35)
              ),
            ),
          )
        ),
        if (reservationMarker != ReservationMobileCreateNewMarker.paymentReview) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: 120,
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: getBottomContainer(
                              context,
                              reservationMarker,
                              state,
                              reservations,
                              listingOwnerProfile,
                              listing
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),

        if (kIsWeb) mainContainerHeaderTabWeb(),
        if (!(kIsWeb)) Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: AppBar(
              backgroundColor: widget.model.paletteColor,
              elevation: 0,
              automaticallyImplyLeading: true,
              centerTitle: true,
              toolbarHeight: 80,
              title: Text(getAppBarTitle(reservationMarker, listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash())),
              titleTextStyle: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
              actions: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
              const SizedBox(width: 10),
              ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: mainContainerHeaderTabMobile(context),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget getMainContainerPageView(
      BuildContext context,
      DashboardModel model,
      ReservationFormState state,
      UserProfileModel listingProfile,
      List<ReservationItem> reservations,
      UserProfileModel listingOwnerProfile,
      ListingManagerForm listing,
      Marker marker
      ) {
    return PageView.builder(
      controller: pageController,
      itemCount: 2,
      scrollDirection: Axis.horizontal,
      allowImplicitScrolling: true,
      physics: (kIsWeb == true) ? const NeverScrollableScrollPhysics() : null,
      itemBuilder: (_, index) {
        ListingOverviewMarker pageIndex = ListingOverviewMarker.values[index];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 25.0 : 0),
            child: Row(
              children: [
                if (pageIndex == ListingOverviewMarker.listing) Flexible(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: FacilityOverviewInfoWidget(
                          model: model,
                          overViewState: FacilityPreviewState.listing,
                          newFacilityBooking: state.newFacilityBooking,
                          reservations: reservations,
                          listingOwnerProfile: listingOwnerProfile,
                          listing: listing,
                          selectedReservationsSlots: widget.selectedReservationsSlots,
                          selectedActivityType: state.selectedActivityType,
                          currentListingActivityOption: state.currentListingActivityOption,
                          currentSelectedSpace: state.currentSelectedSpace,
                          currentSelectedSpaceOption: state.currentSelectedSpaceOption,
                          didSelectSpace: (space) {
                            setState(() {
                              context.read<ReservationFormBloc>().add(ReservationFormEvent.spaceDetailChanged(space));
                              context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(space.quantity[0]));
                            });
                          },
                          didSelectSpaceOption: (spaceOption) {
                            setState(() {
                              context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(spaceOption));
                            });
                          },
                          updateBookingItemList: (slotItem, currency) {
                            setState(() {
                              context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(slotItem, currency));
                            });
                          },
                          didSelectItem: () {
                            showBookingSlots(
                                context,
                                state,
                                listingOwnerProfile,
                                reservations,
                                listing
                          );
                        },
                        isAttendee: false,
                      ),
                    ),
                  ),
                ),

                if (pageIndex == ListingOverviewMarker.activities) Flexible(
                    child: FacilityActivityProgramming(
                      model: model,
                      currentUserId: UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
                      listing: listing,
                      reservations: reservations,
                      didSelectReservation: widget.didSelectReservation
                  )
                )
              ],
            )
          ),
        );
      },
    );
  }


  Widget getMainContainerForPaymentReview(
      BuildContext context,
      DashboardModel model,
      ReservationFormState state,
      UserProfileModel listingProfile,
      ListingManagerForm listing
      ) {
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
                          children: getSpacesFromSelectedReservationSlot(context, listing, state.newFacilityBooking.reservationSlotItem).map(
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
                                getListingTotalPriceDouble(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? []) +
                                getListingTotalPriceDouble(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])*CICOReservationPercentageFee +
                                getListingTotalPriceDouble(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem, context.read<ReservationFormBloc>().state.newFacilityBooking.cancelledSlotItem ?? [])*CICOTaxesFee, listing.listingProfileService.backgroundInfoServices.currency)}) now and have your slots secured', style: TextStyle(color: model.disabledTextColor)),
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
                      listing.listingProfileService.backgroundInfoServices.currency
                  ),

                  /// ------------------------ ///
                  /// cencellation policy
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Cancellations', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  if (listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false)
                    getPricingCancellationForNoCancellations(context, widget.model),
                  if (!(listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false))
                    getPricingCancellationWithChangesCancellation(context, widget.model, listing.listingReservationService.cancellationSetting.isAllowedChangeNotEarlyEnd ?? false,
                        listing.listingReservationService.cancellationSetting.isAllowedEarlyEndAndChanges ?? false),
                  if ((listing.listingReservationService.cancellationSetting.isAllowedFeeBasedChanges ?? false) &&
                      (listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithFeeCancellation(context, widget.model, state.newFacilityBooking.reservationSlotItem.map((e) => e.selectedDate).toList(),
                        listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions ?? []),
                  if ((listing.listingReservationService.cancellationSetting.isAllowedTimeBasedChanges ?? false) &&
                      (listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithTimeCancellation(context, widget.model, state.newFacilityBooking.reservationSlotItem.map((e) => e.selectedDate).toList(), listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions ?? []),

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
                listingProfile,
                listing
              ),
            ),

            const SizedBox(height: 120)
          ],
        )
      ),
    );
  }


  Widget getBottomContainer(BuildContext context, ReservationMobileCreateNewMarker marker, ReservationFormState  state, List<ReservationItem> reservations, UserProfileModel listingOwnerProfile, ListingManagerForm listing) {
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: Text(completeTotalPriceWithCurrency(double.parse(getPricingForSlot(listing.listingRulesService.pricingRuleSettings, listing.listingRulesService.isPricingRuleFixed, listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(), context.read<ReservationFormBloc>().state.currentSelectedSpaceOption?.spaceId ?? UniqueId())), listing.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 4),
                          if (kIsWeb == true) Expanded(child: Text('per slot', style: TextStyle(color: widget.model.paletteColor,), maxLines: 1, overflow: TextOverflow.ellipsis,))
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
                              listing.listingProfileService.backgroundInfoServices.currency
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: widget.model.paletteColor),
                          const SizedBox(width: 8),
                          Text('${numberOfSlotsSelected(context.read<ReservationFormBloc>().state.newFacilityBooking.reservationSlotItem)} slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                        ],
                      ),

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
                              listingOwnerProfile,
                              reservations,
                              listing
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
      case ReservationMobileCreateNewMarker.paymentReview:
        break;
      case ReservationMobileCreateNewMarker.listingNoLongerAvailable:
        break;
    }
    return Container();
  }


  Widget mainContainerHeaderTabMobile(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
          onTap: (index) {
            setState(() {
              listingOverviewMarker = ListingOverviewMarker.values[index];
              pageController?.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              });
            },
            indicatorColor: widget.model.webBackgroundColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelColor: widget.model.webBackgroundColor,
            unselectedLabelColor: widget.model.disabledTextColor,
            tabs: ListingOverviewMarker.values.map(
                  (e) => Tab(text: e.name.toUpperCase())
          ).toList()
      ),
    );
  }

  Widget mainContainerHeaderTabWeb() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: widget.model.accentColor.withOpacity(0.35)
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      onTap: (index) {
                        setState(() {
                          listingOverviewMarker = ListingOverviewMarker.values[index];
                          pageController?.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                        });
                      },
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: widget.model.paletteColor
                      ),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      labelColor: widget.model.accentColor,
                      unselectedLabelColor: widget.model.paletteColor,
                      tabs: ListingOverviewMarker.values.map(
                              (e) => ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Tab(text: e.name.toUpperCase()),
                        )
                      ).toList(),
                    ),
                  ),
                ),
              ),
            )
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Scaffold(
          backgroundColor: widget.model.mobileBackgroundColor,
            body: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
                  BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([widget.listingId.getOrCrash()], null, null, [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current]))),

                ],
          child: (widget.listing != null) ? retrieveExistingReservations(widget.listing!) : retrieveListing(),
        ),
      ),
    );
  }

  Widget retrieveListing() {
    return BlocProvider(create: (context) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(widget.listingId.getOrCrash())),
      child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            loadListingManagerItemSuccess: (item) {
              return retrieveExistingReservations(item.failure);
            },
            orElse: () => couldNotRetrieveListingProfile()
          );
        },
      ),
    );
  }

  Widget retrieveExistingReservations(ListingManagerForm listing) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash())),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              // resLoadInProgress: (_) => progressOverlay(widget.model),
              loadReservationListSuccess: (e) => retrieveFacilityOwner(e.item, listing),
              loadReservationListFailure: (_) => retrieveFacilityOwner([], listing),
              ///TODO: add failure of type empty
              /// if network call cant be made you should not be allowed to make any new reservation
              orElse: () => retrieveFacilityOwner([], listing));
        },
      ),
    );
  }

  Widget retrieveFacilityOwner(List<ReservationItem> reservations, ListingManagerForm listing) {
    return BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
        // loadInProgress: (_) => loadingListingProfile(listing),
        loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
        loadSelectedProfileSuccess: (item) => retrieveMainContainerForReservation(reservations, item.profile, listing),
        orElse: () => couldNotRetrieveListingProfile()
      );
    });
  }

  Widget retrieveAuthenticationState(BuildContext context, ReservationFormState  state, UserProfileModel listingOwnerProfile, ListingManagerForm listing) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
            loadInProgress: (_) => loadingConfirmReservation(),
            loadProfileFailure: (_) => GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },),
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
                  if (!(context.read<ReservationFormBloc>().state.isSubmitting)) InkWell(
                    onTap: () {
                      if (kIsWeb) {
                        _handleCreateCheckOutForWeb(context, item.profile, listingOwnerProfile, state, listing);
                      } else {
                        context.read<ReservationFormBloc>().add(ReservationFormEvent.isFinishedCreatingReservation(
                            item.profile,
                            (getListingTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) + getListingTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOReservationPercentageFee + getListingTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOTaxesFee).toInt(),
                            listing.listingProfileService.backgroundInfoServices.currency,
                            null,
                            listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false)
                        );
                      }
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
            orElse: () => GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },)
          );
        },
      ),
    );
  }


  Widget retrieveMainContainerForReservation(List<ReservationItem> reservations, UserProfileModel listingOwnerProfile, ListingManagerForm listing) {
    return BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(bloc.optionOf(ReservationItem(
          reservationId: ReservationItem.empty().reservationId,
          reservationOwnerId: UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
          instanceId: listing.listingServiceId,
          reservationCost: listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
          reservationState: (listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false) ? ReservationSlotState.requested : ReservationSlotState.confirmed,
          paymentStatus: ReservationItem.empty().paymentStatus,
          paymentIntentId: ReservationItem.empty().paymentIntentId,
          reservationSlotItem: [],
          isInternalProgram: listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash() == (facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
          customFieldRuleSetting: listing.listingReservationService.customFieldRuleSetting,
          dateCreated: ReservationItem.empty().dateCreated)),
          bloc.optionOf(listing),
          bloc.optionOf(listingOwnerProfile)
        )
      ),
      child: BlocConsumer<ReservationFormBloc, ReservationFormState>(
        listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
        listener: (context, state) {
          //
          // state.authFailureOrSuccessOption.fold(
          //         () {},
          //         (either) => either.fold((failure) {
          //
          //       final snackBar = SnackBar(
          //           backgroundColor: widget.model.webBackgroundColor,
          //           content: failure.maybeMap(
          //             invalidDate: (_) => Text('Sorry, the Date(s) You Have Selected are Conflicting', style: TextStyle(color: widget.model.disabledTextColor)),
          //             waitingForPaymentConfirmation: (_) => Text('Waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
          //             // waitingForPaymentConfirmation: (_) => Text('Sorry, You will Need to first Agree to the Terms and Conditions Before Completing Your Reservation', style: TextStyle(color: widget.model.disabledTextColor)),
          //             paymentResultError: (_) => Text('Please Fill Out Payment Method Details', style: TextStyle(color: widget.model.disabledTextColor)),
          //             // cancelled: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle( color: widget.model.disabledTextColor)),
          //
          //             reservationServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
          //             orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
          //           ));
          //
          //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //     }, (_) {
          //
          //     }));

          // state.authPaymentFailureOrSuccessOption.fold(
          //   () => {},
          //   (either) => either.fold(
          //     (failure) {
          //       final snackBar = SnackBar(
          //           backgroundColor: widget.model.webBackgroundColor,
          //           content: failure.maybeMap(
          //             couldNotRetrievePaymentMethod: (_) => Text('Could not retrieve payment details', style: TextStyle(color: widget.model.disabledTextColor)),
          //             paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
          //             orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
          //         )
          //       );
          //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //     }, (success) {
          //       final snackBar = SnackBar(
          //             elevation: 4,
          //             backgroundColor: widget.model.paletteColor,
          //             /// booking successful - confirmation e-mail sent!
          //             content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
          //         );
          //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //     }
          //   )
          // );
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
                  reservations,
                  listingOwnerProfile,
                  listing,
                  Marker(
                      markerId: MarkerId(listing.listingServiceId.getOrCrash()),
                      position: LatLng(listing.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listing.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0),
                      icon: BitmapDescriptor.defaultMarker
                  ),
              )
            ),
            NewReservationModel(
              markerItem: ReservationMobileCreateNewMarker.additionalDetails,
              childWidget: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                },
                child: Container(color: Colors.red,)
              )
            ),
            NewReservationModel(
                markerItem: ReservationMobileCreateNewMarker.paymentReview,
                childWidget: getMainContainerForPaymentReview(
                    context,
                    widget.model,
                    state,
                    listingOwnerProfile,
                    listing
              )
            ),
          ];
          if (context.read<ReservationFormBloc>().state.currentSelectedSpace == null && context.read<ReservationFormBloc>().state.currentSelectedSpaceOption == null) {
            (context.read<ReservationFormBloc>().add(ReservationFormEvent.spaceDetailChanged(listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)[0])));
            context.read<ReservationFormBloc>().add(ReservationFormEvent.selectedSizeOptionChanged(listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)[0].quantity[0]));
          }

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: widget.model.mobileBackgroundColor,
              ),
              reservationContainerModel.firstWhere((element) => element.markerItem == reservationMarker).childWidget,
            ],
          );
        }
      ),
    );
  }
}