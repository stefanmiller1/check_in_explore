import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:check_in_application/auth/update_services/booked_reservation_services/booked_reservation_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/reservation_post/image_post.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/invite_widgets/send_invitation_request.dart';
import 'package:check_in_web_mobile_explore/presentation/core/posts/post_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/posts/post_widget_builder.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_activity_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_affiliates_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_invite_join.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/profile_reservation_widget.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reservation_post/inputs/input.dart';
import 'package:reservation_post/inputs/media_attatchment_preview.dart';
import 'package:reservation_post/models/media_mode.dart';
import 'package:reservation_post/reservation_post.dart';
import 'package:share_plus/share_plus.dart';


class ReservationResultMain extends StatefulWidget {

  final String currentUserId;
  final String reservationId;
  final UserProfileModel? currentUser;
  // final ReservationItem? reservation;
  final ListingManagerForm? listing;
  final DashboardModel model;
  final bool isReply;
  /// post to reply to
  final Post? replyToPost;
  final List<Post>? replyPosts;
  // final bool isReservationOwner;

  const ReservationResultMain({
    super.key,
    this.listing,
    required this.model,
    required this.isReply,
    this.replyToPost,
    this.replyPosts,
    // required this.isReservationOwner,
    required this.reservationId,
    required this.currentUserId,
    this.currentUser,
  });



  @override
  State<ReservationResultMain> createState() => _ReservationResultMainState();
}

class _ReservationResultMainState extends State<ReservationResultMain> with SingleTickerProviderStateMixin {

  final _controller = ScrollController();
  final _headerController = ScrollController();
  late TabController? _tabController;
  late PageController? _pageController;

  double _offset = 0;
  late double _percentageOpen = 0;
  // image picker for sending photo's, videos with post.
  final ImagePicker _imagePicker = ImagePicker();

  /// selected photos for post.
  late List<XFile> _selectedFileSpaceImage = [];

  /// see [Input.isImageVideoAttachmentUploading]
  late bool isImageVideoAttachmentUploading = false;

  /// see [Input.isCameraImageAttachmentUploading]
  late bool isCameraImageAttachmentUploading = false;

  /// see [Input.isAudioAttachmentUploading]
  late bool isAudioAttachmentUploading = false;

  /// SilverAppBar collapsed height
  final double _collapsedHeight = 60;

  /// SilverAppBar expanded height
  double _expandedHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.75;

  /// value to control SilverAppBar widget sizes, based on boxconstraints
  late double extentRatio;

  /// minimum height for main widget.
  late double minH1 = 40;

  /// maximum height for main widget.
  late double maxH1 = 60;

  /// check if current user is reservation owner.
  late bool isOwner = false;

  /// check if current user is a reservation guest or affiliate.
  late bool isAffiliate = false;



