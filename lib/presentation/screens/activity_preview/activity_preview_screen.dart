import 'package:check_in_application/auth/update_services/listing_update_create_services/attendee_update_create_services/listing_attendee_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/listing_activity_preview_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/listing_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/user_card.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen_helper.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityPreviewScreen extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm? listing;
  final ReservationItem reservation;


  const ActivityPreviewScreen({super.key, required this.model, required this.listing, required this.reservation});

  @override
  State<ActivityPreviewScreen> createState() => _ActivityPreviewScreenState();
}

class _ActivityPreviewScreenState extends State<ActivityPreviewScreen> {

  late ScrollController _scrollController;
  late bool isSubmittingSignIn = false;
  late PageController _pageController = PageController(initialPage: 0);
  late int _currentPageIndex = 0;
  ActivityCreateNewMarker activityMarker = ActivityCreateNewMarker.activityDetails;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  Widget getMainContainerForActivityDetails(
      BuildContext context,
      ActivityManagerForm activityForm,
      UserProfileModel activityOwner
      ) {

    return SingleChildScrollView(
      child: Container(
        color: widget.model.mobileBackgroundColor,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            if (activityForm.profileService.activityBackground.activityProfileImages != null && activityForm.profileService.activityBackground.activityProfileImages!.isNotEmpty) SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                     PageView.builder(
                        controller: _pageController,
                        itemCount: activityForm.profileService.activityBackground.activityProfileImages!.length,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPageIndex = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          final String activityImage = activityForm.profileService.activityBackground.activityProfileImages?[index].uriPath ?? '';
                          return Image.network(activityImage, fit: BoxFit.cover);
                      }
                    ),
                    getImageItemSelectionTabWidget(context, widget.model, activityForm.profileService.activityBackground.activityProfileImages!.length, _currentPageIndex)
                  ],
                ),
              ),
              if (activityForm.profileService.activityBackground.activityProfileImages == null || (activityForm.profileService.activityBackground.activityProfileImages?.isEmpty ?? false)) Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                color: widget.model.accentColor,
                child: getActivityFromReservationId(
                  context,
                  widget.model,
                  30,
                  widget.reservation
                )
              ),
              const SizedBox(height: 8),
              /// background info of activity ///
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: getActivityBackgroundColumn(context, widget.model, activityForm, activityOwner),
              ),
              const SizedBox(height: 8),

            /// activity type ///
            /// ---------------------------------------------------- ///
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ListTile(
                title: Text(getTitleForActivityOption(context, activityForm.activityType.activityId) ?? '', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                leading: getActivityFromReservationId(
                    context,
                    widget.model,
                    25,
                    widget.reservation
                )
              ),
            ),

            /// reservation dates ///
            /// ---------------------------------------------------- ///
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity Dates', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  viewListOfSelectedSlots(
                      context,
                      widget.model,
                      [],
                      widget.reservation.reservationSlotItem,
                      widget.reservation.cancelledSlotItem ?? [],
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
                ],
              ),
            ),


            /// background info of listing ///
            /// ---------------------------------------------------- ///
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),

            /// host profile info ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: getHostColumn(context, activityOwner, widget.model),
            ),


            const SizedBox(height: 25),
          ],
        ),
      ),
    );
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
            centerTitle: true,
            toolbarHeight: 0,
            // title: Text(getAppBarTitle(reservationMarker)),
            titleTextStyle: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
            actions: [
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
              const SizedBox(width: 10),
            ],
          ),
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
              BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.reservation.reservationOwnerId.getOrCrash()))),
              BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(bloc.optionOf(AttendeeItem(
                  attendeeId: AttendeeItem.empty().attendeeId,
                  attendeeOwnerId: UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
                  reservationId: widget.reservation.reservationId,
                  cost: AttendeeItem.empty().cost,
                  paymentStatus: AttendeeItem.empty().paymentStatus,
                  attendeeType: AttendeeItem.empty().attendeeType,
                  paymentIntentId: AttendeeItem.empty().paymentIntentId,
                  dateCreated: AttendeeItem.empty().dateCreated
                )
              ), bloc.optionOf(widget.reservation))))
            ],
            child: retrieveActivitySettings(),
          ),
        )
    );
  }


  Widget retrieveActivitySettings() {
    return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(widget.reservation.reservationId.getOrCrash())),
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadActivityManagerFormFailure: (_) => retrieveActivityOwner(ActivityManagerForm.empty()),
              loadActivityManagerFormSuccess: (item) => retrieveActivityOwner(item.item),
              orElse: () => retrieveActivityOwner(ActivityManagerForm.empty())
          );
        },
      ),
    );
  }

  Widget retrieveActivityOwner(ActivityManagerForm activityForm) {
    return BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              // loadInProgress: (_) => loadingListingProfile(widget.listing),
              loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
              loadSelectedProfileSuccess: (item) => retrieveMainContainerForAttendee(activityForm, item.profile),
              orElse: () => couldNotRetrieveListingProfile()
      );
    });
  }

  Widget retrieveAuthenticationState(BuildContext context, ActivityCreateNewMarker  state, UserProfileModel listingOwnerProfile) {
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
                            // reservationMarker = ReservationMobileCreateNewMarker.listingDetails;
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

                    if (!(context.read<AttendeeFormBloc>().state.isSubmitting)) InkWell(
                      onTap: () {
                        // context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(
                        //     item.profile,
                        //     (getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) + getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOReservationPercentageFee + getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) * CICOTaxesFee).toString(),
                        //     (NumberFormat.simpleCurrency(locale: widget.listing.listingProfileService.backgroundInfoServices.currency).currencyName ?? 'cad').toLowerCase(),
                        //     null,
                        //     widget.listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false
                        //   )
                        // );
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


  Widget retrieveMainContainerForAttendee(ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile) {
    return BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
      listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
      listener: (context, state) {
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
      buildWhen: (p,c) => p.attendeeItem != c.attendeeItem || p.isSubmitting != c.isSubmitting,
      builder: (context, state) {

        List<NewActivityModel> activityContainerModel = [
          NewActivityModel(
              markerItem: ActivityCreateNewMarker.activityDetails,
              childWidget: getMainContainerForActivityDetails(context, activityForm, activityOwnerProfile)
          ),
          NewActivityModel(
              markerItem: ActivityCreateNewMarker.paymentReview,
              childWidget: Container()
          ),
        ];

        return Stack(
          children: [
            activityContainerModel.firstWhere((element) => element.markerItem == activityMarker).childWidget
          ],
        );
      },
    );
  }


}