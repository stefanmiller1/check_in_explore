import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class NotificationCore {


  static Future<List<types.Message>> didCheckNotificationsForMessages() async {

    List<types.Message> chatReceivedNotification = [];

    facade.FirebaseChatCore.instance.rooms(isArchived: true).listen((event) {
          for (types.Room room in event) {
              facade.FirebaseChatCore.instance.messages(room, limit: 1).listen((eventMessage) {

                // print('is not author?');
                // print((event.map((e) => e.author.id).contains(facade.FirebaseChatCore.instance.firebaseUser?.uid)));
                // print('is status delivered?');
                // print(event.map((e) => e.status).contains(types.Status.delivered));

                if (eventMessage.isNotEmpty) {
                  if (!(eventMessage.map((e) => e.author.id).contains(facade.FirebaseChatCore.instance.firebaseUser?.uid)) && eventMessage.map((e) => e.status).contains(types.Status.delivered)) {
                      return chatReceivedNotification.add(eventMessage.first);
                  }
               }
           });
        }
    });


print(chatReceivedNotification);
    return chatReceivedNotification;
  }
}