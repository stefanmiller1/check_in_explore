import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatHelperCore {

  static types.Room? selectedRoom;
  static UserProfileModel? currentUserProfile;
  static bool isLoading = false;
  static int currentPageIndex = 0;

}