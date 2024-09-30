import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMainContainerWidget extends StatelessWidget {

  final DashboardModel model;
  final types.Room? room;
  final UserProfileModel? currentUser;

  const ChatMainContainerWidget({super.key,
    required this.model,
    this.room,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child:  (room != null) ? DirectChatScreen(
          room: room,
          model: model,
          currentUser: currentUser,
          reservationItem: null,
          isFromReservation: false
      ) : Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.message_outlined, color: model.disabledTextColor, size: 85),
            const SizedBox(height: 10),
            Text('Your Chats', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 10),
            Text('Select any chat from the list to get the conversation started', style: TextStyle(color: model.disabledTextColor)),
          ],
        ),
      ),
    );
  }
}