import 'dart:io';
import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:check_in_application/auth/update_services/booked_reservation_services/booked_reservation_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/reservation_post/image_post.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/invite_widgets/send_invitation_request.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_details_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/posts/post_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/posts/post_widget_builder.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_preview/activity_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/activity_settings_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/components/facility_overview_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_activity_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_affiliate_onboarding_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_affiliates_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_footer_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_info_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/profile_reservation_widget.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reservation_post/inputs/input.dart';
import 'package:reservation_post/inputs/media_attatchment_preview.dart';
import 'package:reservation_post/models/media_mode.dart';
import 'package:reservation_post/reservation_post.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../web_screens/focused_main_container_widgets/activity_attendee_ticket_settings_widget/activity_attendee_ticket_settings_container_widget.dart';
import '../../activity_tickets/activity_attendee_ticket_results_main.dart';

class ReservationResultMain extends StatefulWidget {

  final String? currentUserId;
  final String reservationId;
  final UserProfileModel? currentUser;
  final List<TicketItem>? currentUserTicketItems;
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
    this.currentUserTicketItems,
  });



  @override
  State<ReservationResultMain> createState() => _ReservationResultMainState();
}

class _ReservationResultMainState extends State<ReservationResultMain> with SingleTickerProviderStateMixin {

  final _controller = ScrollController();
  late TabController? _tabController;


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

  /// check if current user is reservation owner.
  late bool isOwner = false;

  ReservationMobileCreateNewMarker reservationMarker = ReservationMobileCreateNewMarker.listingDetails;
  /// check if current user is a reservation guest or affiliate.



 @override
  void initState() {
    _selectedFileSpaceImage = [];
    int tabIndex = ResOverViewTabs.values.indexWhere((element) => element == ReservationCoreHelper.resOverViewTabs);

    _tabController = TabController(initialIndex: tabIndex, length: 3, vsync: this);
    ReservationCoreHelper.pageController = PageController(initialPage: tabIndex, keepPage: true);

    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    _tabController?.dispose();
    // pageController?.dispose();
    super.dispose();
  }

  
  void showReservationTicketOptions(BuildContext context) {
    
  }

