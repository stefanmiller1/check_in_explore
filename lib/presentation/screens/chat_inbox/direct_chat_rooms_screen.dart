import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_helper_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DirectChatRoomsScreen extends StatefulWidget {

  final DashboardModel model;
  final bool isArchive;
  final Function() didSelectArchive;
  final Function() didSelectChats;
  final Function(types.Room room, UserProfileModel user) didSelectRoom;

  const DirectChatRoomsScreen({super.key, required this.model, required this.isArchive, required this.didSelectArchive, required this.didSelectChats, required this.didSelectRoom});

  @override
  State<DirectChatRoomsScreen> createState() => _DirectChatRoomsScreenState();
}

class _DirectChatRoomsScreenState extends State<DirectChatRoomsScreen> {

  late ScrollController? _scrollController;
  late List<types.Room> rooms = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    rooms.clear();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    rooms.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: retrieveAuthenticationState(context, Responsive.isMobile(context)),
        ),
        tablet: retrieveAuthenticationState(context, !Responsive.isMobile(context)),
        desktop: retrieveAuthenticationState(context, !Responsive.isMobile(context))
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, bool isBrowser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => emptyLoadingListView(context, isBrowser),
              loadProfileFailure: (_) => (isBrowser) ? GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },) : emptyLoadingListView(context, true),
              loadUserProfileSuccess: (item) => getChatRooms(context, item.profile),
              orElse: () {
                return emptyLoadingListView(context, isBrowser);
            }
          );
        },
      ),
    );
  }


  Widget getChatRooms(BuildContext context, UserProfileModel profile) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<List<types.Room>>(
              stream: facade.FirebaseChatCore.instance.rooms(orderByUpdatedAt: true, isArchived: widget.isArchive),
              builder: (context, snapshot) {

                if (!snapshot.hasData || (snapshot.data?.isEmpty ?? false) == true || snapshot.data == null) {
                  if (widget.isArchive) {
                    noItemsFound(
                        widget.model,
                        Icons.archive_outlined,
                        'No Chats Have been Archived Yet!',
                        'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                        'Open Chats',
                        didTapStartButton: () {
                          setState(() {
                            widget.didSelectChats();
                          });
                        }
                    );
                  } else {
                    return noItemsFound(
                        widget.model,
                        Icons.chat_outlined,
                        'No Chats Yet!',
                        'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                        'Open Archive',
                        didTapStartButton: () {
                          setState(() {
                            widget.didSelectArchive();
                          });
                        }
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting && rooms.isEmpty) {
                  return Container(
                    height: MediaQuery.of(context).size.height - 170,
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

                if (rooms.isEmpty) {
                  rooms.addAll(snapshot.data ?? []);
                }

                // if (snapshot.data != null) {
                //   if (snapshot.data!.length != rooms.length) {
                //     rooms.clear();
                //     rooms.addAll(snapshot.data ?? []);
                //   }
                // }

                  return Container(
                    height: MediaQuery.of(context).size.height - 170,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final room = rooms[index];

                          late List dateSlotsData = [];
                          if (room.metadata?['reservationSlot'] != null) {
                            dateSlotsData.addAll(room.metadata?['reservationSlot']);
                          }

                          final List<ReservationSlotItem> dates = dateSlotsData.isNotEmpty ? dateSlotsData.map((e) => ReservationSlotItemDto.fromJson(e).toDomain()).toList() : [];

                          return StreamBuilder<List<types.Message>>(
                            stream: facade.FirebaseChatCore.instance.messages(room, limit: 3),
                            builder: (context, messageSnapshot) {

                              final bool hasReadLastMessages = messageSnapshot.data?.where((element) => element.author.id != facade.FirebaseChatCore.instance.firebaseUser?.uid && element.status != types.Status.seen).isNotEmpty ?? false;

                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: getRoomListTile(
                                        widget.model,
                                        room,
                                        ChatHelperCore.selectedRoom == room,
                                        hasReadLastMessages,
                                        false,
                                        messageSnapshot.data ?? [],
                                        dates,
                                        didSelectRoom: (e) {
                                            widget.didSelectRoom(e, profile);
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