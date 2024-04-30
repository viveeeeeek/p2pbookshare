// book_model.dart

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';

//TODO: Add all the required fields for book borrow request document
//FIXME: create a app constants and put all the field names there and use it from there so that we cdan easily change it later if needed
/// This model will be used for storing the request for borrowing the book
/// This request will be sent to the book owner.
/// The request will have the following fields:
/// 1. req_book_id: The ID of the book which is being requested
/// 2. req_book_owner_id: The ID of the owner of the book
/// 3. req_book_status: The status of the book request
/// 4. reqeuster_id: The ID of the user who is requesting the book
/// 5. req_timestamp: The timestamp of the request
/// 6. req_duration_in_days: The duration for which the book is requested
/// 7. req_start_date: The start date of the book request
/// 8. req_end_date: The end date of the book request
/// 9. req_status: The status of the book request
/// 10. req_status_timestamp: The timestamp of the status of the book request
/// 11. req_status_message: The message of the status of the book request
/// 12. req_status_updated_by: The ID of the user who updated the status of the book request

class BorrowRequest {
  final String reqBookID, reqBookOwnerID, requesterID;
  String? reqBookStatus, reqID, reqStatus;
  Timestamp? timestamp;
  Timestamp? reqStartDate, reqEndDate;

  BorrowRequest(
      {required this.reqBookID,
      required this.reqBookOwnerID,
      this.reqBookStatus,
      this.timestamp,
      this.reqID,
      this.reqStatus,
      required this.requesterID,
      this.reqStartDate,
      this.reqEndDate});

  factory BorrowRequest.fromMap(Map<String, dynamic> map) {
    return BorrowRequest(
        reqBookID: map[BorrowRequestConfig.reqBookID],
        reqBookOwnerID: map[BorrowRequestConfig.reqBookOwnerID],
        reqBookStatus: 'available',
        requesterID: map[BorrowRequestConfig.requesterID],
        timestamp: Timestamp.now(),
        // reqDurationInDays: map['req_duration_in_days'],
        reqStartDate: map[BorrowRequestConfig.reqStartDate],
        reqEndDate: map[BorrowRequestConfig.reqEndDate],
        reqStatus: map[BorrowRequestConfig.reqStatus] ?? 'pending',
        reqID: map[BorrowRequestConfig.reqID]);
  }

  Map<String, dynamic> toMap() {
    return {
      BorrowRequestConfig.reqBookID: reqBookID,
      BorrowRequestConfig.reqBookOwnerID: reqBookOwnerID,
      BorrowRequestConfig.reqBookStatus: reqBookStatus ?? 'available',
      BorrowRequestConfig.requesterID: requesterID,
      BorrowRequestConfig.timestamp: Timestamp.now(),
      BorrowRequestConfig.reqStartDate: reqStartDate,
      BorrowRequestConfig.reqEndDate: reqEndDate,
      BorrowRequestConfig.reqID: reqID,
      BorrowRequestConfig.reqStatus: reqStatus ?? 'pending',
    };
  }
}
