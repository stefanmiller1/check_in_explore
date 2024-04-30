import 'dart:io';

import 'package:check_in_application/auth/update_services/booked_reservation_services/booked_reservation_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_results_main.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/reservation_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reservation_post/reservation_post.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PostWidgetBuilder extends StatefulWidget {

  const PostWidgetBuilder({super.key,
    required this.model,
    required this.postList,
    required this.currentUser,
    required this.emptyPostView,
    required this.reservation,
    required this.listing,
    required this.isReply,
    required this.userProfiles,
    this.onEndReached,
    this.autoScrollController,
    this.headerWidget,
  });

  /// see all post users
  final List<UserProfileModel> userProfiles;

  /// see [ListingManagerForm]
  final ListingManagerForm listing;

  /// see [ReservationItem]
  final ReservationItem reservation;

  /// see [DashboardModel]
  final DashboardModel model;

  /// is reply post.
  final bool isReply;

  /// existing reply posts
  final List<Post> postList;

  /// current user see [UserProfileModel]
  final UserProfileModel currentUser;

  /// if post is empty
  final Widget emptyPostView;

  /// see [ReservationPostList.onEndReached].
  final Future<void> Function()? onEndReached;

  /// See [PostList.autoScrollController].
  /// If provided, you cannot use the scroll to message functionality.
  final AutoScrollController? autoScrollController;

  /// scroll controller
  final Widget? headerWidget;

  @override
  State<PostWidgetBuilder> createState() => _PostWidgetBuilderState();
}

class _PostWidgetBuilderState extends State<PostWidgetBuilder> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postList.isEmpty && retrieveSystemMessages(widget.reservation, widget.currentUser.userId).isEmpty) {
      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: widget.emptyPostView
      );
    }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: reservationMainContainer(context, widget.userProfiles, widget.postList),
    );
  }



  Widget reservationMainContainer(BuildContext context, List<UserProfileModel> users, List<Post> postList) {

    List<Post> posts = [];

    posts.addAll(postList);
    posts.addAll(retrieveSystemMessages(widget.reservation, widget.currentUser.userId));

    posts = posts..sort((a,b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));


    return ReservationPost(
      posts: posts,
      profiles: users,

      model: widget.model,
      onSubmitPressed: () {

      },
      isReplyPost: widget.isReply,
      user: widget.currentUser,
      headerWidget: widget.headerWidget,
      onAvatarTap: (userProfile) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ReviewCurrentProfile(
            model: widget.model,
            currentUser: userProfile,
            didSelectEditProfile: (profile) {

              if (!kIsWeb) {
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
                } else {

                }
              }, showBack: true,
            );
          })
        );
      },
      onEndReached: widget.onEndReached,
      scrollController: widget.autoScrollController,
      onPostDoubleTap: (context, post) {

      },
      onPostLongPress: (context, post) {

      },
      onPostStatusTap: (context, post) {

      },
      onPostTap: (context, post) {

      },
      onPostOptionsTap: (context, post) {
        setState(() {
          /// to flag or hide posts?
        });
      },
      onPostFooterReplyTap: (context, post) {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return ReservationResultMain(
                  currentUserId: widget.currentUser.userId.getOrCrash(),
                  reservationId: widget.reservation.reservationId.getOrCrash(),
                  currentUser: widget.currentUser,
                  model: widget.model,
                  replyToPost: postList.where((element) => element.id == post.id).first,
                  replyPosts: postList.where((element) => element.repliedPost?.id == post.id).toList(),
                  listing: widget.listing,
                  isReply: true,
              );
            })
          );
        });
      },
      onPostFooterLikeTap: (context, post) {
        setState(() {
          late Post postToUpdate = post;

          List<UniqueId> likedPosts = [];
          likedPosts.addAll(post.postLikes ?? []);

          if (likedPosts.map((e) => e.getOrCrash()).contains(widget.currentUser.userId.getOrCrash())) {
            likedPosts.removeWhere((element) => element.getOrCrash() == widget.currentUser.userId.getOrCrash());
          } else {
            likedPosts.add(widget.currentUser.userId);
          }
          postToUpdate = postToUpdate.copyWith(
              postLikes: likedPosts
          );
          context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishLikePost(postToUpdate));
        });
      },
      onPostFooterBookmarkTap: (context, post) {

      },
      onPostLikeTap: (context, post) {

      },
      onPostReplyTap: (context, post) {

      },
    );
  }
}