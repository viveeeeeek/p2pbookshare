// Model for chatroom document

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';

class ChatRoom {
  final List<String> userIds;
  final String bookId;
  final String bookBorrowRequestId;
  final String chatRoomId;

  ChatRoom(
      {required this.userIds,
      required this.bookId,
      required this.chatRoomId,
      required this.bookBorrowRequestId});

  // Method to convert a ChatRoom to a Map
  Map<String, dynamic> toMap() {
    return {
      ChatroomConfig.userIds: userIds,
      ChatroomConfig.bookId: bookId,
      ChatroomConfig.chatRoomId: chatRoomId,
      ChatroomConfig.bookBorrowRequestId: bookBorrowRequestId,
    };
  }

  // Method to convert a Map to a ChatRoom
  static ChatRoom fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      userIds: List<String>.from(map[ChatroomConfig.userIds]),
      bookId: map[ChatroomConfig.bookId],
      chatRoomId: map[ChatroomConfig.chatRoomId],
      bookBorrowRequestId: map[ChatroomConfig.bookBorrowRequestId],
    );
  }
}
