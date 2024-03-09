// book_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
//FIXME: Spelling mistake in the parameter name [reqeuster_id]
//TODO: Add all the required fields for book borrow request document
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

class BookRequestModel {
  final String reqBookID, reqBookOwnerID, requesterID;
  String? reqBookStatus;
  Timestamp? timestamp;
  Timestamp? reqStartDate, reqEndDate;

  BookRequestModel(
      {required this.reqBookID,
      required this.reqBookOwnerID,
      this.reqBookStatus,
      this.timestamp,
      required this.requesterID,
      this.reqStartDate,
      this.reqEndDate});

  factory BookRequestModel.fromMap(Map<String, dynamic> map) {
    return BookRequestModel(
        reqBookID: map['req_book_id'],
        reqBookOwnerID: map['req_book_owner_id'],
        reqBookStatus: 'available',
        requesterID: map['reqeuster_id'],
        timestamp: Timestamp.now(),
        // reqDurationInDays: map['req_duration_in_days'],
        reqStartDate: map['req_start_date'],
        reqEndDate: map['req_end_date']);
  }

  Map<String, dynamic> toMap() {
    return {
      'req_book_id': reqBookID,
      'req_book_owner_id': reqBookOwnerID,
      'req_book_status': reqBookStatus ?? 'available',
      'reqeuster_id': requesterID,
      'req_timestamp': Timestamp.now(),
      'req_start_date': reqStartDate,
      'req_end_date': reqEndDate
    };
  }
}
