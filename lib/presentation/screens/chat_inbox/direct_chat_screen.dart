import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_details_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_results_main.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_helper_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:reservation_post/inputs/input.dart' as post;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_facade/auth/notification_facade/notification_core_config.dart';

class DirectChatScreen extends StatefulWidget {

  final types.Room? room;
  final DashboardModel model;
  final UserProfileModel? currentUser;
  final ReservationItem? reservationItem;
  final bool isFromReservation;

  const DirectChatScreen({Key? key,
    required this.room,
    required this.model,
    required this.currentUser,
    required this.reservationItem,
    required this.isFromReservation}) : super(key: key);


  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {

  bool _isAttachmentUploading = false;

  final ImagePicker _imagePicker = ImagePicker();

  /// selected photos for post.
  late List<XFile> _selectedFileSpaceImage = [];

  /// see [Input.isImageVideoAttachmentUploading]
  late bool isImageVideoAttachmentUploading = false;

  /// see [Input.isCameraImageAttachmentUploading]
  late bool isCameraImageAttachmentUploading = false;

  /// see [Input.isAudioAttachmentUploading]
  late bool isAudioAttachmentUploading = false;

  /// messages
  List<types.Message> systemMessages = [];
  List<types.Message> messages = [];

  @override
  void initState() {
    systemMessages.clear();
    messages.clear();
    super.initState();
  }

  @override
  void dispose() {
    systemMessages.clear();
    messages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      if (ChatHelperCore.isLoading == true) {
        systemMessages.clear();
        messages.clear();
        return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: (!(kIsWeb)) ? AppBar(
              elevation: 0,
              backgroundColor: widget.model.paletteColor,
              title: Text(widget.room?.name ?? 'chat', style: TextStyle(color: widget.model.accentColor),
          ),
         centerTitle: true,
        ) : null,
        body: BlocProvider(create: (_) => getIt<NotificationWatcherBloc>()..add(NotificationWatcherEvent.watchAllAccountNotificationAmountByType([AccountNotificationType.message], widget.room != null ? UniqueId.fromUniqueString(widget.room!.id) : null)),
            child: BlocBuilder<NotificationWatcherBloc, NotificationWatcherState>(
                builder: (context, authState) {
                  return authState.maybeMap(
                      loadAllAccountNotificationByTypeSuccess: (item) {
                        return mainContainer(item.notifications);
                      },
                      orElse: () {
                        return mainContainer([]);
                }
              );
            }
          )
        )
      ),
    );
  }


