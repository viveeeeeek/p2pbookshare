// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/enums.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/services/chat/chat_service.dart';
import 'package:p2pbookshare/services/fcm/access_token_firebase.dart';
import 'package:p2pbookshare/services/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';
import 'package:p2pbookshare/services/fcm/notification_service.dart';
import 'package:p2pbookshare/view/chat/border_radius.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.chatRoomId,
    required this.receiverimgUrl,
    required this.bookId,
  }) : super(key: key);
  final String receiverId;
  final String chatRoomId;
  final String receiverName;
  final String receiverimgUrl;
  final String bookId;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _chatService = ChatService();
  final _firebaseAuth = FirebaseAuth.instance;
  final _bookFetchService = BookFetchService();
  User _currentUser = FirebaseAuth.instance.currentUser!;

  NotificationService _notificationService = NotificationService();
  var logger = Logger();

  @override
  void initState() {
    super.initState();

    _messageController.addListener(() {
      if (_messageController.text.length > 0) {
        TextInput.finishAutofillContext();
      }
    });
  }

  void sendChatNotification(String message) async {
    final accessToken = await AccessTokenFirebase().getAccessToken();
    final targetDeviceToken =
        await FirebaseUserService().getUserDeviceToken(widget.receiverId);
    if (targetDeviceToken != '' ||
        targetDeviceToken != null && accessToken != '') {
      _notificationService.sendChatNotification(
          _currentUser.displayName!,
          message,
          accessToken,
          targetDeviceToken!,
          widget.chatRoomId,
          _currentUser.uid,
          _currentUser.displayName!,
          _currentUser.photoURL!,
          widget.bookId);
      logger.i('Notification sent');
    } else {
      logger.i('Device token is empty');
    }
  }

  void handleOnSubmit() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatService.sendMessage(
        receiverId: widget.receiverId,
        message: message,
        chatRoomId: widget.chatRoomId,
      );

      sendChatNotification(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Book ID : ${widget.bookId}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        titleTextStyle: const TextStyle(fontSize: 18),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.network(
                  widget.receiverimgUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverName,
                    style: TextStyle(color: context.onSurface),
                  ),
                  FutureBuilder(
                      future:
                          _bookFetchService.getBookDetailsById(widget.bookId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Book book = Book.fromMap(
                              snapshot.data as Map<String, dynamic>);
                          return Text(
                            book.bookTitle,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          );
                        } else {
                          return const P2PBookShareShimmerContainer(
                              height: 10, width: 200, borderRadius: 2);
                        }
                      })
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<ChatMenuValues>(
            // offset: const Offset(0, 60),
            // constraints: BoxConstraints.tight(const Size(200, 225)),
            icon: Icon(MdiIcons.dotsVertical),
            onSelected: (value) {
              // Handle your menu selection here

              switch (value) {
                case ChatMenuValues.HELP:
                  // Handle report action
                  logger.d('Help clicked');
                  break;
                case ChatMenuValues.FEEDBACK:
                  // Handle report action
                  break;
                case ChatMenuValues.REPORT:
                  // Handle block action
                  break;
                // Add more cases if you have more menu items
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: ChatMenuValues.HELP,
                child: Text(
                  'Help',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const PopupMenuItem(
                value: ChatMenuValues.FEEDBACK,
                child: Text(
                  'Feedback',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const PopupMenuItem(
                value: ChatMenuValues.REPORT,
                child: Text(
                  'Block and report spam',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              // Add more items if you have more menu items
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessagesList(
                  _firebaseAuth.currentUser!.uid, widget.receiverId)),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    // autofocus: true,
                    maxLines:
                        1, // Set the maximum number of lines for the TextField to 1
                    textCapitalization: TextCapitalization.sentences,
                    enabled: true,

                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      fillColor: context.surfaceVariant.withValues(alpha: 0.7),
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(MdiIcons.camera),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: handleOnSubmit,
                  icon: Icon(MdiIcons.sendOutline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// This method builds the list of messages
  Widget _buildMessagesList(String userId, String otherUserId) {
    return StreamBuilder(
        stream: _chatService.getMessages(
            userId: userId,
            otherUserId: otherUserId,
            chatRoomId: widget.chatRoomId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  var prevDocument =
                      index > 0 ? snapshot.data!.docs[index - 1] : null;
                  var nextDocument = index < snapshot.data!.docs.length - 1
                      ? snapshot.data!.docs[index + 1]
                      : null;
                  return _buildMessageItem(
                      document, prevDocument, nextDocument);
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: context.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Transform.scale(
                      scale: 0.99, // Adjust the scale factor as needed
                      child: SvgPicture.asset(
                        // 'assets/thinking-young-man.svg',
                        'assets/images/girl.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Start chatting now...',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              );
            }
          }
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: P2PBookShareShimmerContainer(
                height: 200, width: double.infinity, borderRadius: 25),
          );
        });
  }

  /// This method builds the message item
  Widget _buildMessageItem(DocumentSnapshot document,
      DocumentSnapshot? prevDocument, DocumentSnapshot? nextDocument) {
    Map<String, dynamic> message = document.data() as Map<String, dynamic>;
    Map<String, dynamic>? prevMessage = prevDocument != null
        ? prevDocument.data() as Map<String, dynamic>
        : null;
    Map<String, dynamic>? nextMessage = nextDocument != null
        ? nextDocument.data() as Map<String, dynamic>
        : null;

    // var align message to right if the sender is the current user else align to left
    var alignment =
        (message[MessageConfig.senderId] == _firebaseAuth.currentUser!.uid)
            ? Alignment.centerRight
            : Alignment.centerLeft;
    var messageCBubbleColor =
        (message[MessageConfig.senderId] == _firebaseAuth.currentUser!.uid)
            ? context.onPrimaryContainer
            : context.surfaceVariant;
    var messageColor =
        (message[MessageConfig.senderId] == _firebaseAuth.currentUser!.uid)
            ? context.onSecondary
            : context.onSurface;

    var isSameUserAsPrev = prevMessage != null &&
        message[MessageConfig.senderId] == prevMessage[MessageConfig.senderId];
    var isSameUserAsNext = nextMessage != null &&
        message[MessageConfig.senderId] == nextMessage[MessageConfig.senderId];
    var isCurrentUser =
        message[MessageConfig.senderId] == _firebaseAuth.currentUser!.uid;

    var bubbleBorderRadius = isCurrentUser
        ? (isSameUserAsPrev || isSameUserAsNext)
            ? getBorderRadiusForCurrentUser(isSameUserAsPrev, isSameUserAsNext)
            : BorderRadius.circular(22.0)
        : (isSameUserAsPrev || isSameUserAsNext)
            ? getBorderRadiusForOtherUser(isSameUserAsPrev, isSameUserAsNext)
            : BorderRadius.circular(22.0);

    var bubblePadding = isCurrentUser
        ? (isSameUserAsPrev || isSameUserAsNext)
            ? getPaddingForCurrentUser(isSameUserAsPrev, isSameUserAsNext)
            // : const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0)
            : const EdgeInsets.fromLTRB(14, 20, 14, 20)
        : (isSameUserAsPrev || isSameUserAsNext)
            ? getPaddingForOtherUser(isSameUserAsPrev, isSameUserAsNext)
            // : const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0);
            : const EdgeInsets.fromLTRB(14, 20, 14, 0);

    return Container(
      padding: bubblePadding,
      // margin: bubbleMargin,
      alignment: alignment,
      child: Container(
        // This padding is same as wrappng below child widget with
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
            color: messageCBubbleColor,
            borderRadius: bubbleBorderRadius,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.0),
                  blurRadius: 5,
                  spreadRadius: 2)
            ]),
        child: Text(
          message['message'],
          style: TextStyle(color: messageColor, fontSize: 16),
          // textAlign: textAlignment,
        ),
      ),
    );
  }
}
