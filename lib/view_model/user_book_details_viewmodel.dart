import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/utils/app_utils.dart';
import 'package:p2pbookshare/model/chat_room.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/provider/firebase/book_listing_service.dart';

class UserBookDetailsViewModel {
  // late final bookRequestHandlingService;

  /// Accept the incoming book request
  acceptIncomingBookRequest(BuildContext context, ChatRoom chatRoom) async {
    final _bookRequestHandlingService = BookRequestService();
    final _chatService = ChatService();
    // Initializes the chat room with unique chat room id
    _chatService.initializeChatRoom(newChatRoom: chatRoom);
    // Changes book availability to false and updates the request status to accepted
    _bookRequestHandlingService.acceptBookBorrowRequest(
        chatRoom.bookBorrowRequestId, chatRoom.bookId);

    //FIXME: Alert dialogue not closing after confirmation
    /**
     await Utils.alertDialog(
      context: context,
      title: 'Accept request',
      description:
          'Are you sure you want to accept this request? This will automatically reject all other requests for this book.',
      onConfirm: () async {
        await bookRequestHandlingService.acceptBookBorrowRequest(
            bookRequestID, bookID);
      },
      actionText: 'Yes',
      cancelButton: true,
    );
    // Dismiss the dialog immediately after the user confirms
    if (context.mounted) {
      logger.info('Context is not available alert didnt exit');
      Navigator.pop(context);
    }
 */
  }

  /// Reject the incoming book request
  rejectIncomingBookRequest(BuildContext context, String bookRequestID) async {
    final bookRequestHandlingService =
        Provider.of<BookRequestService>(context, listen: false);
    await bookRequestHandlingService.deleteBookBorrowRequest(bookRequestID);
    if (context.mounted)
      Utils.snackBar(
          context: context,
          message: 'Request declined successfully',
          actionLabel: 'Ok',
          durationInSecond: 2);
    logger.i(
        '💡💥rejectIncomingBookRequest accessed: Request declined successfully');
  }

  /// Delete book listing from the database
  deleteBookListing(
      BuildContext context, String bookID, String bookCoverImgUrl) async {
    final bookRequestHandlingService =
        Provider.of<BookRequestService>(context, listen: false);
    final bookListingService =
        Provider.of<BookListingService>(context, listen: false);
    final _requestExists =
        await bookRequestHandlingService.requestExists(bookID);
    if (_requestExists) {
      if (context.mounted)
        Utils.snackBar(
            context: context,
            message: 'Request exists for this book',
            actionLabel: 'Ok',
            durationInSecond: 2,
            onPressed: () {});
    } else {
      await bookListingService.deleteBookListing(bookID, bookCoverImgUrl);
      if (context.mounted) {
        Utils.snackBar(
            context: context,
            message: 'Deleted Book Successfully',
            actionLabel: 'Ok',
            durationInSecond: 1,
            onPressed: () {});
        await Future.delayed(
            const Duration(seconds: 1)); // Wait for snackbar to finish
        if (context.mounted) Navigator.pop(context);
      }
    }
  }

  /// complete book exchange
  /// delete chatroom
  /// change book borrow request status to completed
  /// change book availibility status of book
  completeBookExchange({
    required BuildContext context,
    required String chatRoomID,
    required String bookID,
    required String bookRequestID,
  }) async {
    final _bookRequestHandlingService = BookRequestService();
    final _chatService = ChatService();
    // Deletes the chat room
    _chatService.deleteChatRoom(chatRoomID);
    // Changes the book borrow request status to completed
    _bookRequestHandlingService.completeBookBorrowRequest(
        bookRequestID, bookID);

    if (context.mounted)
      Utils.snackBar(
          context: context,
          message: 'Book exchange completed successfully',
          actionLabel: 'Ok',
          durationInSecond: 2);
    logger.i(
        '💡💥completeBookExchange accessed: Book exchange completed successfully');
  }
}
