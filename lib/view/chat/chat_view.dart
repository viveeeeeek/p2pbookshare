import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/enums.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/view/chat/border_radius.dart';

class ChatView extends StatefulWidget {
  const ChatView(
      {Key? key,
      required this.receiverId,
      required this.receiverName,
      required this.chatRoomId,
      required this.receiverimgUrl})
      : super(key: key);
  final String receiverId;
  final String chatRoomId;
  final String receiverName;
  final String receiverimgUrl;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _chatService = ChatService();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      if (_messageController.text.length > 0) {
        TextInput.finishAutofillContext();
      }
    });
  }

  void sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatService.sendMessage(
        receiverId: widget.receiverId,
        message: message,
        chatRoomId: widget.chatRoomId,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                widget.receiverName,
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
                  logger.info('Help clicked');
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
                      fillColor: context.surfaceVariant.withOpacity(0.7),
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
                  onPressed: sendMessage,
                  icon: Icon(MdiIcons.sendOutline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                      color: context.secondary.withOpacity(0.2),
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

                  /// transparent container with circular border of red colour
                  /// to show the user that the chat is empty
                  /// and to give a visual cue to the user
                  // Container(
                  //   height: 100,
                  //   width: 275,
                  //   decoration: BoxDecoration(
                  //     color: Colors.transparent,
                  //     borderRadius: BorderRadius.circular(20.0),
                  //     border: Border.all(
                  //       color: context.secondary.withOpacity(0.5),
                  //       width: 2,
                  //     ),
                  //   ),
                  //   child: const Center(
                  //     child: Expanded(
                  //       child: Text(
                  //         'You can chat with the user now and discuss about the book exchange.',
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
    var alignment = (message['sender_id'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var messageCBubbleColor =
        (message['sender_id'] == _firebaseAuth.currentUser!.uid)
            ? context.onPrimaryContainer
            : context.surfaceVariant;
    var messageColor = (message['sender_id'] == _firebaseAuth.currentUser!.uid)
        ? context.onSecondary
        : context.onSurface;

    var isSameUserAsPrev =
        prevMessage != null && message['sender_id'] == prevMessage['sender_id'];
    var isSameUserAsNext =
        nextMessage != null && message['sender_id'] == nextMessage['sender_id'];
    var isCurrentUser = message['sender_id'] == _firebaseAuth.currentUser!.uid;

    var bubbleBorderRadius = isCurrentUser
        ? (isSameUserAsPrev || isSameUserAsNext)
            ? getBorderRadiusForCurrentUser(isSameUserAsPrev, isSameUserAsNext)
            : BorderRadius.circular(22.0)
        : (isSameUserAsPrev || isSameUserAsNext)
            ? getBorderRadiusForOtherUser(isSameUserAsPrev, isSameUserAsNext)
            : BorderRadius.circular(22.0);

    // var bubbleMargin = isCurrentUser
    //     ? isSameUserAsPrev || isSameUserAsNext
    //         ? const EdgeInsets.symmetric(vertical: .0, horizontal: 0.0)
    //         : const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0)
    //     : const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0);

    var bubblePadding = isCurrentUser
        ? (isSameUserAsPrev || isSameUserAsNext)
            ? getPaddingForCurrentUser(isSameUserAsPrev, isSameUserAsNext)
            // : const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0)
            : const EdgeInsets.fromLTRB(20, 20, 20, 20)
        : (isSameUserAsPrev || isSameUserAsNext)
            ? getPaddingForOtherUser(isSameUserAsPrev, isSameUserAsNext)
            // : const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0);
            : const EdgeInsets.fromLTRB(20, 20, 20, 0);

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
                  color: Colors.black.withOpacity(0.0),
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

// Textfield v2.0
/*
  Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    // autofocus: true,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      fillColor: context.surfaceVariant.withOpacity(0.7),
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: sendMessage,
                        icon: Icon(MdiIcons.sendOutline),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                    ),
                  ),
                ),
 */
