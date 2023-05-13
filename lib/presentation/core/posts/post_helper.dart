import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/auth/reservation_manager/post.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<Post> retrieveReplyPosts(List<Post> allPosts, String replyPostId) {
  List<Post> replies = [];
  replies.addAll(allPosts);

  return replies.where((element) => element.repliedPost != null && element.repliedPost?.id == replyPostId).toList();
}


List<Post> retrieveReplyPostGroup(List<Post> allPosts, Post replyPost, int groupMessagesThreshold) {
  List<Post> reply = [];

  /// retrieve previous post item.
  for (var i = allPosts.length - 1; i >= 0; i--) {
    final post = allPosts[i];
    final isReplyPost = post.id == replyPost.id;
    var isFirstPostInGroup = false;

    if (isReplyPost && !reply.contains(post)) {
      reply.add(post);
    }

    // if (post.createdAt.isBeforeOrEqualTo(replyPost.createdAt ?? DateTime.now()) ?? false) {
    //   final previousPost = allPosts[i + 1];
    //   final previousPostIsSameAuthor = previousPost.authorId == replyPost.authorId;
    //
    //
    //   if (previousPost.createdAt != null && post.createdAt != null && previousPost.type != PostType.system && previousPostIsSameAuthor) {
    //     isFirstPostInGroup = previousPostIsSameAuthor && post.createdAt!.difference(previousPost.createdAt!).inMilliseconds <= groupMessagesThreshold;
    //
    //   }
    // }

  }

  return reply;
}

Widget emptyPostContainer(BuildContext context, DashboardModel model) {
  return SizedBox(
    height: 400,
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: model.accentColor
              ),
              child: Icon(Icons.chat_outlined, size: 40, color: model.disabledTextColor)),
          const SizedBox(height: 10),
          Text('Be the first to say Something!', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize),),
          const SizedBox(height: 5),
          Text('What\'s on your mind?', style: TextStyle(color: model.disabledTextColor))
        ],
      ),
    ),
  );
}

Widget emptyReplyContainer(BuildContext context, DashboardModel model) {
  return SizedBox(
    height: 400,
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: Column(
        children: [
            const SizedBox(height: 15),
            Container(
              width: 100,
              height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: model.accentColor
                ),
                child: Icon(Icons.chat_outlined, size: 40, color: model.disabledTextColor)),
            const SizedBox(height: 10),
            Text('Be the first to leave a reply!', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize),),
            const SizedBox(height: 5),
            Text('What\'s on your mind?', style: TextStyle(color: model.disabledTextColor))
        ],
      ),
    ),
  );
}