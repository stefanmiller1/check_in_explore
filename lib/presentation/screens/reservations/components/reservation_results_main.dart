import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:check_in_application/auth/update_services/booked_reservation_services/booked_reservation_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/reservation_post/image_post.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/send_invitation_request.dart';
import 'package:check_in_web_mobile_explore/presentation/core/posts/post_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/posts/post_widget_builder.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_affiliates_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_invite_join.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/profile_reservation_widget.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

class _ReservationResultMainState extends State<ReservationResultMain> {

  final _controller = ScrollController();
  final _pageController = PageController(initialPage: 0);
  double _offset = 0;
  late double _percentageOpen = 0;
  // /// image picker for sending photo's, videos with post.
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
    super.initState();
  }

  moveOffset() {
    setState(() {
      _offset = min(max(0, _controller.offset / 6 - 16), 32);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(moveOffset);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
            resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
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
              resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
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
                  loadAllUserProfilesSuccess: (items) => mainContainer(context, listing, reservationItem, currentUser, postList, items.profile),
                  orElse: () => mainContainer(context, listing, reservationItem, currentUser, postList, [])
              );
            }
        )
    );
  }


  Widget mainContainer(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles) {
       return BlocConsumer<BookedReservationFormBloc, BookedReservationFormState>(
           listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
           listener: (context, state) {
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

             return Stack(
               children: [

                 DraggableHome(
                   appBarColor: widget.model.paletteColor,
                   alwaysShowTitle: true,
                   alwaysShowLeadingAndAction: true,
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
                   headerExpandedHeight: 0.78,
                   backgroundColor: widget.model.mobileBackgroundColor,
                   headerWidget: flexibleReservationProfileHeader(
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
                                       model: widget.model
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
                   ),
                   actions: [
                     if (isOwner) if (!state.isCreatingLink) IconButton(
                       onPressed: () {
                         setState(() {
                           context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishCreateNewInviteLink(reservation));
                         });
                       },
                       icon: Icon(Icons.ios_share_rounded, color: widget.model.accentColor),
                     ),
                     if (state.isCreatingLink) JumpingDots(numberOfDots: 2, color: widget.model.accentColor),
                     if (isAffiliate || isOwner) IconButton(
                       onPressed: () {
                         presentMoreOptions(
                             context,
                             widget.model,
                             isOwner,
                             currentUser,
                             reservation,
                             listing,
                             userProfiles,
                             didLeaveListing: () {
                               List<ContactDetails> updatedAffiliates = [];
                               updatedAffiliates.addAll(reservation.reservationAffiliates ?? []);

                               updatedAffiliates.removeWhere((element) => element.contactId == currentUser.userId);
                               context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didLeaveBookedReservation(reservation, updatedAffiliates));

                               Navigator.of(context).pop();
                             }
                         );
                       },
                       icon: Icon(Icons.more_vert_rounded, color: widget.model.accentColor),
                     ),
                   ],
                   // expandedBody: flexibleReservationProfileHeader(
                   //   context,
                   //   widget.model,
                   //   reservation,
                   //   listing,
                   //   isOwner,
                   //   userProfiles,
                   //   didSelectNewInvite: () {
                   //     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                   //       return SendInvitationRequest(
                   //         model: widget.model,
                   //         currentUser: currentUser,
                   //         currentGuests: reservation,
                   //       );
                   //     })
                   //     );
                   //   },
                   //   didSelectAllParticipants: () {
                   //     showGeneralDialog(
                   //         barrierLabel: '',
                   //         barrierDismissible: true,
                   //         barrierColor: Colors.black.withOpacity(0.5),
                   //         transitionDuration: const Duration(milliseconds: 400),
                   //         context: context,
                   //         pageBuilder: (contexts, anim1, anim2) {
                   //           return ReservationAffiliatesWidget(
                   //             model: widget.model,
                   //             reservationId: reservation.reservationId.getOrCrash(),
                   //             users: userProfiles,
                   //             currentUser: currentUser,
                   //             isOwner: isOwner,
                   //             didSelectProfile: (userProfile) {
                   //
                   //
                   //               Navigator.of(contexts).push(MaterialPageRoute(builder: (_) {
                   //                 return ReviewCurrentProfile(
                   //                     currentUser: userProfile,
                   //                     model: widget.model
                   //                 );
                   //               })
                   //               );
                   //             },
                   //           );
                   //         },
                   //         transitionBuilder: (context, anim1, anim2, child) {
                   //           return SlideTransition(
                   //             position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0.15)).animate(anim1),
                   //             child: child,
                   //           );
                   //         }
                   //     );
                   //   },
                   // ),
                   // fullyStretchable: false,
                   body: [
                     PostWidgetBuilder(
                       model: widget.model,
                       postList: widget.replyPosts ?? postList,
                       isReply: widget.isReply,
                       listing: listing,
                       currentUser: currentUser,
                       emptyPostView: (widget.isReply) ? emptyReplyContainer(context, widget.model) : emptyPostContainer(context, widget.model),
                       reservation: reservation,
                       userProfiles: userProfiles,
                       // onEndReached: () => _controller.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.easeIn),
                     ),
                   ],
                 ),
                //  CustomScrollView(
                //    controller: _controller,
                //    physics: const BouncingScrollPhysics(),
                //    slivers: [
                //      if (!widget.isReply) SliverAppBar(
                //         expandedHeight: _expandedHeight(context),
                //         collapsedHeight: _collapsedHeight,
                //         stretch: true,
                //         pinned: true,
                //         centerTitle: true,
                //          /// show if booking has ended.
                //          /// show if booking is taking place now!
                //         title: Column(
                //           children: [
                //             Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
                //             const SizedBox(height: 5),
                //             if (reservation.reservationState == ReservationSlotState.completed) Container(
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(50),
                //                     color: widget.model.accentColor.withOpacity(0.5)
                //                 ),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(4.0),
                //                   child: Text('Finished', style: TextStyle(fontSize: 14, color: widget.model.accentColor)),
                //                 )
                //             )
                //           ],
                //         ),
                //         elevation: 0,
                //         actions: [
                //           if (isOwner) if (!state.isCreatingLink) IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishCreateNewInviteLink(reservation));
                //               });
                //             },
                //             icon: Icon(Icons.ios_share_rounded, color: widget.model.accentColor),
                //           ),
                //           if (state.isCreatingLink) JumpingDots(numberOfDots: 2, color: widget.model.accentColor),
                //           if (isAffiliate || isOwner) IconButton(
                //             onPressed: () {
                //               presentMoreOptions(
                //                   context,
                //                   widget.model,
                //                   isOwner,
                //                   currentUser,
                //                   reservation,
                //                   listing,
                //                   userProfiles,
                //                   didLeaveListing: () {
                //                     List<ContactDetails> updatedAffiliates = [];
                //                     updatedAffiliates.addAll(reservation.reservationAffiliates ?? []);
                //
                //                     updatedAffiliates.removeWhere((element) => element.contactId == currentUser.userId);
                //                     context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didLeaveBookedReservation(reservation, updatedAffiliates));
                //
                //                     Navigator.of(context).pop();
                //                   }
                //               );
                //             },
                //             icon: Icon(Icons.more_vert_rounded, color: widget.model.accentColor),
                //           ),
                //         ],
                //         backgroundColor: widget.model.paletteColor,
                //         flexibleSpace: LayoutBuilder(
                //           builder: (BuildContext context, BoxConstraints constraints) {
                //
                //              return flexibleReservationProfileHeader(
                //                  context,
                //                  widget.model,
                //                  reservation,
                //                  listing,
                //                  isOwner,
                //                  userProfiles,
                //                  didSelectNewInvite: () {
                //                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                //                      return SendInvitationRequest(
                //                        model: widget.model,
                //                        currentUser: currentUser,
                //                        currentGuests: reservation,
                //                        );
                //                      })
                //                    );
                //                  },
                //                  didSelectAllParticipants: () {
                //
                //                    showGeneralDialog(
                //                        barrierLabel: '',
                //                        barrierDismissible: true,
                //                        barrierColor: Colors.black.withOpacity(0.5),
                //                        transitionDuration: const Duration(milliseconds: 400),
                //                        context: context,
                //                        pageBuilder: (contexts, anim1, anim2) {
                //                          return ReservationAffiliatesWidget(
                //                              model: widget.model,
                //                              reservationId: reservation.reservationId.getOrCrash(),
                //                              users: userProfiles,
                //                              currentUser: currentUser,
                //                              isOwner: isOwner,
                //                              didSelectProfile: (userProfile) {
                //
                //
                //                                Navigator.of(contexts).push(MaterialPageRoute(builder: (_) {
                //                                  return ReviewCurrentProfile(
                //                                      currentUser: userProfile,
                //                                      model: widget.model
                //                                  );
                //                                 })
                //                                );
                //                              },
                //                          );
                //                        },
                //                       transitionBuilder: (context, anim1, anim2, child) {
                //                          return SlideTransition(
                //                              position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0.15)).animate(anim1),
                //                             child: child,
                //                          );
                //                       }
                //                    );
                //                  },
                //              );
                //           },
                //         )
                //       ),
                //      const SliverToBoxAdapter(
                //        child: SizedBox(
                //          height: 5,
                //        ),
                //      ),
                //
                //      SliverToBoxAdapter(
                //        child: PostWidgetBuilder(
                //            model: widget.model,
                //            postList: widget.replyPosts ?? postList,
                //            isReply: widget.isReply,
                //            listing: listing,
                //            currentUser: currentUser,
                //            emptyPostView: (widget.isReply) ? emptyReplyContainer(context, widget.model) : emptyPostContainer(context, widget.model),
                //            reservation: reservation,
                //            userProfiles: userProfiles,
                //            // onEndReached: () => _controller.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.easeIn),
                //       ),
                //     ),
                //   ],
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
                 Positioned(
                   bottom: 10,
                   child: Container(
                     width: MediaQuery.of(context).size.width,
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           if (widget.isReply && widget.replyToPost != null) Padding(
                             padding: const EdgeInsets.only(left: 8.0),
                             child: Text('Reply To: ', style: TextStyle(color: widget.model.paletteColor)),
                           ),
                           if (widget.isReply && widget.replyToPost != null) retrieveReplyPostUser(
                               widget.replyToPost!.authorId.getOrCrash(),
                               widget.replyToPost!,
                               currentUser
                           ),
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
                           if (isOwner || isAffiliate) retrieveInputForPost(context, state, reservation.reservationId.getOrCrash()),
                           if (!isOwner && !isAffiliate) getInviteToJoinWidget(
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
                   )
                 ),
               )
            ]
          );
       }
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