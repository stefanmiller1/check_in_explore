import 'dart:io';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/profile/profile_helper_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/edit_selected_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ReviewCurrentProfile extends StatefulWidget {

  final UserProfileModel currentUser;
  final DashboardModel model;
  final Function(UserProfileModel user) didSelectEditProfile;


  const ReviewCurrentProfile({super.key, required this.currentUser, required this.model, required this.didSelectEditProfile});

  @override
  State<ReviewCurrentProfile> createState() => _ReviewCurrentProfileState();
}

class _ReviewCurrentProfileState extends State<ReviewCurrentProfile> {

  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController(viewportFraction: 0.85);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!(Responsive.isMobile(context))) {
      pageController = PageController(viewportFraction: 0.75);
    }

    // return (!(kIsWeb) && Platform.isIOS) ?
    // Scaffold(
    //   body: CupertinoScaffold(
    //     body: CupertinoTheme(
    //       data: CupertinoThemeData(
    //         textTheme: CupertinoTextThemeData(
    //           primaryColor: widget.model.paletteColor
    //         )
    //       ),
    //       child: CupertinoPageScaffold(
    //         navigationBar: CupertinoNavigationBar(
    //           transitionBetweenRoutes: true,
    //           middle: Text(widget.currentUser.legalName.getOrCrash()),
    //         ),
    //         child: MultiBlocProvider(
    //           providers: [
    //             BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(const PublicListingWatcherEvent.watchAllPublicListingsStarted(['']))),
    //             BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations(widget.currentUser, false)))
    //           ],
    //           child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
    //               builder: (context, state) {
    //                 return state.maybeMap(
    //                     loadAllPublicListingItemsSuccess: (e) => getAllReservation(context, e.items.where((element) => element.listingProfileService.backgroundInfoServices.listingOwner == widget.currentUser.userId).toList()),
    //                     loadAllPublicListingItemsFailure: (e) => getAllReservation(context, []),
    //                     orElse: () => getAllReservation(context, []));
    //               }
    //           )
    //         ),
    //       ),
    //     ),
    //   )
    // ) :
    return ClipRRect(
      borderRadius: (kIsWeb) ? BorderRadius.circular(20) : BorderRadius.zero,
      child: Scaffold(
          backgroundColor: (kIsWeb) ? Colors.transparent : null,
          appBar: (!kIsWeb) ? AppBar(
            backgroundColor: widget.model.mobileBackgroundColor,
            elevation: 0,
            title: Text(widget.currentUser.legalName.getOrCrash()),
            titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor), onPressed: () => Navigator.of(context).pop(),),
          ) : null,
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(const PublicListingWatcherEvent.watchAllPublicListingsStarted(['']))),
              BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current, ReservationSlotState.confirmed, ReservationSlotState.completed], widget.currentUser, false)))
            ],
            child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
                builder: (context, state) {
                  return state.maybeMap(
                      loadAllPublicListingItemsSuccess: (e) => getAllReservation(context, e.items.where((element) => element.listingProfileService.backgroundInfoServices.listingOwner == widget.currentUser.userId).toList()),
                      loadAllPublicListingItemsFailure: (e) => getAllReservation(context, []),
                      orElse: () => getAllReservation(context, []));
            }
          ),
        )
      ),
    );
  }

  Widget getAllReservation(BuildContext context, List<ListingManagerForm> listings) {
    return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            resLoadInProgress: (_) => progressOverlay(widget.model),
            loadCurrentUserReservationsSuccess: (e) => getMainReviewProfile(context, widget.model, listings, e.item),
            orElse: () => getMainReviewProfile(context, widget.model, listings, [])
        );
      }
    );
  }

  Widget getMainReviewProfile(BuildContext context, DashboardModel model, List<ListingManagerForm> listings, List<ReservationItem> reservations) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [

              if (kIsWeb) const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 750,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.model.webBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: profileHeaderContainer(
                                  widget.currentUser,
                                  model,
                                  widget.currentUser.userId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid,
                                  listings.length,
                                  reservations.length,
                                  editProfile: () {

                                    // if (!kIsWeb && Platform.isIOS) {
                                    //   CupertinoScaffold.showCupertinoModalBottomSheet(
                                    //       context: context,
                                    //       expand: true,
                                    //       builder: (contexts) {
                                    //         return EditCurrentProfile(
                                    //           profile: widget.currentUser,
                                    //           model: model,
                                    //           didFinishSaving: (profile) {
                                    //             setState(() {
                                    //               Navigator.of(context).pop();
                                    //             });
                                    //           },
                                    //         );
                                    //       });
                                    // } else
                                    //
                                    if (kIsWeb) {
                                      widget.didSelectEditProfile(widget.currentUser);
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (_) {
                                            return EditCurrentProfile(
                                              profile: widget.currentUser,
                                              model: widget.model,
                                              didFinishSaving: (profile) {
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            );
                                          })
                                      );
                                    }
                                  }
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Divider(color: model.disabledTextColor),
                          const SizedBox(height: 18),
                          verificationsAndConfirmations(model, widget.currentUser),
                          const SizedBox(height: 18),
                          Divider(color: model.disabledTextColor),
                          const SizedBox(height: 18),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: widget.model.webBackgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: getHostingListings(context, widget.currentUser, listings, model),
                              )
                          ),
                          const SizedBox(height: 18),
                          Divider(color: model.disabledTextColor),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.model.webBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: getUpComingReservations(context,
                                  widget.currentUser,
                                  pageController,
                                  reservations,
                                  model,
                                  didSelectReservation: (listing, reservation) {

                                  }
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}