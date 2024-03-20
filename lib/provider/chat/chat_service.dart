import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/model/chat_room.dart';
import 'package:p2pbookshare/model/message.dart';

class ChatService extends ChangeNotifier {
  // final ChatRepository _chatRepository = ChatRepository();
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  static createChatRoomId(String bookId, String userId, String otherUserId) {
    List<String> userIds = [bookId, userId, otherUserId];
    userIds.sort();
    return userIds.join("_");
  }

  /// SEND MESSAGE
  Future<void> sendMessage(
      {required String receiverId,
      required String message,
      required String chatRoomId}) async {
    // get current user
    final _currentUserId = _firebaseAuth.currentUser!.uid;
    final timestamp = Timestamp.now();

    String senderId = _currentUserId;

    /// create a new message
    Message newMessage = Message(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  /// GET MESSAGES
  Stream<QuerySnapshot> getMessages(
      {required String userId,
      required String otherUserId,
      required String chatRoomId}) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> initializeChatRoom({required ChatRoom newChatRoom}) async {
    logger.info('${newChatRoom.toMap().toString()}');
    try {
      await _firestore.collection('chatrooms').doc(newChatRoom.chatRoomId).set(
            newChatRoom.toMap(),
            SetOptions(merge: true),
          );
      logger.info(
          '✅ Chatroom initialized & document updated with bookid, borrowreqid, userLists fields');
    } catch (e) {
      logger.warning('❌ Error initializing chatroom: $e');
      throw e;
    }
  }
}

// get all messages from chatroom

// get all chatrooms of current user

// get all messages from chatroom

/// get all chatrooms of current user from firestore
/// returns a stream of QuerySnapshot
/// QuerySnapshot contains a list of chatrooms
/// each chatroom contains a list of messages
// Stream<QuerySnapshot> getChatRooms() {
//   final _currentUserId = _firebaseAuth.currentUser!.uid;
//   return _firestore
//       .collection('chatrooms')
//       .where('userIds', arrayContains: _currentUserId)
//       .snapshots();
// }

// get all messages from chatroom