  Widget mainContainer(List<AccountNotificationItem> notifications) {
    return (widget.room != null && widget.reservationItem == null) ? BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.room!.metadata?['reservationId'] ?? '')),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                  loadReservationItemFailure: (_) => retrieveMainChatContainer(
                    null,
                    widget.room!,
                    notifications
                  ),
                  loadReservationItemSuccess: (items) {
                    /// add system message
                    if (systemMessages.length != retrieveSystemMessages(items.item).length) {
                      systemMessages.addAll(retrieveSystemMessages(items.item));
                    }
                    return retrieveMainChatContainer(
                        items.item,
                        widget.room!,
                        notifications
                    );
                  },
                  orElse: () => retrieveMainChatContainer(
                      null,
                      widget.room!,
                      notifications
                  )
              );
            }
        )
    ) : (widget.reservationItem != null) ? StreamBuilder<List<types.Room>>(
      stream: facade.FirebaseChatCore.instance.roomsFromReservation(reservationId: widget.reservationItem!.reservationId.getOrCrash()),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.hasError || snapshot.data == null) {
          noItemsFound(
              widget.model,
              Icons.chat_outlined,
              'No Chats Yet!',
              'When You book a new reservation - a chat with just you and the listing owner will appear here.',
              'Go Back',
              didTapStartButton: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              }
          );
        }

        final room = snapshot.data?.first;

        if (room != null) {
          /// add system messages
          if (systemMessages.length != retrieveSystemMessages(widget.reservationItem!).length) {
            systemMessages.addAll(retrieveSystemMessages(widget.reservationItem!));
          }
          return retrieveMainChatContainer(
            widget.reservationItem,
            room,
            notifications
          );
        }

        return noItemsFound(
            widget.model,
            Icons.chat_outlined,
            'No Chats Yet!',
            'When You book a new reservation - a chat with just you and the listing owner will appear here.',
            'Go Back',
            didTapStartButton: () {
              setState(() {
                Navigator.of(context).pop();
              });
            }
        );

      },
    ) : noItemsFound(
        widget.model,
        Icons.chat_outlined,
        'No Chats Yet!',
        'When You book a new reservation - a chat with just you and the listing owner will appear here.',
        'Go Back',
        didTapStartButton: () {
          setState(() {
            Navigator.of(context).pop();
          });
        }
    );
  }


  Widget retrieveMainChatContainer(ReservationItem? reservation, types.Room selectedRoom, List<AccountNotificationItem> notifications) {

    return StreamBuilder<types.Room>(
        initialData: selectedRoom,
        stream: facade.FirebaseChatCore.instance.room(selectedRoom.id),
        builder: (context, snapshot) {
          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: facade.FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {

                for (types.Message message in snapshot.data ?? []) {
                  if (!(messages.map((e) => e.id).contains(message.id))) {
                    messages.add(message);
                  }
                }


              for (types.Message systemM in systemMessages) {
                  if (!(messages.map((e) => e.id).contains(systemM.id))) {
                    messages.add(systemM);
                }
              }

              messages = messages..sort((a,b) => (b.createdAt ?? DateTime.now().microsecondsSinceEpoch ~/ 1000).compareTo(a.createdAt ?? DateTime.now().microsecondsSinceEpoch ~/ 1000));


              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: (reservation != null) ? 30.0 : 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Chat(
                        timeFormat: DateFormat.jm(),
                        theme: DefaultChatTheme(
                          inputBackgroundColor: widget.model.accentColor,
                          inputTextCursorColor: widget.model.paletteColor,
                          inputTextColor: widget.model.paletteColor,
                          primaryColor: widget.model.paletteColor,
                        ),
                        showUserAvatars: true,
                        customBottomWidget: retrieveInputController(selectedRoom),
                        scrollToUnreadOptions: ScrollToUnreadOptions(
                            lastReadMessageId: (snapshot.data?.isNotEmpty ?? false) ? snapshot.data?.first.id ?? '' : '',
                            scrollOnOpen: true
                        ),
                        systemMessageBuilder: (sysMessage) {
                          return retrieveSystemMessageBuilder(sysMessage, context, widget.model);
                        },
                        onMessageVisibilityChanged: (message, visible) {
                          if (message.status != types.Status.seen && message.type != types.MessageType.system) {
                            _updateMessageStatusOnVisibilityChange(
                                message,
                                selectedRoom
                            );
                          }
                          /// update room notification
                          LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
                          e.reservationId?.getOrCrash() == selectedRoom.id).map((e) => e.notificationId).toList(),
                              widget.model.paletteColor,
                              widget.model.accentColor
                          );
                        },

                        isAttachmentUploading: _isAttachmentUploading,
                        messages: messages.toSet().toList(),
                        onSendPressed: (partialText) {
                          return _handleSendPressed(partialText, selectedRoom);
                        },
                        user: types.User(
                          id: facade.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                        ),
                      ),
                    ),
                  ),

                  if (reservation != null && widget.currentUser != null) Positioned(
                    top: 0,
                    child: getReservationCardListing(
                      context,
                      true,
                      reservation,
                      widget.currentUser!,
                      widget.model,
                      false,
                      false,
                      [],
                      didSelectResDetail: (model, listing, reservation, isResOwner, isFromChat, currentUser) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          return ReservationDetailsWidget(
                              model: model,
                              listing: listing,
                              reservationItem: reservation,
                              isReservationOwner: false,
                              allAttendees: [],
                              isFromChat: true,
                              currentUser: currentUser,
                            );
                          })
                        );
                      },
                      didSelectReservation: (listing, res, activity, attendeeItem, activityTickets) {
                        if (widget.isFromReservation) {
                          return Navigator.of(context).pop();
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (_) {
                                return ReservationResultMain(
                                  model: widget.model,
                                  isReply: false,
                                  listing: listing,
                                  currentUser: widget.currentUser,
                                  currentUserId: widget.currentUser!.userId.getOrCrash(),
                                  reservationId: reservation.reservationId.getOrCrash(),
                                );
                              }
                            )
                          );
                        }
                    }
                  )
                ),
              ],
            );
          },
        );
      }
    );
  }

  void _updateMessageStatusOnVisibilityChange(types.Message message, types.Room currentRoom) {
    if (message.author.id != facade.FirebaseChatCore.instance.firebaseUser?.uid) {
      final updatedMessage = message.copyWith(status: types.Status.seen);
      facade.FirebaseChatCore.instance.updateMessage(
        updatedMessage,
        currentRoom.id,
      );
    }
  }

  void _handleSendPressed(types.PartialText message, types.Room currentRoom) {
    facade.FirebaseChatCore.instance.sendMessage(
      message,
      currentRoom.id,
    );
    facade.FirebaseChatCore.instance.sendDirectNotifications(
        currentRoom.users.map((e) => e.id).toList(),
        message,
        currentRoom.id
    );
  }

  Widget retrieveInputController(types.Room currentRoom) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: post.Input(
        isAudioAttachmentUploading: isAudioAttachmentUploading,
        isCameraImageAttachmentUploading: isCameraImageAttachmentUploading,
        isImageVideoAttachmentUploading: isImageVideoAttachmentUploading,
        onSubmitPressed: (postText) async {
          _handleSendPressed(
            types.PartialText(
                text: postText.text,
            ),
            currentRoom
          );
        },
        onAttachmentPressed: (type) async {

        },
        isSubmitting: false,
        model: widget.model
      ),
    );
  }

  List<types.SystemMessage> retrieveSystemMessages(ReservationItem reservation) {
    List<types.SystemMessage> systemMessage = [];

    if (facade.FirebaseChatCore.instance.firebaseUser?.uid == reservation.reservationOwnerId.getOrCrash()) {
      for (ReservationSlotItem resSlot in reservation.reservationSlotItem) {
        for (ReservationTimeFeeSlotItem slot in resSlot.selectedSlots) {
          if (slot.slotRange.start.isBefore(DateTime.now())) {
            systemMessage.add(types.SystemMessage(
                id: UniqueId().getOrCrash(),
                createdAt: slot.slotRange.start.microsecondsSinceEpoch ~/ 1000,
                text: 'The ${DateFormat.jm().format(slot.slotRange
                    .start)} Reservation is about to begin, if you have any issues you can contact the owner here.'
              ));
            }
          }
        }
      }
    return systemMessage;
  }
}