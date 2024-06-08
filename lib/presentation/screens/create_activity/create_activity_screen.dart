import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/create_activity/create_activity_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/add_new_reservation_slots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'components/select_facility_list_screen.dart';


class CreateNewActivityScreen extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm? currentListingManForm;
  final int? initPage;


  const CreateNewActivityScreen({super.key, required this.model, this.currentListingManForm, this.initPage});

  @override
  State<CreateNewActivityScreen> createState() => _CreateNewActivityScreenState();
}

class _CreateNewActivityScreenState extends State<CreateNewActivityScreen> {


  late PageController? pageController = null;
  late ListingManagerForm? selectedListing = null;
  late UserProfileModel? selectedListingOwner = null;
  late ReservationItem? selectedReservationItem = null;
  ScrollController? _scrollController;
  late bool isLoadingLogin = false;
  late bool isLoading = false;
  late bool willAttendHere = false;
  late bool isConfirmed = false;
  int _currentPage = 0;


  @override
  void initState() {
    selectedListing = widget.currentListingManForm;
    pageController = PageController(initialPage: widget.initPage ?? 0);
    _currentPage = widget.initPage ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  List<Widget> newActivityContainer(BuildContext context, UserProfileModel currentUser) => [
    /// select a facility...
    SingleChildScrollView(
      child: Column(
        children: [
          Transform.scale(
            scale: 8,
            child: Lottie.asset(
                height: 425,
                repeat: false,
                'assets/lottie_animations/Animation - 1716552555161.json'
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Let\'s get on the map!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 5),
          Text('Welcome to a circle - get Started By Clicking \'Next'':', style: TextStyle(color: widget.model.disabledTextColor, ), textAlign: TextAlign.center),
        ],
      ),
    ),

    SelectFacilityListScreen(
      model: widget.model,
      currentUser: currentUser,
      selectedListing: selectedListing,
      didSelectListing: (listing) {
        setState(() {
          selectedListing = listing;
        });
      },
    ),

    SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Disclaimer!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
              ),
              Text('Select at I Agree then pick your dates', style: TextStyle(color: widget.model.disabledTextColor)),

              ListTile(
                leading: Icon(Icons.add_task, color: widget.model.paletteColor),
                title: Text('Permissions', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('You have obtained or will be able to at a later date explicit permission from the owner or authorized representative of the space to use the venue for your event.', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
              ListTile(
                leading: Icon(Icons.add_task, color: widget.model.paletteColor),
                title: Text('Responsibility', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('You are responsible for all communications and agreements with the space owner and will ensure that all necessary arrangements are in place.', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
              ListTile(
                leading: Icon(Icons.add_task, color: widget.model.paletteColor),
                title: Text('Reservation Removals', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text(' If it is found that you do not have the necessary permissions or are not in compliance with the above conditions, we (the platform) reserve the right to cancel and remove your event listing without notice.', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            ),
            const SizedBox(height: 8),
            Text('Please confirm that you have the necessary permissions and agree to the above terms by selecting “I Agree”. If you do not have permission, please select “Cancel” to exit the event posting process.', style: TextStyle(color: widget.model.paletteColor)),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 200
                    ),
                    height: 45,
                    width: 185,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    setState(() {
                      isConfirmed = !isConfirmed;
                    });
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 200
                    ),
                    height: 45,
                    width: 185,
                    decoration: BoxDecoration(
                      color: (isConfirmed) ? widget.model.paletteColor : widget.model.accentColor,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('I Agree', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ),
                  ),
                )

              ],
            ),
              const SizedBox(height: 100),
          ],
        ),
      )
    ),

    /// review selected profile
    if (selectedListing != null) SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Is this the place?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
          ),
          Text('Select at Next to pick your dates', style: TextStyle(color: widget.model.disabledTextColor)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
            child: FacilityOverviewInfoWidget(
              model: widget.model,
              overViewState: FacilityPreviewState.reservation,
              newFacilityBooking: ReservationItem.empty(),
              reservations: [],
              /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
              listingOwnerProfile: currentUser,
              listing: selectedListing!,
              selectedReservationsSlots: [],
              selectedActivityType: null,
              currentListingActivityOption: null,
              currentSelectedSpace: null,
              currentSelectedSpaceOption: null,
              didSelectSpace: (space) {
              },
              didSelectSpaceOption: (spaceOption) {
              },
              updateBookingItemList: (slotItem, currency) {
              },
              didSelectItem: () {
              },
              isAttendee: false,
            ),
          ),
        ],
      ),
    ),


    // if (selectedListing != null) SingleChildScrollView(
    //   child: Column(
    //     children: [
    //
    //     ],
    //   ),
    // ),

    if (selectedListing != null) retrieveExistingReservations(selectedListing!, currentUser),

    /// verify that you will be here on these dates (yes or no)
    if (selectedListing != null && selectedReservationItem != null && selectedReservationItem?.reservationSlotItem.isNotEmpty == true) SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
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
                    children: getSpacesFromSelectedReservationSlot(context, selectedListing!, selectedReservationItem?.reservationSlotItem ?? []).map(
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
              selectedReservationItem?.reservationSlotItem ?? [],
              [],
              false,
              AppLocalizations.of(context)!.profileFacilitySlotTime,
              AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
              AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
              selectedListing!,
              didSelectReservation: (e) {
              },
              didSelectCancelResSlot: (e, f) {
                setState(() {});
              },
              didSelectRemoveResSlot: (e, f) {

              }
            ),
            /// ------------------------ ///
            /// policy & guidelines
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),

            Text('When Selecting Confirm Reservation, I agree to the Rules made by the Listing Owner, Ground Rules for Guests, Cancellatio, Rebooking, and Refunding Policy defined by CICO and the Listing Owner.', style: TextStyle(color: widget.model.disabledTextColor)),
            const SizedBox(height: 34),
          ],
        ),
      ),
    ),

  if (selectedListing != null && selectedReservationItem != null) retrieveFacilityOwnerForSetupCompletion(selectedReservationItem!, selectedListing!, currentUser)

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
          title: Text('Create Your Activity', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            elevation: 0,
            centerTitle: true,
            backgroundColor: widget.model.paletteColor,
            leadingWidth: 70,
            leading: IconButton(
            icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
            tooltip: 'Cancel',
            onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body:  PointerInterceptor(
        child: Stack(
                  children: [
                    Container(
                        color: widget.model.webBackgroundColor,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height
                    ),
                    if (isLoadingLogin == true) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                    if (isLoadingLogin == false) retrieveAuthenticationState(context),
          ],
        ),
      )
    );
  }

  Widget retrieveAuthenticationState(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) {
                return getMainContainer(context, item.profile);
              },
              orElse: () =>  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetLoginSignUpWidget(showFullScreen: false, model: widget.model, didLoginSuccess: () {
                    setState(() {
                      isLoadingLogin = true;

                      Future.delayed(const Duration(milliseconds: 250), () {
                        setState(() {
                          isLoadingLogin = false;
                        });
                      });
                    });
                  },
                ),
              )
          );
        },
      ),
    );
  }


  Widget getMainContainer(BuildContext context, UserProfileModel currentUser) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            color: widget.model.webBackgroundColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height
        ),
        CreateNewMain(
            isPreviewer: false,
            model: widget.model,
            isLoading: isLoading,
            pageController: pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              // setState(() {
              //   if (index != (attendeeMainContainer(context, currentUser, profiles, state).length - 1)) {
              //     currentVendorMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].subVendorMarkerItem;
              //     currentMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].markerItem;
              //   }
              // });
            },
            child: newActivityContainer(context, currentUser).toList()
        ),

        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              color: widget.model.accentColor.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                            Visibility(
                              visible: showBackButtonNewActivity(),
                              child: IconButton(
                              onPressed: () {
                                  setState(() {

                                      if (_currentPage == 0) {
                                        Navigator.of(context).pop();
                                      } else {
                                        isLoading = true;
                                        Future.delayed(const Duration(milliseconds: 800), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                        pageController?.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                                      }
                                  });
                                },
                              icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor)
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    Visibility(
                      visible: showNextButtonNewActivity(_currentPage, selectedListing, isConfirmed, selectedReservationItem?.reservationSlotItem ?? []),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                            Future.delayed(const Duration(milliseconds: 800), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                            pageController?.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                          });
                        },
                        child: Container(
                            constraints: BoxConstraints(
                            maxWidth: 200
                          ),
                          height: 45,
                          width: 185,
                          decoration: BoxDecoration(
                            color: widget.model.paletteColor,
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Next', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                            ),
                          ),
                        )
                      ),
                
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }


  Widget retrieveExistingReservations(ListingManagerForm listing, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([listing.listingServiceId.getOrCrash()], null, null, [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current])),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              // resLoadInProgress: (_) => progressOverlay(model),
              loadReservationListSuccess: (e) => retrieveFacilityOwner(e.item, listing, currentUser),
              loadReservationListFailure: (_) => retrieveFacilityOwner([], listing, currentUser),
              ///TODO: add failure of type empty
              /// if network call cant be made you should not be allowed to make any new reservation
              orElse: () => retrieveFacilityOwner([], listing, currentUser));
        },
      ),
    );
  }

  Widget retrieveFacilityOwner(List<ReservationItem> reservations, ListingManagerForm listing, UserProfileModel currentUser) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              loadInProgress: (_) => loadingListingProfile(listing),
              loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
              loadSelectedProfileSuccess: (item) => getReservation(listing, item.profile, currentUser, reservations),
              orElse: () => couldNotRetrieveListingProfile()
          );
        }
      ),
    );
  }



  Widget retrieveFacilityOwnerForSetupCompletion(ReservationItem reservation, ListingManagerForm listing, UserProfileModel currentUser) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadInProgress: (_) => loadingListingProfile(listing),
                loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
                loadSelectedProfileSuccess: (item) => getSetupComplete(context, listing, reservation, item.profile, currentUser),
                orElse: () => couldNotRetrieveListingProfile()
            );
          }
      ),
    );
  }

  Widget getSetupComplete(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel listingOwnerProfile, UserProfileModel currentUser, ) {
    return BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(
        bloc.optionOf(reservation),
        bloc.optionOf(listing),
        bloc.optionOf(listingOwnerProfile)
      )
    ),
    child: BlocConsumer<ReservationFormBloc, ReservationFormState>(
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
              final snackBar = SnackBar(
                  elevation: 4,
                  backgroundColor: widget.model.paletteColor,
                  /// booking successful - confirmation e-mail sent!
                  content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();

        }));

    },
    buildWhen: (p,c) =>  p.newFacilityBooking != c.newFacilityBooking ||
      p.isTermsConditionsAccepted != c.isTermsConditionsAccepted ||
      p.currentSelectedSpace != c.currentSelectedSpace ||
      p.currentSelectedSpaceOption != c.currentSelectedSpaceOption ||
      p.cardItem != c.cardItem ||
      p.isSavingCard != c.isSavingCard ||
      p.isSubmitting != c.isSubmitting,
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),

              if (state.isSubmitting == false) SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    Icon(
                      Icons.check_circle_outline_rounded, color: widget.model.paletteColor, size: 36,
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('All Done!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                    ),
                    Text('Select the Confirm Reservation - and get your Activity Started!', style: TextStyle(color: widget.model.disabledTextColor)),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        context.read<ReservationFormBloc>().add(ReservationFormEvent.isFinishedCreatingReservation(currentUser, 0, listing.listingProfileService.backgroundInfoServices.currency, null, listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false));
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 200
                        ),
                        height: 45,
                        width: 185,
                        decoration: BoxDecoration(
                          color: widget.model.paletteColor,
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Confirm Reservation', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                        ),
                      ),
                    )

                  ],
                ),
              ),
              if (state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),

            ],
          );
        }
      )
    );
  }


  Widget getReservation(ListingManagerForm listing, UserProfileModel listingOwnerProfile, UserProfileModel currentUser, List<ReservationItem> reservations,) {
            UniqueId? selectedActivityType;
            SpaceOption currentSelectedSpace = listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => SpaceOption.empty(), (r) => r.first);
            SpaceOptionSizeDetail? currentSelectedSpaceOption;
            FacilityActivityCreatorForm? currentListingActivityOption;

            return Column(
              children: [
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('What about Your Dates?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                ),
                Text('Select the dates - when you start and when your activity ends below', style: TextStyle(color: widget.model.disabledTextColor)),
                const SizedBox(height: 25),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 60.0),
                    child: AddNewReservationSlots(
                        model: widget.model,
                        listing: listing,
                        reservations: reservations,
                        isPopOver: false,
                        didSaveReservation: (res) {
                          print(res);
                          setState(() {
                            selectedReservationItem = res;
                          });
                          // context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(res.reservationSlotItem, listing.listingProfileService.backgroundInfoServices.currency));
                        },
                        selectedSpace: currentSelectedSpace,
                        selectedSportSpace: currentSelectedSpaceOption,
                        selectedListingActivityOption: currentListingActivityOption,
                        listingOwnerProfile: listingOwnerProfile,
                        selectedFacilityBooking: selectedReservationItem ?? ReservationItem(
                            reservationId: ReservationItem.empty().reservationId,
                            reservationOwnerId: currentUser.userId,
                            instanceId: listing.listingServiceId,
                            reservationCost: listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
                            reservationState: ReservationSlotState.confirmed,
                            paymentStatus: ReservationItem.empty().paymentStatus,
                            paymentIntentId: ReservationItem.empty().paymentIntentId,
                            reservationSlotItem: [],
                            isInternalProgram: listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash() == currentUser.userId.getOrCrash(),
                            customFieldRuleSetting: listing.listingReservationService.customFieldRuleSetting,
                            dateCreated: DateTime.now()
              )
            ),
          ),
        ),
      ],
    );
  }
}