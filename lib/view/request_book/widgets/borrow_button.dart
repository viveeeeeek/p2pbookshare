// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

// Project imports:
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/view/outgoing_req/outgoing_req_details_view.dart';

class BorrowButton extends StatelessWidget {
  const BorrowButton(
      {super.key,
      required this.bookData,
      required this.currentUserUid,
      required this.onPressed,
      required this.bookRequestServices});
  final Function() onPressed;
  final Book bookData;
  final String currentUserUid;
  final BookRequestService bookRequestServices;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookRequestService>(
      builder: (context, bookBorrowRequestService, child) {
        return Center(
          child: StreamBuilder<Tuple2<bool, Map<String, dynamic>>>(
            // rxdart package is used to combine two streams into one.
            // The first stream checks if the book is available
            // The second stream checks if the user has made a request for the book
            // The result of the two streams is a tuple of two values
            // The first value is a boolean indicating if the book is available
            // The second value is a map containing the request data if the user has made a request
            stream: Rx.combineLatest2<bool, Map<String, dynamic>,
                Tuple2<bool, Map<String, dynamic>>>(
              bookBorrowRequestService.checkBookAvailability(bookData.bookID!),
              bookBorrowRequestService.getBookRequestStatus(
                  BorrowRequest(
                      reqBookID: bookData.bookID!,
                      reqBookOwnerID: bookData.bookOwnerID,
                      requesterID: currentUserUid),
                  currentUserUid),
              (bookAvailable, bookRequestStatus) =>
                  Tuple2(bookAvailable, bookRequestStatus),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  bool isBookAvailable = snapshot.data!.item1;
                  Map<String, dynamic> bookBorrowRequestData =
                      snapshot.data!.item2;

                  if (bookBorrowRequestData.isNotEmpty) {
                    String status = bookBorrowRequestData['req_status'];
                    return SizedBox(
                      height: 60,
                      width: 356,
                      child: FilledButton.tonalIcon(
                          onPressed: () => navigateToOutgoingReqDetailsView(
                              bookData: bookData,
                              currentUserUid: currentUserUid,
                              bookRequestData: bookBorrowRequestData,
                              context: context),
                          icon: status == 'pending'
                              ? Icon(MdiIcons.loading)
                              : Icon(MdiIcons.check),
                          label: Text('Status: $status')),
                    );
                  } else if (isBookAvailable) {
                    // User has not made a request and the book is available to borrow
                    return buildBorrowButton(
                      context: context,
                      onPressed: onPressed,
                      height: 60,
                      width: 356,
                    );
                  } else {
                    // User has not made a request and the book is not available,
                    return const SizedBox(
                      height: 60,
                      width: 356,
                      child: FilledButton.tonal(
                          onPressed: null, child: Text('Book not available')),
                    );
                  }
                } else {
                  return const Text('Error retrieving data');
                }
              } else {
                return const P2PBookShareShimmerContainer(
                    height: 60, width: 356, borderRadius: 25);
              }
            },
          ),
        );
      },
    );
  }
}

Widget buildBorrowButton(
    {required BuildContext context,
    required Function() onPressed,
    required double height,
    required double width}) {
  return SizedBox(
    height: height,
    width: width,
    child: FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(MdiIcons.handshakeOutline),
          const SizedBox(width: 8),
          const Text('Borrow', style: TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}

/**
 
       
 */

navigateToOutgoingReqDetailsView(
    {required BuildContext context,
    required Book? bookData,
    required String? currentUserUid,
    required Map<String, dynamic> bookRequestData}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OutgoingReqDetailsView(
        bookrequestModel: BorrowRequest(
          reqBookID: bookRequestData['req_book_id'],
          reqBookOwnerID: bookRequestData['req_book_owner_id'],
          requesterID: bookRequestData['requester_id'],
          reqBookStatus: bookRequestData['req_book_status'],
          reqEndDate: bookRequestData['req_end_date'],
          reqStartDate: bookRequestData['req_start_date'],
          reqID: bookRequestData['req_id'],
          reqStatus: bookRequestData['req_status'],
          timestamp: bookRequestData['req_timestamp'],
        ),
      ),
    ),
  );
}