  void didSelectOptionsFromSettings(BuildContext context, DashboardModel model, bool isReservationOwner, UserProfileModel currentUser, List<UserProfileModel> users, ReservationItem reservation, ListingManagerForm listing, ResSettingMarker marker, ActivityManagerForm activityForm) async {
   switch (marker) {
     case ResSettingMarker.details:
       final index = ResOverViewTabs.values.indexWhere((element) => element == ResOverViewTabs.reservation);

       ReservationCoreHelper.resOverViewTabs = ResOverViewTabs.reservation;
       _tabController?.animateTo(index);
       ReservationCoreHelper.pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
       break;
     case ResSettingMarker.manageActivity:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resSettings.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
       break;
     case ResSettingMarker.manageAttendance:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resSettings.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
       break;
     case ResSettingMarker.manageActivityAttendees:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resAttendees.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resAttendees));
       break;
     case ResSettingMarker.manageActivityTickets:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resTicket.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resTicket));
       break;
     case ResSettingMarker.manageActivityPasses:
       break;
     case ResSettingMarker.messageOwner:
       showGeneralDialog(
         context: context,
         barrierDismissible: true,
         barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
         transitionDuration: Duration(milliseconds: 350),
         pageBuilder: (BuildContext contexts, anim1, anim2) {
           return StreamBuilder<types.Room>(
             stream: facade.FirebaseChatCore.instance.room(reservation.reservationId.getOrCrash()),
             builder: (context, snapshot) {
               final room = snapshot.data;

               if (!snapshot.hasData || room == null) {
                 return Scaffold(
                   backgroundColor: Colors.transparent,
                   body: noItemsFound(
                       widget.model,
                       Icons.chat_outlined,
                       'No Chats Yet!',
                       'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                       'Open Archive',
                       didTapStartButton: () {
                         setState(() {
                         });
                     }
                   ),
                 );
               }

               return  Align(
                       alignment: Alignment.center,
                       child: ClipRRect(
                           borderRadius: BorderRadius.all(Radius.circular(25)),
                           child: Container(
                               decoration: BoxDecoration(
                                   color: widget.model.accentColor,
                                   borderRadius: BorderRadius.all(Radius.circular(17.5))
                               ),
                               width: 550,
                               height: 750,
                               child: Scaffold(
                                 backgroundColor: Colors.transparent,
                                 appBar: (kIsWeb) ? AppBar(
                                 backgroundColor: model.paletteColor,
                                 ) : null,
                                 body: DirectChatScreen(
                                     room: room,
                                     model: model,
                                     currentUser: currentUser,
                                     reservationItem: reservation,
                                     isFromReservation: false
                                 ),
                               )
                           )
                       )

               );
             },
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
       break;
     case ResSettingMarker.sendInvites:
       showGeneralDialog(
         context: context,
         barrierDismissible: false,
         barrierLabel: 'Send Invite',
         transitionDuration: Duration(milliseconds: 350),
         pageBuilder: (BuildContext contexts, anim1, anim2) {
           return  Align(
               alignment: Alignment.center,
               child: ClipRRect(
                   borderRadius: BorderRadius.all(Radius.circular(25)),
                   child: Container(
                       decoration: BoxDecoration(
                           color: widget.model.accentColor,
                           borderRadius: BorderRadius.all(Radius.circular(17.5))
                       ),
                       width: 550,
                       height: 750,
                       child: SendInvitationRequest(
                         model: widget.model,
                         currentUser: widget.currentUser!,
                         attendeeType: AttendeeType.free,
                         reservationItem: reservation,
                         inviteType: InvitationType.reservation,
                         activityForm: activityForm,
                         didSelectInvite: (contacts) {},

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
       break;
     case ResSettingMarker.addCalendar:
       // TODO: Handle this case.
       break;
     case ResSettingMarker.receipts:
       if (reservation.receipt_link != null) {
         if (await canLaunchUrlString(reservation.receipt_link!)) {
           await launchUrlString(reservation.receipt_link!);
         }
       }
       break;
     case ResSettingMarker.showListing:
       // TODO: Handle this case.
       break;
     case ResSettingMarker.leaveReservation:
       // TODO: Handle this case.
       break;
   }
  }
  
  Widget getMainContainerForReservationOverview(BuildContext context, BookedReservationFormState state, bool isOwner, UserProfileModel resOwner, ListingManagerForm listing, ReservationItem reservation, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendee) {
   return Stack(
     children: [
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Expanded(
             child: Container(
                 child: mainContainerPageView(
                     context,
                     listing,
                     reservation,
                     isOwner,
                     reservationOwner,
                     currentUser,
                     postList,
                     userProfiles,
                     allAttendees,
                     activityForm
               )
             ),
           )
         ]
       ),
       Positioned(
         bottom: 0,
         child: ClipRRect(
           child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
             child: Container(
               height: (widget.isReply && widget.replyToPost != null) ? (_selectedFileSpaceImage.isNotEmpty && ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.discussion) ? 415 : 300 : (_selectedFileSpaceImage.isNotEmpty && ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.discussion) ? 220 : 80,
               width: MediaQuery.of(context).size.width,
               color: widget.model.accentColor.withOpacity(0.35)
             ),
           ),
         ),
       ),
       if (ReservationCoreHelper.resOverViewTabs != ResOverViewTabs.discussion) Positioned(
         bottom: 0,
         child: ClipRRect(
           child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
             child: Container(
               height: 100,
               width: MediaQuery.of(context).size.width,
               color: widget.model.accentColor.withOpacity(0.35)
             ),
           ),
         ),
       ),

       AnimatedOpacity(
         opacity: (ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.reservation || ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.activity) ? 1 : 0,
         duration: const Duration(milliseconds: 900),
         child: Visibility(
           visible: (ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.reservation || ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.activity),
           child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.end,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               getReservationFooterWidget(
                   context,
                   widget.model,
                   activityForm,
                   reservation,
                   currentAttendee,
                   allAttendees,
                   currentUser.userId,
                   isOwner,
                   false,
                   didSelectJoin: () {
                     setState(() {
                       presentNewAttendeeJoin(
                         context,
                         widget.model,
                         reservation,
                         activityForm,
                         resOwner
                       );
                     });
                    },
                     didSelectManage: () {
                      if (kIsWeb) {
                        Beamer.of(context).update(
                            configuration: RouteInformation(
                                location: '/${DashboardMarker.resSettings.toString()}'
                            ),
                            rebuild: false
                        );
                        context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) {
                              return ActivitySettingsScreenMobile(
                                model: widget.model,
                                reservationItem: reservation,
                                activityManagerForm: activityForm,
                                listing: listing,
                                currentUser: currentUser,
                              );
                            })
                        );
                      }
                     },
                     didSelectManageTickets: () {
                       setState(() {
                         if (kIsWeb) {
                           Beamer.of(context).update(
                               configuration: RouteInformation(
                                   location: '/${DashboardMarker.resAttendeeTicket.toString()}'
                               ),
                               rebuild: false
                           );
                           context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resAttendeeTicket));
                         } else {
                           Navigator.push(context, MaterialPageRoute(
                              builder: (_) {
                                return ActivityAttendeeTicketsResultMain(
                                  model: widget.model,
                                  tickets: widget.currentUserTicketItems ?? [],
                                  reservationItem: reservation,
                                  currentUser: currentUser,
                                  activityManagerForm: activityForm,
                                );
                              })
                            );
                         }
                       });
                     },
                     didSelectFindTickets: () {
                       setState(() {
                         presentNewTicketAttendeeJoin(
                           context,
                           widget.model,
                           reservation,
                           activityForm,
                           resOwner
                         );
                       });
                    },
                    didSelectManagePasses: () {
                     setState(() {
                       if (kIsWeb) {

                       } else {

                       }
                     });
                    },
                    didSelectFindPass: () {
                      setState(() {
                        if (kIsWeb) {

                        } else {

                        }
                      });
                    },
                   didSelectShare: () {

                   },
                   didSelectMoreOptions: () {
                       presentMoreOptions(
                           context,
                           widget.model,
                           isOwner,
                           currentUser,
                           activityForm,
                           reservation,
                           listing,
                           allAttendees,
                           currentAttendee,
                           didLeaveListing: () {
                             Navigator.of(context).pop();
                           },
                           didUpdateMarkerWeb: (marker) {
                             setState(() {
                               didSelectOptionsFromSettings(
                                   context,
                                   widget.model,
                                   isOwner,
                                   currentUser,
                                   userProfiles,
                                   reservation,
                                   listing,
                                   marker,
                                   activityForm
                               );
                             });
                           }
                        );

                 },
                 didSelectInterested: () {
                   if (kIsWeb) {

                   } else {

                   }
                 }
               ),
               const SizedBox(height: 8),
             ],
           ),
         ),
       ),

       AnimatedOpacity(
         opacity: (ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.discussion) ? 1 : 0,
         duration: const Duration(milliseconds: 900),
         curve: Curves.easeInOut,
         child: Visibility(
           visible: (ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.discussion),
           child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.end,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
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
               const SizedBox(height: 8),
             ],
           ),
         ),
       ),

       if (kIsWeb) mainContainerHeaderTabWeb(),
       if (!(kIsWeb)) Container(
         height: 160,
         width: MediaQuery.of(context).size.width,
         child: AppBar(
           toolbarHeight: 80,
           centerTitle: true,
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
               ),
             ],
           ),
           bottom: PreferredSize(
             preferredSize: const Size.fromHeight(0),
             child:  Padding(
               padding: const EdgeInsets.only(bottom: 8.0),
               child: mainContainerHeaderTabMobile(),
             ),
           ),
           elevation: 0,
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
             IconButton(
               onPressed: () {
                 presentMoreOptions(
                     context,
                     widget.model,
                     isOwner,
                     currentUser,
                     activityForm,
                     reservation,
                     listing,
                     allAttendees,
                     currentAttendee,
                     didLeaveListing: () {
                       // List<ContactDetails> updatedAffiliates = [];
                       // updatedAffiliates.addAll(reservation.reservationAffiliates ?? []);
                       //
                       // updatedAffiliates.removeWhere((element) => element.contactId == currentUser.userId);
                       // context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didLeaveBookedReservation(reservation, updatedAffiliates));

                       Navigator.of(context).pop();
                     },
                     didUpdateMarkerWeb: (marker) {
                         setState(() {
                           didSelectOptionsFromSettings(
                               context,
                               widget.model,
                               isOwner,
                               currentUser,
                               userProfiles,
                               reservation,
                               listing,
                               marker,
                               activityForm
                           );
                         });
                     }

                 );
               },
               icon: Icon(Icons.more_vert_rounded, color: widget.model.accentColor),
             ),
           ],
           backgroundColor: widget.model.paletteColor,
         ),
       ),
     ],
   );
  }
  


  @override
  Widget build(BuildContext context) {
   if (ReservationHelperCore.isLoading) {
     return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
   }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          if (widget.currentUser == null) BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.currentUserId!))),
          BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.reservationId))),
        ],
        child:  (widget.listing != null && widget.currentUser != null) ? retrieveReservation(widget.listing!, widget.currentUser!) : retrieveExistingPostFromLink()
      ),
    );
  }

  /// if presented from notification - retrieve reservation, listing and current user
  Widget retrieveExistingPostFromLink() {
    return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadReservationItemSuccess: (e) {
            return retrieveReservationListing(e.item);
          },
          orElse: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
        );
      },
    );
  }


  Widget retrieveReservationListing(ReservationItem reservation) {
    return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservation.instanceId.getOrCrash())),
        child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              loadListingManagerItemFailure: (_) => LoadingReservationCard(context),
              loadListingManagerItemSuccess: (item) {
                return retrieveCurrentUserProfile(reservation, item.failure);
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }

  /// retrieve current user
  Widget retrieveCurrentUserProfile(ReservationItem reservation, ListingManagerForm listing) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
            loadUserProfileSuccess: (item) => retrieveExistingPosts(reservation, listing, item.profile),
            orElse: () => Container()
          );
        },
      ),
    );
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
    return  MultiBlocProvider(
      providers: [
          BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentReservationPosts(widget.reservationId))),
          BlocProvider(create: (_) => getIt<BookedReservationFormBloc>()..add(BookedReservationFormEvent.initializedPostForm(bloc.optionOf(Post(authorId: currentUser.userId, id: UniqueId().getOrCrash(), status: PostStatus.sending, reservationId: widget.reservationId, type: PostType.text))))),
        ],
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
            if (kIsWeb) {

            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ReviewCurrentProfile(
                  model: widget.model,
                  currentUser: userProfile,
                  didSelectEditProfile: (profile) {

                },
              );
            }));
          }
        },
      ),
    );
  }

