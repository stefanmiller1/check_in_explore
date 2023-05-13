import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/components/direct_chat_archive_rooms_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DirectChatRoomsScreen extends StatefulWidget {

  final DashboardModel model;

  const DirectChatRoomsScreen({super.key, required this.model});

  @override
  State<DirectChatRoomsScreen> createState() => _DirectChatRoomsScreenState();
}

class _DirectChatRoomsScreenState extends State<DirectChatRoomsScreen> {

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

    return Responsive(
        mobile: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: retrieveAuthenticationState(context),
        ),
        tablet: Container(),
        desktop: Container()
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

  Widget getChatRooms(BuildContext context, UserProfileModel profile) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<List<types.Room>>(
              stream: facade.FirebaseChatCore.instance.rooms(orderByUpdatedAt: true, isArchived: false),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
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

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return noReservationsFound(
                      widget.model,
                      Icons.chat_outlined,
                      'No Chats Yet!',
                      'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                      'Open Archive',
                      didTapStartButton: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (_) {
                                return DirectChatArchiveRoomsScreen(
                                  model: widget.model,
                                );
                              }));
                        });
                    }
                  );
                }


                  return Container(
                    height: MediaQuery.of(context).size.height - 170,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final room = snapshot.data![index];

                          late List dateSlotsData = [];
                          if (room.metadata?['reservationSlot'] != null) {
                            dateSlotsData.addAll(room.metadata?['reservationSlot']);
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
                                        false,
                                        messageSnapshot.data ?? [],
                                        dates,
                                        didSelectRoom: (e) {
                                          setState(() {

                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (_) {
                                                  return DirectChatScreen(
                                                    model: widget.model,
                                                    room: e,
                                                    currentUser: profile,
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