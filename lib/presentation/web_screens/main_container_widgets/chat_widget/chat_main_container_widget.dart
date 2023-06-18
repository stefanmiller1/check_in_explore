import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_rooms_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_helper_core.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/chat_widget/chat_sub_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child:  (ChatHelperCore.selectedRoom != null) ? DirectChatScreen(
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
      )
    );
  }
}