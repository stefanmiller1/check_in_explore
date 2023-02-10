import 'dart:io';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/profile/profile_helper_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/edit_selected_profile.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ReviewCurrentProfile extends StatefulWidget {

  final UserProfileModel currentUser;
  final DashboardModel model;

  const ReviewCurrentProfile({super.key, required this.currentUser, required this.model});

  @override
  State<ReviewCurrentProfile> createState() => _ReviewCurrentProfileState();
}

class _ReviewCurrentProfileState extends State<ReviewCurrentProfile> {

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    Scaffold(
      body: CupertinoScaffold(
        body: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              primaryColor: widget.model.paletteColor
            )
          ),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              transitionBetweenRoutes: true,
              middle: Text(widget.currentUser.legalName.getOrCrash()),
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsStarted('')))
              ],
              child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
                  builder: (context, state) {
                    return state.maybeMap(
                        loadAllPublicListingItemsSuccess: (e) => getAllReservation(context, e.items.where((element) => element.listingProfileService.backgroundInfoServices.listingOwner == widget.currentUser.userId).toList()),
                        loadAllPublicListingItemsFailure: (e) => getAllReservation(context, []),
                        orElse: () => getAllReservation(context, []));
                  }
              )
            ),
          ),
        ),
      )
    ) : Scaffold(
        appBar: AppBar(
          backgroundColor: widget.model.mobileBackgroundColor,
          elevation: 0,
          title: Text(widget.currentUser.legalName.getOrCrash()),
          titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor), onPressed: () => Navigator.of(context).pop(),),
        ),
        body: BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsStarted('')),
          child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
              builder: (context, state) {
                return state.maybeMap(
                    loadAllPublicListingItemsSuccess: (e) => getAllReservation(context, e.items.where((element) => element.listingProfileService.backgroundInfoServices.listingOwner == widget.currentUser.userId).toList()),
                    loadAllPublicListingItemsFailure: (e) => getAllReservation(context, []),
                    orElse: () => getAllReservation(context, []));
          }
        ),
      )
    );
  }

  Widget getAllReservation(BuildContext context, List<ListingManagerForm> listings) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations(widget.currentUser.userId.getOrCrash())),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            resLoadInProgress: (_) => progressOverlay(widget.model),
            loadCurrentUserReservationsSuccess: (e) => getMainReviewProfile(context, widget.model, listings, e.item),
            orElse: () => getMainReviewProfile(context, widget.model, listings, [])
          );
        }
      )
    );
  }

  Widget getMainReviewProfile(BuildContext context, DashboardModel model, List<ListingManagerForm> listings, List<ReservationItem> reservations) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
        children: [
            const SizedBox(height: 120),
            profileHeaderContainer(
                widget.currentUser,
                model,
                true,
                listings.length,
                reservations.length,
                editProfile: () {
                  if (Platform.isIOS) {
                    CupertinoScaffold.showCupertinoModalBottomSheet(
                        context: context,
                        expand: true,
                        builder: (contexts) {
                          return EditCurrentProfile(
                            profile: widget.currentUser,
                            model: model,
                            didFinishSaving: (profile) {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                          );
                        });
                  } else {

                }
              }
            ),
            const SizedBox(height: 18),
            Divider(color: model.disabledTextColor),
            const SizedBox(height: 18),
            verificationsAndConfirmations(model, widget.currentUser),
            const SizedBox(height: 18),
            Divider(color: model.disabledTextColor),
            const SizedBox(height: 18),
            getHostingListings(context, widget.currentUser, listings, model),
            const SizedBox(height: 18),
            Divider(color: model.disabledTextColor),
            const SizedBox(height: 18),
            getUpComingReservations(context, widget.currentUser, reservations, model),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}