/// TODO: REMOVE THIS FROM RESERVATIONS - SHOULD NOT CALL WATCH ALL USERS
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
              loadActivityManagerFormSuccess: (item) => retrieveAllAttendees(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, item.item),
              orElse: () => retrieveAllAttendees(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, ActivityManagerForm.empty())
          );
        },
      ),
    );
  }

  Widget retrieveAllAttendees(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm) {
      return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(reservation.reservationId.getOrCrash())),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadAllAttendanceActivitySuccess: (item) => mainContainer(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, item.item),
                orElse: () => mainContainer(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, [])
          );
        },
      ),
    );
  }


  Widget mainContainer(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm, List<AttendeeItem> allAttendees) {
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
                          // isAffiliate = true;
                        });
                     }
                 )
             );
           },
           buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
           builder: (context, state) {

             isOwner = currentUser.userId == reservation.reservationOwnerId;
             final isAttendee = allAttendees.map((e) => e.attendeeOwnerId).contains(currentUser.userId);
             final AttendeeItem? currentAttendee = allAttendees.where((element) => element.attendeeOwnerId == currentUser.userId).isNotEmpty ? allAttendees.where((element) => element.attendeeOwnerId == currentUser.userId).first : null;
             final resOwner = (userProfiles.where((element) => element.userId == reservation.reservationOwnerId).isNotEmpty) ? userProfiles.where((element) => element.userId == reservation.reservationOwnerId).first : currentUser;


             List<NewReservationModel> reservationContainerModel = [
               NewReservationModel(
                 markerItem: ReservationMobileCreateNewMarker.listingDetails,
                 childWidget: getMainContainerForReservationOverview(
                     context,
                     state,
                     isOwner,
                     resOwner,
                     listing,
                     reservation,
                     reservationOwner,
                     currentUser,
                     postList,
                     userProfiles,
                     activityForm,
                     allAttendees,
                     currentAttendee
                 ),
               ),
             ];

             return Stack(
               alignment: Alignment.topCenter,
               children: [
                 Container(
                   color: widget.model.webBackgroundColor,
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height,
                 ),
                CreateNewMain(
                    child: reservationContainerModel.firstWhere((element) => element.markerItem == reservationMarker).childWidget
                ),

                /// handle activity attendee requirements


                /// handle invited [AttendeeItem] attendee...
                  if (isOwner == false &&
                     (currentAttendee != null) &&
                     (currentAttendee.contactStatus == ContactStatus.invited) &&
                      showAffiliateOnBoarding(currentAttendee.attendeeType)) ReservationAffiliateOnBoarding(
                       model: widget.model,
                       activityManagerForm: activityForm,
                       attendeeItem: currentAttendee,
                       reservation: reservation,
                       reservationOwner: resOwner,
                     )


            ]
          );
        }
      );
  }

  Widget mainContainerHeaderTabMobile() {
   return Container(
     height: 40,
     width: MediaQuery.of(context).size.width,
     child: TabBar(
       controller: _tabController,
       onTap: (index) {
         setState(() {
           ReservationCoreHelper.resOverViewTabs = ResOverViewTabs.values[index];
           ReservationCoreHelper.pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
         });
       },
       indicatorColor: widget.model.webBackgroundColor,
       labelStyle: const TextStyle(fontWeight: FontWeight.bold),
       labelColor: widget.model.webBackgroundColor,
       unselectedLabelColor: widget.model.disabledTextColor,
       tabs: ResOverViewTabs.values.map(
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
               padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                         controller: _tabController,
                         onTap: (index) {
                           setState(() {
                             ReservationCoreHelper.resOverViewTabs = ResOverViewTabs.values[index];
                             ReservationCoreHelper.pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                           });
                         },
                         indicator: BoxDecoration(
                             borderRadius: BorderRadius.circular(25.0),
                             color: widget.model.paletteColor
                         ),

                         labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                         labelColor: widget.model.accentColor,
                         unselectedLabelColor: widget.model.paletteColor,
                         tabs: ResOverViewTabs.values.map(
                                 (e) => ClipRRect(
                               borderRadius: BorderRadius.circular(25),
                               child: Tab(text: e.name.toUpperCase())
                         )
                       ).toList()
                     ),
                   ),
                 ),
               ),
             ),
           ),
         )
       )
     ],
   );
  }


  Widget mainContainerPageView(BuildContext context, ListingManagerForm listing, ReservationItem reservation, bool isOwner, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, List<AttendeeItem> allAttendees, ActivityManagerForm activityForm) {
   return PageView.builder(
       controller: ReservationCoreHelper.pageController,
       itemCount: 3,
       scrollDirection: Axis.horizontal,
       allowImplicitScrolling: true,
       physics: const NeverScrollableScrollPhysics(),
       itemBuilder: (_, index) {

         ResOverViewTabs pageIndex = ResOverViewTabs.values[index];

         return SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 25.0 : 0),
             child: Row(
               children: [
                   if (pageIndex == ResOverViewTabs.activity) Flexible(
                         child: Center(
                           child: Container(
                             constraints: const BoxConstraints(maxWidth: 700),
                             child: ReservationActivityInfoWidget(
                               model: widget.model,
                               activityForm: activityForm,
                               activityOwner: reservationOwner,
                               reservation: reservation,
                               listing: listing,
                               allAttendees: allAttendees,
                               didSelectActivityTicket: (ticket) {
                                 setState(() {
                                   if (reservationOwner != null) {
                                     presentNewTicketAttendeeJoin(
                                         context,
                                         widget.model,
                                         reservation,
                                         activityForm,
                                         reservationOwner
                                      );
                                    }
                                 });
                               },
                             ),
                           ),
                         ),
                       ),

                     if (pageIndex == ResOverViewTabs.reservation) Flexible(
                         child: Center(
                           child: Container(
                             constraints: const BoxConstraints(maxWidth: 700),
                             child: FacilityOverviewInfoWidget(
                               model: widget.model,
                               overViewState: FacilityPreviewState.reservation,
                               newFacilityBooking: reservation,
                               reservations: [],
                               /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
                               listingOwnerProfile: currentUser,
                               listing: listing,
                               marker: Marker(markerId: MarkerId(listing.listingServiceId.getOrCrash()), position: LatLng(listing.listingProfileService.listingLocationSetting.locationPosition?.latitude ?? 0, listing.listingProfileService.listingLocationSetting.locationPosition?.longitude ?? 0)),
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
                               isAttendee: true,
                           ),
                         ),
                       ),
                     ),


                     if (pageIndex == ResOverViewTabs.discussion) Flexible(
                         child: Center(
                           child: Container(
                             constraints: const BoxConstraints(maxWidth: 600),
                             child: Column(
                               children: [
                                 const SizedBox(height: (kIsWeb) ? 80 : 175),
                                 mainContainerSectionOneRowTwo(
                                     context,
                                     postList,
                                     listing,
                                     currentUser,
                                     reservation,
                                     userProfiles
                         ),
                       ],
                     ),
                   ),
                 ),
               )
             ]
           ),
         ),
       );
     }
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
              context.read<BookedReservationFormBloc>().add(const BookedReservationFormEvent.postIsSaving(true));
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



