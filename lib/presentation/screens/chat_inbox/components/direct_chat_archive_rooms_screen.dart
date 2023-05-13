import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter_bloc/flutter_bloc.dart';

class DirectChatArchiveRoomsScreen extends StatefulWidget {

  final DashboardModel model;

  const DirectChatArchiveRoomsScreen({super.key, required this.model});

  @override
  State<DirectChatArchiveRoomsScreen> createState() => _DirectChatArchiveRoomsScreenState();
}

class _DirectChatArchiveRoomsScreenState extends State<DirectChatArchiveRoomsScreen> {

  late ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: widget.model.paletteColor,
          title: Text('Your Archive', style: TextStyle(color: widget.model.accentColor),
          ),
        ),
        body: retrieveAuthenticationState(context)
    );
  }

  Widget retrieveAuthenticationState(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => progressOverlay(widget.model),
              loadProfileFailure: (_) => GetLoginSignUpWidget(model: widget.model),
              loadUserProfileSuccess: (item) => getChatRooms(context, item.profile),
              orElse: () {
                return progressOverlay(widget.model);
              }
          );
        },
      ),
    );
  }

  Widget getChatRooms(BuildContext context, UserProfileModel currentUser) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<List<types.Room>>(
              stream: facade.FirebaseChatCore.instance.rooms(orderByUpdatedAt: true, isArchived: true),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: MediaQuery.of(context).size.height - 180,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: loadingRoomItem(context),
                          );
                        }),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(child: Text('No Chats have been Archived yet!', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center)));
                }


                return Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final room = snapshot.data![index];
                        late List dateSlotsData = [];
                        if (room.metadata?['reservationSlot'] != null) {
                          dateSlotsData = room.metadata?['reservationSlot'];
                        }
                        final List<ReservationSlotItem> dates = dateSlotsData.isNotEmpty ? dateSlotsData.map((e) => ReservationSlotItemDto.fromJson(e).toDomain()).toList() : [];

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return loadingRoomItem(context);
                        }

                        return StreamBuilder<List<types.Message>>(
                            stream: facade.FirebaseChatCore.instance.messages(room, limit: 3),
                            builder: (context, messageSnapshot) {

                              final bool hasReadLastMessages = messageSnapshot.data?.where((element) => element.author.id != facade.FirebaseChatCore.instance.firebaseUser?.uid && element.status != types.Status.seen).isNotEmpty ?? false;

                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  child: getRoomListTile(
                                      widget.model,
                                      room,
                                      false,
                                      hasReadLastMessages,
                                      true,
                                      messageSnapshot.data ?? [],
                                      dates,
                                      didSelectRoom: (e) {
                                        setState(() {
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (_) {
                                                return DirectChatScreen(
                                                  model: widget.model,
                                                  room: e,
                                                  currentUser: currentUser,
                                                  reservationItem: null,
                                                  isFromReservation: false,
                                                );
                                              }));
                                        });
                                      }
                                  )
                              );
                            }
                        );
                      }
                  ),
                );
              }
          ),
        ],
      ),
    );
  }

}