import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/activity_vendors/activity_vendors_results_main.dart';
import 'actvity_vendor_form_manager_helper.dart';

class ActivityVendorFormManageMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final ReservationItem? initialReservation;
  // final ActivityManagerForm? activityManagerForm;
  final VendorMerchantForm? selectedForm;
  final Function() rebuild;

  const ActivityVendorFormManageMainContainerWidget({super.key, required this.model, required this.initialReservation, required this.rebuild, this.selectedForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (!(kIsWeb)) ? AppBar(
        backgroundColor: model.paletteColor,
        title: const Text('Manage Vendor Applications'),
        centerTitle: true,
      ) : null,
      body: Padding(
          padding: (kIsWeb) ? const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0) : EdgeInsets.zero,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: (selectedForm != null) ? retrieveReservationSource(selectedForm!) : defaultPagePreview()
        )
      ),
    );
  }

  Widget retrieveReservationSource(VendorMerchantForm selectedForm) {
    if (initialReservation != null) {
      return getReservationListing(selectedForm, initialReservation!);
    } else {
      return settingsFailureToLoadContainer();
    }
  }

  Widget getReservationListing(VendorMerchantForm selectedForm, ReservationItem reservation) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservation.instanceId.getOrCrash()))),
        BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservation.reservationId.getOrCrash()))),
        BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()))
      ],
      child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadListingManagerItemSuccess: (item) {
                return getActivityForm(reservation, item.failure, selectedForm);
              },
              orElse: () => settingsFailureToLoadContainer()
          );
        },
      ),
    );
  }

  Widget getActivityForm(ReservationItem reservation, ListingManagerForm listingForm, VendorMerchantForm selectedForm) {
    return BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadActivityManagerFormSuccess: (item) {
              return retrieveAuthenticationState(context, reservation, listingForm, item.item, selectedForm);
            },
            orElse: () => settingsFailureToLoadContainer()
        );
      },
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, ReservationItem reservation, ListingManagerForm listingForm, ActivityManagerForm activityForm, VendorMerchantForm selectedForm) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
              loadProfileFailure: (_) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetLoginSignUpWidget(showFullScreen: true, model: model, didLoginSuccess: () {  },),
              ),
              loadUserProfileSuccess: (item) => ActivityVendorApplicationsResultMain(
                model: model,
                selectedForm: selectedForm,
                reservationItem: reservation,
                listingForm: listingForm,
                activityOwnerProfile: item.profile,
                activityManagerForm: activityForm,
              ),
              orElse: () {
                return JumpingDots(color: model.paletteColor, numberOfDots: 3);
              }
          );
        },
      ),
    );
  }

  Widget settingsFailureToLoadContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: model.disabledTextColor, size: 85),
          const SizedBox(height: 10),
          Text('Sorry, Cannot Manage Vendor Forms', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 10),
          Text('Start your own reservation and be able to see & manage your own applicants', style: TextStyle(color: model.disabledTextColor)),
        ],
      ),
    );
  }


  Widget defaultPagePreview() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, color: model.disabledTextColor, size: 85),
          const SizedBox(height: 10),
          Text('Your Vendors', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 10),
          Text('Select any Vendor Form from the list and get things started!', style: TextStyle(color: model.disabledTextColor)),
        ],
      ),
    );
  }
}