 @override
  void initState() {
    _selectedFileSpaceImage = [];
    _controller.addListener(moveOffset);
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: _tabController?.index ?? 0);
    super.initState();
  }

  moveOffset() {
    setState(() {
      _offset = min(max(0, _controller.offset / 6 - 16), 32);
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _controller.removeListener(moveOffset);
    _controller.dispose();
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
   if (ReservationHelperCore.isLoading) {
     return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
   }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: (widget.isReply) ? AppBar(
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        title: Text('Reply', style: TextStyle(color: widget.model.accentColor),),
      ) : null,
      body: MultiBlocProvider(
        providers: [
          if (widget.currentUser == null) BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.currentUserId))),
          BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.reservationId))),
          BlocProvider(create: (_) => getIt<BookedReservationFormBloc>()..add(BookedReservationFormEvent.initializedPostForm(bloc.optionOf(Post(authorId: UniqueId.fromUniqueString(widget.currentUserId), id: UniqueId().getOrCrash(), status: PostStatus.sending, reservationId: widget.reservationId, type: PostType.text))))),
        ],
        child:  (widget.listing != null && widget.currentUser != null) ? retrieveReservation(widget.listing!, widget.currentUser!) : retrieveExistingPostFromLink()
      ),
    );
  }

  /// if presented from notification - retrieve reservation, listing and current user
  Widget retrieveExistingPostFromLink() {
   return Container();
   // return MultiBlocProvider(
   //   providers: [
   //
   //   ],
   //  );
  }

  Widget retrieveReservation(ListingManagerForm listingForm, UserProfileModel currentUser) {
    return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadReservationItemSuccess: (e) {
              return retrieveExistingPosts(e.item, listingForm, currentUser);
            },
            orElse: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
        );
      },
    );
  }

  Widget retrieveExistingPosts(ReservationItem reservationItem, ListingManagerForm listingForm, UserProfileModel currentUser) {
    return  BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentReservationPosts(widget.reservationId)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadReservationPostListSuccess: (e) {
                late List<Post> postList = [];
                postList.addAll(e.posts);
                postList.sort((a,b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);

                return retrieveReservationPostProfiles(context, postList, listingForm, reservationItem, currentUser);
              },
              loadReservationPostListFailure: (_) => retrieveReservationPostProfiles(context, [], listingForm, reservationItem, currentUser),
              orElse: () => retrieveReservationPostProfiles(context, [], listingForm, reservationItem, currentUser)
          );
        },
      ),
    );
  }


  Widget retrieveReplyPostUser(String authorId, Post replyPost, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(authorId)),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadInProgress: (_) =>  JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                  loadSelectedProfileSuccess: (items) => reservationReplyContainer(context, currentUser, items.profile, replyPost),
                  orElse: () => reservationReplyContainer(context, currentUser, null, replyPost)
              );
            }
        )
    );
  }

  Widget reservationReplyContainer(BuildContext context, UserProfileModel currentUser, UserProfileModel? postUser, Post replyPost) {
    return SizedBox(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: ReservationPost(
        posts: [replyPost],
        profiles: (postUser != null) ? [postUser] : [],
        model: widget.model,
        onSubmitPressed: () {

        },
        isReplyPost: true,
        user: currentUser,
        onAvatarTap: (userProfile) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ReviewCurrentProfile(
              model: widget.model,
              currentUser: userProfile,
              didSelectEditProfile: (profile) {

                },
              );
            })
          );
        },
      ),
    );
  }


  Widget retrieveReservationPostProfiles(BuildContext context, List<Post> postList, ListingManagerForm listing,  ReservationItem reservationItem, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserAllProfilesStarted()),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadAllUserProfilesSuccess: (items) => retrieveReservationOwnerProfile(context, listing, reservationItem, currentUser, postList, items.profile),
                  orElse: () => retrieveReservationOwnerProfile(context, listing, reservationItem, currentUser, postList, [])
              );
            }
        )
    );
  }

  /// watch activity owner only
  Widget retrieveReservationOwnerProfile(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(reservation.reservationOwnerId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                loadSelectedProfileSuccess: (item) => retrieveActivitySettings(context, listing, reservation, item.profile, currentUser, postList, userProfiles),
                  orElse: () => retrieveActivitySettings(context, listing, reservation, null, currentUser, postList, [])
              );
            }
        )
    );
  }


  Widget retrieveActivitySettings(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles) {
    return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservation.reservationId.getOrCrash())),
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadActivityManagerFormSuccess: (item) => mainContainer(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, item.item),
              orElse: () => mainContainer(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, ActivityManagerForm.empty())
          );
        },
      ),
    );
  }


  Widget mainContainer(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm) {
        return BlocConsumer<BookedReservationFormBloc, BookedReservationFormState>(
           listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
           listener: (context, state) {
             print(state.authFailureOrSuccess);

             state.authFailureOrSuccessInviteLink.fold(
                     () => null,
                     (either) => either.fold(
                             (failure) {
                               final snackBar = SnackBar(
                                   backgroundColor: widget.model.paletteColor,
                                   content: failure.maybeMap(
                                     reservationServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.accentColor)),
                                     orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.accentColor)),
                                   )
                               );
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                             },
                   (r) {
                           Share.share(
                             r.toString(),
                             subject: 'You\'re Invited!');
                 }
               )
             );
             state.authFailureOrSuccess.fold(
                     () => {},
                     (either) => either.fold(
                         (failure) {
                       final snackBar = SnackBar(
                           backgroundColor: widget.model.webBackgroundColor,
                           content: failure.maybeMap(

                             reservationServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                             orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                           )
                       );
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     },
                         (_) {
                        setState(() {
                          isAffiliate = true;
                        });
                     }
                 )
             );
           },
           buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
           builder: (context, state) {

             final double closingRate = (_offset / (30 - 10 - 60));
             isOwner = currentUser.userId == reservation.reservationOwnerId;
             isAffiliate = reservation.reservationAffiliates?.where((element) => element.contactId == currentUser.userId && element.contactStatus == ContactStatus.joined).isNotEmpty ?? false;
             final resOwner = (userProfiles.where((element) => element.userId == reservation.reservationOwnerId).isNotEmpty) ? userProfiles.where((element) => element.userId == reservation.reservationOwnerId).first : currentUser;
             bool isLessThanMain = (MediaQuery.of(context).size.width <= 1400);

             return Stack(
               children: [
                 Container(
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height,
                 ),
                if (!(kIsWeb)) CustomScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    if (!widget.isReply) SliverAppBar(
                       expandedHeight: _expandedHeight(context),
                       collapsedHeight: _collapsedHeight,
                       stretch: true,
                       pinned: true,
                       centerTitle: true,
                        /// show if booking has ended.
                        /// show if booking is taking place now!
                       title: Column(
                         children: [
                           Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                           const SizedBox(height: 5),
                           if (reservation.reservationState == ReservationSlotState.completed) Container(
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(50),
                                   color: widget.model.accentColor.withOpacity(0.5)
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.all(4.0),
                                 child: Text('Finished', style: TextStyle(fontSize: 14, color: widget.model.accentColor)),
                               )
                           )
                         ],
                       ),
                       elevation: 0,
                       actions: [
                       ],
                       backgroundColor: widget.model.paletteColor,
                       flexibleSpace: LayoutBuilder(
                         builder: (BuildContext context, BoxConstraints constraints) {

                            return flexibleReservationProfileHeader(
                                context,
                                widget.model,
                                reservation,
                                listing,
                                isOwner,
                                userProfiles,
                                didSelectNewInvite: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                    return SendInvitationRequest(
                                      model: widget.model,
                                      currentUser: currentUser,
                                      currentGuests: reservation,
                                      );
                                    })
                                  );
                                },
                                didSelectAllParticipants: () {

                                  showGeneralDialog(
                                      barrierLabel: '',
                                      barrierDismissible: true,
                                      barrierColor: Colors.black.withOpacity(0.5),
                                      transitionDuration: const Duration(milliseconds: 400),
                                      context: context,
                                      pageBuilder: (contexts, anim1, anim2) {
                                        return ReservationAffiliatesWidget(
                                            model: widget.model,
                                            reservationId: reservation.reservationId.getOrCrash(),
                                            users: userProfiles,
                                            currentUser: currentUser,
                                            isOwner: isOwner,
                                            didSelectProfile: (userProfile) {


                                              Navigator.of(contexts).push(MaterialPageRoute(builder: (_) {
                                                return ReviewCurrentProfile(
                                                    currentUser: userProfile,
                                                    model: widget.model,
                                                    didSelectEditProfile: (profile) {

                                                  },
                                                );
                                              })
                                            );
                                          },
                                        );
                                      },
                                     transitionBuilder: (context, anim1, anim2, child) {
                                        return SlideTransition(
                                            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0.15)).animate(anim1),
                                           child: child,
                                        );
                                     }
                                  );
                                },
                            );
                         },
                       )
                     ),

                   //  SliverToBoxAdapter(
                   //    child: PostWidgetBuilder(
                   //        model: widget.model,
                   //        postList: widget.replyPosts ?? postList,
                   //        isReply: widget.isReply,
                   //        listing: listing,
                   //        currentUser: currentUser,
                   //        emptyPostView: (widget.isReply) ? emptyReplyContainer(context, widget.model) : emptyPostContainer(context, widget.model),
                   //        reservation: reservation,
                   //        userProfiles: userProfiles,
                   //        // onEndReached: () => _controller.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.easeIn),
                   //   ),
                   // ),
                 ],
               ),


                 // DraggableHome(
                 //   appBarColor: widget.model.paletteColor,
                 //   alwaysShowTitle: true,
                 //   alwaysShowLeadingAndAction: true,
                 //   title: Column(
                 //     children: [
                 //       Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                 //       const SizedBox(height: 5),
                 //       if (reservation.reservationState == ReservationSlotState.completed) Container(
                 //           decoration: BoxDecoration(
                 //               borderRadius: BorderRadius.circular(50),
                 //               color: widget.model.accentColor.withOpacity(0.5)
                 //           ),
                 //           child: Padding(
                 //             padding: const EdgeInsets.all(4.0),
                 //             child: Text('Finished', style: TextStyle(fontSize: 14, color: widget.model.accentColor)),
                 //           )
                 //       )
                 //     ],
                 //   ),
                 //   headerExpandedHeight: 0.78,
                 //   backgroundColor: widget.model.mobileBackgroundColor,
                 //   headerWidget: flexibleReservationProfileHeader(
                 //     context,
                 //     widget.model,
                 //     reservation,
                 //     listing,
                 //     isOwner,
                 //     userProfiles,
                 //     didSelectNewInvite: () {
                 //       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                 //         return SendInvitationRequest(
                 //           model: widget.model,
                 //           currentUser: currentUser,
                 //           currentGuests: reservation,
                 //         );
                 //       })
                 //       );
                 //     },
                 //     didSelectAllParticipants: () {
                 //       showGeneralDialog(
                 //           barrierLabel: '',
                 //           barrierDismissible: true,
                 //           barrierColor: Colors.black.withOpacity(0.5),
                 //           transitionDuration: const Duration(milliseconds: 400),
                 //           context: context,
                 //           pageBuilder: (contexts, anim1, anim2) {
                 //             return ReservationAffiliatesWidget(
                 //               model: widget.model,
                 //               reservationId: reservation.reservationId.getOrCrash(),
                 //               users: userProfiles,
                 //               currentUser: currentUser,
                 //               isOwner: isOwner,
                 //               didSelectProfile: (userProfile) {
                 //
                 //
                 //                 Navigator.of(contexts).push(MaterialPageRoute(builder: (_) {
                 //                   return ReviewCurrentProfile(
                 //                       currentUser: userProfile,
                 //                       model: widget.model
                 //                   );
                 //                 })
                 //                 );
                 //               },
                 //             );
                 //           },
                 //           transitionBuilder: (context, anim1, anim2, child) {
                 //             return SlideTransition(
                 //               position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0.15)).animate(anim1),
                 //               child: child,
                 //             );
                 //           }
                 //       );
                 //     },
                 //   ),
                 //   actions: [
                 //     if (isOwner) if (!state.isCreatingLink) IconButton(
                 //       onPressed: () {
                 //         setState(() {
                 //           context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishCreateNewInviteLink(reservation));
                 //         });
                 //       },
                 //       icon: Icon(Icons.ios_share_rounded, color: widget.model.accentColor),
                 //     ),
                 //     if (state.isCreatingLink) JumpingDots(numberOfDots: 2, color: widget.model.accentColor),
                 //     if (isAffiliate || isOwner) IconButton(
                 //       onPressed: () {
                 //         presentMoreOptions(
                 //             context,
                 //             widget.model,
                 //             isOwner,
                 //             currentUser,
                 //             reservation,
                 //             listing,
                 //             userProfiles,
                 //             didLeaveListing: () {
                 //               List<ContactDetails> updatedAffiliates = [];
                 //               updatedAffiliates.addAll(reservation.reservationAffiliates ?? []);
                 //
                 //               updatedAffiliates.removeWhere((element) => element.contactId == currentUser.userId);
                 //               context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didLeaveBookedReservation(reservation, updatedAffiliates));
                 //
                 //               Navigator.of(context).pop();
                 //             }
                 //         );
                 //       },
                 //       icon: Icon(Icons.more_vert_rounded, color: widget.model.accentColor),
                 //     ),
                 //   ],
                 //   body: [
                 //     PostWidgetBuilder(
                 //       model: widget.model,
                 //       postList: widget.replyPosts ?? postList,
                 //       isReply: widget.isReply,
                 //       listing: listing,
                 //       currentUser: currentUser,
                 //       emptyPostView: (widget.isReply) ? emptyReplyContainer(context, widget.model) : emptyPostContainer(context, widget.model),
                 //       reservation: reservation,
                 //       userProfiles: userProfiles,
                 //       // onEndReached: () => _controller.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.easeIn),
                 //     ),
                 //   ],
                 // ),



                // SingleChildScrollView(
                //   controller: _controller,
                //   child:  Padding(
                //     padding: const EdgeInsets.all(15.0),
                //     child: (isLessThanMain) ? Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.only(top: 120.0),
                //           child: mainContainerSectionOneRowTwo(context, postList, listing, currentUser, reservation, userProfiles),
                //       ),
                //     ],
                //   ) : Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //         Flexible(
                //           child: Container(
                //               constraints: BoxConstraints(
                //                 maxWidth: 550,
                //               ),
                //             child: mainContainerSectionOneRowTwo(
                //                 context,
                //                 postList,
                //                 listing,
                //                 currentUser,
                //                 reservation,
                //                 userProfiles
                //             )
                //           ),
                //         ),
                //         const SizedBox(width: 25),
                //         Container(
                //           width: 400,
                //             child: mainContainerSectionOneRowOne(
                //                 context,
                //                 listing,
                //                 reservation,
                //                 reservationOwner,
                //                 userProfiles,
                //                 activityForm)
                //         ),
                //         // if (MediaQuery.of(context).size.width >= 1300) SizedBox(width: MediaQuery.of(context).size.width * 0.025)
                //       ],
                //     ),
                //   )
                // ),

                 if (isLessThanMain) Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [

                       Row(
                       children: [
                         Flexible(
                           child: Center(
                             child: Container(
                               constraints: const BoxConstraints(maxWidth: 700),
                               child: mainContainerHeader(
                                 context,
                                 listing,
                                 reservation,
                                 reservationOwner,
                                 userProfiles,
                                 activityForm
                               ),
                             ),
                           ),
                         ),
                       ],
                       ),
                       const SizedBox(height: 10),
                       // Divider(color: widget.model.disabledTextColor),
                       Expanded(
                       child: Container(
                         child: PageView.builder(
                           controller: _pageController,
                           itemCount: 3,
                           scrollDirection: Axis.horizontal,
                           allowImplicitScrolling: true,
                           itemBuilder: (_, index) {
                               return SingleChildScrollView(
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                   child: Row(
                                     children: [
                                       if (index == 0) Flexible(
                                         child: Center(
                                           child: Container(
                                             constraints: const BoxConstraints(maxWidth: 700),
                                             child: ReservationActivityInfoWidget(
                                                 model: widget.model,
                                                 activityForm: activityForm,
                                                 activityOwner: reservationOwner,
                                                 reservation: reservation
                                             ),
                                           ),
                                         ),
                                       ),
                                       if (index == 1) Flexible(
                                         child: Center(
                                           child: Container(
                                             constraints: const BoxConstraints(maxWidth: 700),
                                             child: ReservationInfoWidget(
                                             model: widget.model,
                                             listing: listing,
                                             reservationItem: reservation,
                                             users: userProfiles,
                                             isOwner: isOwner,
                                             didSelectAllParticipants: () {

                                             },
                                             didSelectNewInvite: () {

                                              },
                                            ),
                                           ),
                                         ),
                                       ),
                                       if (index == 2) Flexible(
                                         child: Center(
                                           child: Container(
                                             constraints: const BoxConstraints(maxWidth: 700),
                                             child: mainContainerSectionOneRowTwo(
                                                 context,
                                                 postList,
                                                 listing,
                                                 currentUser,
                                                 reservation,
                                                 userProfiles
                                             ),
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 ),
                               );
                            }

                          )
                        ),
                      )
                   ]
                 ),

                 /// TODO: Side bar to contain - (Join, Buy, Leave, Interested...Button), Activity Title, Activity Dates, Activity Location??, Attending/Interested
                 /// TODO: Hide bottom when not on discussion..

                 // if (isLessThanMain) AnimatedContainer(
                 //   duration: Duration(milliseconds: 600),
                 //   curve: Curves.easeInOut,
                 //   color: widget.model.accentColor,
                 //   height: isShowingReservationInfo ? 600 : 130,
                 //   width: MediaQuery.of(context).size.width,
                 //   child: SingleChildScrollView(
                 //     controller: _headerController,
                 //     physics: (isShowingReservationInfo) ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                 //     child: Column(
                 //       children: [
                 //         const SizedBox(height: 10),
                 //         Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                 //         const SizedBox(height: 5),
                 //         Container(
                 //             decoration: BoxDecoration(
                 //                 borderRadius: BorderRadius.circular(50),
                 //                 color: widget.model.disabledTextColor
                 //             ),
                 //             child: Padding(
                 //               padding: const EdgeInsets.all(8.0),
                 //               child: Text(getReservationStateTitle(reservation.reservationState), style: TextStyle(fontSize: 14, color: widget.model.webBackgroundColor)),
                 //             )
                 //         ),
                 //         const SizedBox(height: 10),
                 //         InkWell(
                 //           onTap: () {
                 //             setState(() {
                 //               isShowingReservationInfo = !isShowingReservationInfo;
                 //
                 //               if (!isShowingReservationInfo) {
                 //                 _headerController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                 //               }
                 //             });
                 //           },
                 //           child: Container(
                 //             height: 35,
                 //             width: 35,
                 //             decoration: BoxDecoration(
                 //                 borderRadius: BorderRadius.circular(25),
                 //                 color: widget.model.paletteColor
                 //             ),
                 //             child: Icon(
                 //               isShowingReservationInfo ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up_rounded,
                 //               color: widget.model.accentColor,
                 //             ),
                 //           ),
                 //         ),
                 //         const SizedBox(height: 10),
                 //         AnimatedOpacity(
                 //           duration: const Duration(milliseconds: 300),
                 //             opacity: (isShowingReservationInfo) ? 1 : 0,
                 //             child: mainContainerSectionOneRowOne(
                 //                 context,
                 //                 listing,
                 //                 reservation,
                 //                 reservationOwner,
                 //                 userProfiles,
                 //                 activityForm)
                 //         )
                 //       ],
                 //     ),
                 //   ),
                 // ),

                 Positioned(
                  bottom: 0,
                   child: ClipRRect(
                     child: BackdropFilter(
                       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                       child: Container(
                         height: (widget.isReply && widget.replyToPost != null) ? (_selectedFileSpaceImage.isNotEmpty) ? 415 : 275 : (_selectedFileSpaceImage.isNotEmpty) ? 200 : 80,
                         width: MediaQuery.of(context).size.width,
                         color: Colors.grey.shade200.withOpacity(0.5),
                       ),
                     ),
                   ),
                 ),

                 AnimatedOpacity(
                     opacity: (_tabController?.index == 1 || _tabController?.index == 0) ? 1 : 0,
                     duration: const Duration(milliseconds: 900),
                     child: Column(
                       mainAxisSize: MainAxisSize.max,
                       mainAxisAlignment: MainAxisAlignment.end,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                       getInviteToJoinWidget(
                              context,
                              widget.model,
                              resOwner,
                              didSelectJoinBooking: () {
                                setState(() {

                                  final ContactDetails joinedContact = ContactDetails(
                                      contactId: currentUser.userId,
                                      name: currentUser.legalName,
                                      dateStarted: DateTime.now(),
                                      emailAddress: currentUser.emailAddress,
                                      contactStatus: ContactStatus.joined
                                  );
                                  List<ContactDetails> updatedAffiliates = [];
                                  updatedAffiliates.addAll(reservation.reservationAffiliates ?? []);

                                  final index = updatedAffiliates.indexWhere((element) => element.contactId == currentUser.userId);

                                  updatedAffiliates.replaceRange(index, index + 1, [joinedContact]);

                                  context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didJoinBookedReservation(reservation, updatedAffiliates));
                                });
                              },
                              didSelectCancel: () {
                                Navigator.of(context).pop();
                           }
                         )
                       ],
                     ),
                 ),

                 AnimatedOpacity(
                   opacity: (_tabController?.index == 2) ? 1 : 0,
                   duration: const Duration(milliseconds: 900),
                   curve: Curves.easeInOut,
                   child: Column(
                     mainAxisSize: MainAxisSize.max,
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // if (widget.isReply && widget.replyToPost != null) Padding(
                       //   padding: const EdgeInsets.only(left: 8.0),
                       //   child: Text('Reply To: ', style: TextStyle(color: widget.model.paletteColor)),
                       // ),
                       // if (widget.isReply && widget.replyToPost != null) retrieveReplyPostUser(
                       //     widget.replyToPost!.authorId.getOrCrash(),
                       //     widget.replyToPost!,
                       //     currentUser
                       // ),
                       AnimatedContainer(
                         duration: const Duration(milliseconds: 900),
                         curve: Curves.easeInOut,
                         height: (_selectedFileSpaceImage.isNotEmpty) ? 125 : 0,
                         child: MediaAttachmentPreview(
                           selectedMedia: _selectedFileSpaceImage.map((e) => Image.file(File(e.path))).toList(),
                           didRemoveMediaFromPost: (context, media) {
                             _selectedFileSpaceImage.removeWhere((element) => Image.file(File(element.path)).image == media.image);
                             setState(() {
                             });
                           },
                           model: widget.model,
                         ),
                       ),
                       retrieveInputForPost(context, state, reservation.reservationId.getOrCrash()),
                     ],
                   ),
                 ),

            ]
          );
       }
    );
  }

  Widget mainContainerHeader(BuildContext context, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel? reservationOwner, List<UserProfileModel> users, ActivityManagerForm activityForm) {
   return Stack(
     alignment: Alignment.bottomCenter,
     children: [
       AnimatedOpacity(
         duration: const Duration(milliseconds: 300),
         opacity: (_tabController?.index == 1) ? 1 : 0,
         child: SizedBox(
           height: 225,
           child: ClipRRect(
             borderRadius: BorderRadius.circular(25),
             child: PageView.builder(
                 itemCount: retrieveReservationSpacesFromListing(reservationItem, listing).length,
                 itemBuilder: (_, index) {
                   final SpaceOptionSizeDetail reservationSpace = retrieveReservationSpacesFromListing(reservationItem, listing)[index];

                   if (reservationSpace.spacePhoto != null) {
                     return Image(image: reservationSpace.spacePhoto!.image, fit: BoxFit.cover);
                   }
                   return  getActivityTypeTabOption(
                       context,
                       widget.model,
                       40,
                       false,
                       getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                 );
               }
             ),
           ),
         ),
       ),
       AnimatedOpacity(
         duration: const Duration(milliseconds: 300),
         opacity: (_tabController?.index == 0) ? 1 : 0,
         child: SizedBox(
           height: 225,
           child: ClipRRect(
             borderRadius: BorderRadius.circular(25),
             child: PageView.builder(
                 itemCount: activityForm.profileService.activityBackground.activityProfileImages?.length ?? 1,
                 itemBuilder: (context, index) {
                   final String activityImage = activityForm.profileService.activityBackground.activityProfileImages?[index].uriPath ?? '';
                   if (activityImage != '') {
                     return Image.network(activityImage, fit: BoxFit.cover);
                   }
                   return getActivityTypeTabOption(
                       context,
                       widget.model,
                       150,
                       false,
                       getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                 );
               }
             ),
           ),
         ),
       ),
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 4.0),
         child: Padding(
           padding: const EdgeInsets.only(bottom: 4.0),
           child: TabBar(
             controller: _tabController,
             onTap: (index) {
               setState(() {
                 _pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
               });
             },
             indicator: BoxDecoration(
                 borderRadius: BorderRadius.circular(25.0),
                 color: widget.model.paletteColor
             ),
             labelStyle: const TextStyle(fontWeight: FontWeight.bold),
             labelColor: widget.model.accentColor,
             unselectedLabelColor: widget.model.disabledTextColor,
             tabs: [
               ClipRRect(
                   borderRadius: BorderRadius.circular(25),
                   child: Tab(text: 'Activity')
               ),
               ClipRRect(
                   borderRadius: BorderRadius.circular(25),
                   child: const Tab(text: 'Reservation')
               ),
               ClipRRect(
                   borderRadius: BorderRadius.circular(25),
                   child: Tab(text: 'Discussion')
               )
             ],
           ),
         ),
       ),
     ],
   );
  }

  Widget mainContainerSectionOneRowOne(BuildContext context, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel? reservationOwner, List<UserProfileModel> users, ActivityManagerForm activityForm) {
   return Column(
     children: [
       Stack(
         alignment: Alignment.bottomCenter,
         children: [

           AnimatedOpacity(
             duration: const Duration(milliseconds: 300),
             opacity: (_tabController?.index == 0) ? 1 : 0,
             child: SizedBox(
               height: 225,
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(25),
                 child: PageView.builder(
                     itemCount: retrieveReservationSpacesFromListing(reservationItem, listing).length,
                     itemBuilder: (_, index) {
                       final SpaceOptionSizeDetail reservationSpace = retrieveReservationSpacesFromListing(reservationItem, listing)[index];

                       if (reservationSpace.spacePhoto != null) {
                         return Image(image: reservationSpace.spacePhoto!.image, fit: BoxFit.cover);
                       }
                       return  getActivityTypeTabOption(
                           context,
                           widget.model,
                           40,
                           false,
                           getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                       );
                     }
                 ),
               ),
             ),
           ),
           AnimatedOpacity(
             duration: const Duration(milliseconds: 300),
             opacity: (_tabController?.index == 1) ? 1 : 0,
             child: SizedBox(
               height: 225,
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(25),
                 child: PageView.builder(
                     itemCount: activityForm.profileService.activityBackground.activityProfileImages?.length ?? 1,
                     itemBuilder: (context, index) {
                       final String activityImage = activityForm.profileService.activityBackground.activityProfileImages?[index].uriPath ?? '';
                       if (activityImage != '') {
                        return Image.network(activityImage, fit: BoxFit.cover);
                       }
                       return getActivityTypeTabOption(
                        context,
                        widget.model,
                        150,
                        false,
                        getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                      );
                   }
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 4.0),
             child: Padding(
               padding: const EdgeInsets.only(bottom: 4.0),
               child: TabBar(
                 controller: _tabController,

                 onTap: (index) {
                   setState(() {
                     _pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                   });
                 },
                 indicator: BoxDecoration(
                     borderRadius: BorderRadius.circular(25.0),
                     color: widget.model.paletteColor
                 ),
                 labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                 labelColor: widget.model.accentColor,
                 unselectedLabelColor: widget.model.disabledTextColor,
                 tabs: [
                   ClipRRect(
                       borderRadius: BorderRadius.circular(25),
                       child: Tab(text: 'Activity')
                   ),
                   ClipRRect(
                       borderRadius: BorderRadius.circular(25),
                       child: const Tab(text: 'Reservation')
                   ),
                   ClipRRect(
                       borderRadius: BorderRadius.circular(25),
                       child: Tab(text: 'Discussion')
                   )
                 ],
               ),
             ),
           ),
         ],
       ),


       // const SizedBox(height: 10),
       // Divider(color: widget.model.disabledTextColor),
       // Container(
       //   constraints: BoxConstraints(
       //     maxHeight: MediaQuery.of(context).size.height - 450,
       //   ),
       //   child: PageView.builder(
       //       controller: _pageController,
       //       itemCount: 2,
       //       scrollDirection: Axis.horizontal,
       //       allowImplicitScrolling: true,
       //       physics: const NeverScrollableScrollPhysics(),
       //       itemBuilder: (_, index) {
       //         return SingleChildScrollView(
       //           child: (index == 0) ? ReservationInfoWidget(
       //             model: widget.model,
       //             listing: listing,
       //             reservationItem: reservationItem,
       //             users: users,
       //             isOwner: isOwner,
       //             didSelectAllParticipants: () {
       //
       //             },
       //             didSelectNewInvite: () {
       //
       //             },
       //           ) : ReservationActivityInfoWidget(
       //               model: widget.model,
       //               activityForm: activityForm,
       //               activityOwner: reservationOwner,
       //               reservation: reservationItem
       //           ),
       //         );
             //   if (index == 0) {
             //     return ReservationInfoWidget(
             //         model: widget.model,
             //         listing: listing,
             //         reservationItem: reservationItem,
             //         users: users,
             //         isOwner: isOwner,
             //         didSelectAllParticipants: () {
             //
             //         },
             //         didSelectNewInvite: () {
             //
             //         },
             //     );
             //   } else {
             //     return ReservationActivityInfoWidget(
             //         model: widget.model,
             //         activityForm: activityForm,
             //         activityOwner: users.where((element) => element.userId == reservationItem.reservationOwnerId).isNotEmpty ? users.where((element) => element.userId == reservationItem.reservationOwnerId).first : null,
             //         reservation: reservationItem
             //     );
             // }
     //       }
     //     ),
     //   )
     ],
   );
  }

  Widget mainContainerSectionOneRowTwo(BuildContext context, List<Post> postList, ListingManagerForm listing, UserProfileModel currentUser, ReservationItem reservation, List<UserProfileModel> userProfiles) {
   return PostWidgetBuilder(
     model: widget.model,
     postList: widget.replyPosts ?? postList,
     isReply: widget.isReply,
     listing: listing,
     currentUser: currentUser,
     emptyPostView: (widget.isReply) ? emptyReplyContainer(context, widget.model) : emptyPostContainer(context, widget.model),
     reservation: reservation,
     userProfiles: userProfiles,
     // headerWidget: headerWidget,
     // onEndReached: () => _controller.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.easeIn),
   );
  }





  Widget retrieveInputForPost(BuildContext context, BookedReservationFormState state, String reservationId) {
    return Input(
        isAudioAttachmentUploading: isAudioAttachmentUploading,
        isCameraImageAttachmentUploading: isCameraImageAttachmentUploading,
        isImageVideoAttachmentUploading: isImageVideoAttachmentUploading,
        onSubmitPressed: (postText) async {

          /// handle uploading media content to firebase, save all uri media content url's in new media post class
          final reference = FirebaseStorage.instance.ref('reservation/$reservationId/post_content/');
          final List<ImagePost> mediaPosts = [];

          if (_selectedFileSpaceImage.isNotEmpty) {
            for (XFile selectedImage in _selectedFileSpaceImage) {

              try {
                /// is uplading media content
                final UniqueId urlId = UniqueId();
                final imageFile = File(selectedImage.path);
                final decodeMedia = await decodeImageFromList(imageFile.readAsBytesSync());
                await reference.child(urlId.getOrCrash()).putFile(imageFile);
                final uri = await reference.child(urlId.getOrCrash()).getDownloadURL();


                final mediaPost = ImagePost(
                    name: urlId.getOrCrash(),
                    size: imageFile.lengthSync(),
                    uri: uri,
                    height: decodeMedia.height.toDouble(),
                    width: decodeMedia.width.toDouble()
                );

                mediaPosts.add(mediaPost);

              } catch (e) {
                /// could not upload media content
                final snackBar = SnackBar(
                    backgroundColor: widget.model.paletteColor,
                    content: Text(e.toString(), style: TextStyle(color: widget.model.webBackgroundColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
            setState(() {
              /// is finished uploading media content
              context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.imagesChanged(mediaPosts));
            });
          }

          setState(() {
            context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.textPostChanged(postText));
            if (widget.isReply && widget.replyToPost != null) {
              context.read<BookedReservationFormBloc>().add(
                  BookedReservationFormEvent.didFinishSubmittingReply(widget.replyToPost!)
              );
            } else {
              context.read<BookedReservationFormBloc>().add(
                  const BookedReservationFormEvent.didFinishSubmittingPost());
            }
            _selectedFileSpaceImage.clear();
          });


        },
        onAttachmentPressed: (type) async {

          switch (type) {

            case MediaType.camera:
              try {
                isCameraImageAttachmentUploading = true;
                final cameraImage = await _imagePicker.pickImage(source: ImageSource.camera);

                if (cameraImage != null) {
                  if ((_selectedFileSpaceImage.length + 1) <= 5) {
                    _selectedFileSpaceImage.add(cameraImage);
                    setState(() {});

                  } else {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.paletteColor,
                        content: Text('Sorry, a maximum of 5 images or videos can be posted at one time', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                isCameraImageAttachmentUploading = false;
              } catch (e) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: Text(e.toString(), style: TextStyle(color: widget.model.paletteColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              isCameraImageAttachmentUploading = false;
              return;
            case MediaType.multiPhotosVideo:
              try {
                isImageVideoAttachmentUploading = true;
                final multiImage = await _imagePicker.pickMultiImage();


                if (multiImage.isNotEmpty) {
                  if ((multiImage.length + _selectedFileSpaceImage.length) <= 5) {
                    _selectedFileSpaceImage.addAll(multiImage);
                    setState(() {});
                  } else {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.paletteColor,
                        content: Text('Sorry, a maximum of 5 images or videos can be posted at one time', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                isImageVideoAttachmentUploading = false;
              } catch (e) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: Text(e.toString(), style: TextStyle(color: widget.model.paletteColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                isImageVideoAttachmentUploading = false;
              }
              isImageVideoAttachmentUploading = false;
              break;
            case MediaType.audio:
            // TODO: Handle this case.
              break;
            default:
              return;
          }

        },
        isSubmitting: state.isSubmitting,
        model: widget.model
    );
  }



}