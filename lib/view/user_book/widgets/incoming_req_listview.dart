// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/no_requests_widget.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/chat_room.dart';
import 'package:p2pbookshare/services/chat/chat_service.dart';
import 'package:p2pbookshare/services/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/view/user_book/user_book_details_view.dart';
import 'package:p2pbookshare/view/user_book/widgets/incoming_req_card.dart';
import 'package:p2pbookshare/view_model/user_book_details_viewmodel.dart';

/// Widget to build the incoming book borrow request listview
class IncomingReqListView extends StatelessWidget {
  const IncomingReqListView({
    required this.bookRequestService,
    super.key,
    required this.widget,
    required String receiverName,
    required UserBookDetailsViewModel userBookDetailsViewModel,
  })  : _receiverName = receiverName,
        _userBookDetailsViewModel = userBookDetailsViewModel;
  final BookRequestService bookRequestService;

  final UserBookDetailsView widget;
  final String _receiverName;
  final UserBookDetailsViewModel _userBookDetailsViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: StreamBuilder(
          stream:
              bookRequestService.fetchRequestsForBook(widget.bookData.bookID!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const P2PBookShareShimmerContainer(
                  height: 150, width: double.infinity, borderRadius: 15);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const NoRequestsWidget();
            } else if (snapshot.hasData && snapshot.data != null) {
              final bookRequestData = snapshot.data!;

              Future<ChatRoom> getReceiverIdAndChatRoomId(
                  Map<String, dynamic> bookData) async {
                String currentUserId = FirebaseAuth.instance.currentUser!.uid;
                String bookId = bookData[BorrowRequestConfig.reqBookID];
                String receiverId;
                if (currentUserId == widget.bookData.bookOwnerID) {
                  receiverId = bookData[BorrowRequestConfig.requesterID];
                } else {
                  receiverId = bookData[BorrowRequestConfig.reqBookOwnerID];
                }
                String chatRoomId = ChatService.createChatRoomId(
                    bookId, currentUserId, receiverId);
                logger.i(
                    '⚙️🔨Chat room id: $chatRoomId, receiverId: $receiverId, receiverName: $_receiverName, currentUserId: $currentUserId');
                return ChatRoom(
                  userIds: [currentUserId, receiverId],
                  bookId: widget.bookData.bookID!,
                  chatRoomId: chatRoomId,
                  bookBorrowRequestId: bookData[BorrowRequestConfig.reqID],
                );
              }

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: bookRequestData.length,
                itemBuilder: (context, index) {
                  final requestData = bookRequestData[index];
                  return FutureBuilder<ChatRoom>(
                    future: getReceiverIdAndChatRoomId(requestData),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        ChatRoom chatRoom = snapshot.data!;
                        return incomingRequestCard(
                          context: context,
                          bookRequestData: requestData,
                          onAccept: () => _userBookDetailsViewModel
                              .acceptIncomingBookRequest(context, chatRoom),
                          onDecline: () => _userBookDetailsViewModel
                              .rejectIncomingBookRequest(context,
                                  requestData[BorrowRequestConfig.reqID]),
                        );
                      } else {
                        // Show a loading indicator while the ChatRoom is being created
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        )),
      ],
    );
  }
}
