// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/chat_room.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view/chat/chat_view.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _chatService = context.read<ChatService>();
    final _currentUser = FirebaseAuth.instance.currentUser;
    final _userService = context.read<FirebaseUserService>();
    late UserModel _otherUserModel;
    var logger = Logger();

    /// Function to get the user details by user ID
    Future<UserModel> getUserDetails(String userID) async {
      final _user = await _userService.getUserDetailsById(userID);
      _otherUserModel = UserModel.fromMap(_user as Map<String, dynamic>);
      logger.d('UserModel: ${_otherUserModel.toMap()}');
      return UserModel.fromMap(_user);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),

      /// StreamBuilder to get all the chatrooms current user is part of
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(10.0),
              child: P2PBookShareShimmerContainer(
                height: 65, // provide a valid value for height
                width: double.infinity,
                borderRadius: 20,
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              // ListView.builder to build list of chatrooms current user is part of
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                /// Get chatroom details
                final _chatRoom = ChatRoom.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );

                logger.i('Chatroom: ${_chatRoom.toMap()}');

                // Get the other user's id
                final _otherUser = _chatRoom.userIds.firstWhere(
                  (element) => element != _currentUser!.uid,
                );
                final _messagesDoc = snapshot.data!.docs[index];
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _chatService.getMessagesStream(_messagesDoc),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData &&
                        snapshot.data!.isNotEmpty) {
                      List<Map<String, dynamic>> messages = snapshot.data!;
                      // Sorting the messages based on timestamp to get the most recent message
                      messages.sort(
                        (a, b) => b[MessageConfig.timestamp]
                            .compareTo(a[MessageConfig.timestamp]),
                      );
                      // Store the last message (most recent one after sorting)
                      String _lastMessage =
                          messages.first[MessageConfig.message];

                      return FutureBuilder<UserModel>(
                        future: getUserDetails(_otherUser),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserModel _otherUserModel = snapshot.data!;
                            return _buildChatroomListItemWidget(
                                context,
                                _otherUserModel,
                                _lastMessage,
                                _otherUser,
                                _chatRoom,
                                // _bookID
                                _chatRoom.bookId);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error fetching messages: ${snapshot.error}");
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching chatrooms'),
            );
          } else {
            return const Center(child: Text("No chats available"));
          }
        },
      ),
    );
  }

  /// Function to build the list item for each chatroom
  Widget _buildChatroomListItemWidget(
      BuildContext context,
      UserModel _otherUserModel,
      String lastMessage,
      String _otherUser,
      ChatRoom _chatRoom,
      String bookID) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: SizedBox(
              height: 50,
              width: 50,
              child: CachedImage(imageUrl: _otherUserModel.profilePictureUrl!),
            )),
        title: Text(_otherUserModel.displayName ?? ''),
        subtitle: Row(
          children: [
            // if (lastMessage['sender_id'] == _currentUser.uid)
            //   const Text('You: ')
            // else
            //   const Text(''),
            Expanded(
              child: Text(
                lastMessage,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        onTap: () {
          logger.d('Book Clicked: $bookID');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatView(
                receiverId: _otherUser,
                receiverName: _otherUserModel.displayName!,
                chatRoomId: _chatRoom.chatRoomId,
                receiverimgUrl: _otherUserModel.profilePictureUrl ??
                    'https://via.placeholder.com/150',
                bookId: bookID,
              ),
            ),
          );
        },
      ),
    );
  }
}
