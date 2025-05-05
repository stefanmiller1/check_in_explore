import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:beamer/beamer.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_rooms_screen.dart';
import 'package:flutter/material.dart';

class ChatSubContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final String? initialRoomId;
  final Function() didSelectRoom;

  const ChatSubContainerWidget({super.key, required this.model, required this.initialRoomId, required this.didSelectRoom});

  @override
  State<ChatSubContainerWidget> createState() => _ChatSubContainerWidgetState();
}

class _ChatSubContainerWidgetState extends State<ChatSubContainerWidget> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(height: 50),
        const SizedBox(height: 50),
        Expanded(
          child: RoomsScreen(
            model: widget.model,
            initialSelectedRoomId: widget.initialRoomId,
            didSelectRoom: (room, profile) {
              
              RoomsHelperCore.isLoading = true;
              RoomsHelperCore.selectedRoomId = room.id;
              RoomsHelperCore.currentUserProfile = profile;
              Beamer.of(context).update(
                configuration: RouteInformation(
                  uri: Uri.parse(chatWithIdRoute(room.id)),
                ),
                rebuild: false,
              );
              widget.didSelectRoom();
          
              Future.delayed(const Duration(seconds: 1), () {
                RoomsHelperCore.isLoading = false;
                widget.didSelectRoom();
              });

              widget.didSelectRoom();
            }
          ),
        ),
      ],
    );
  }
}


