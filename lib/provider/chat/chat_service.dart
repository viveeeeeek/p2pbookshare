// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
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
        .orderBy(MessageConfig.timestamp, descending: true)
        .snapshots();
  }

  Future<void> initializeChatRoom({required ChatRoom newChatRoom}) async {
    logger.i('${newChatRoom.toMap().toString()}');
    try {
      await _firestore.collection('chatrooms').doc(newChatRoom.chatRoomId).set(
            newChatRoom.toMap(),
            SetOptions(merge: true),
          );
      logger.i(
          '✅ Chatroom initialized & document updated with bookid, borrowreqid, userLists fields');
    } catch (e) {
      logger.e('❌ Error initializing chatroom: $e');
      throw e;
    }
  }

  /// get all chatrooms of current user from firestore
  /// returns a stream of QuerySnapshot
  /// QuerySnapshot contains a list of chatrooms
  /// each chatroom contains a list of messages
  Stream<QuerySnapshot> getChatRooms() {
    final _currentUserId = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection('chatrooms')
        .where(ChatRoomConfig.userIds, arrayContains: _currentUserId)
        .snapshots();
  }

  /// This method is used in the home view to display the book requests notification card
  Stream<bool> hasChatroomForUser(String collectionPath, String userId) {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    return collectionRef
        .where(ChatRoomConfig.userIds, arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Function to get the stream of messages for a chatroom
  Stream<List<Map<String, dynamic>>> getMessagesStream(DocumentSnapshot doc) {
    final messagesCollection = doc.reference.collection('messages');
    return messagesCollection
        .orderBy(MessageConfig.timestamp, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// delete chatroom based on chatroom id
  Future<void> deleteChatRoom(String chatRoomId) async {
    try {
      // Delete subcollections inside chatroom document
      final messagesCollection = _firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages');
      final messagesQuery = await messagesCollection.get();
      for (var doc in messagesQuery.docs) {
        await doc.reference.delete();
      }

      // Delete chatroom document
      await _firestore.collection('chatrooms').doc(chatRoomId).delete();
      logger.i("✅✅Chatroom deleted");
    } catch (e) {
      logger.e('❌ Error deleting chatroom: $e');
      throw e;
    }
  }
}
