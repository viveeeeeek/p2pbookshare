// book_model.dart
//TODO: Add bookreq start & end dates and based on that we can calculate no of  days later
import 'package:cloud_firestore/cloud_firestore.dart';

class BookRequestModel {
  final String reqBookID, reqBookOwnerID, requesterID;
  String? reqBookStatus;
  Timestamp? timestamp;
  // int? reqDurationInDays;
  Timestamp? reqStartDate, reqEndDate;

  BookRequestModel(
      {required this.reqBookID,
      required this.reqBookOwnerID,
      this.reqBookStatus,
      this.timestamp,
      required this.requesterID,
      // this.reqDurationInDays,
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
      // /// By default book exchagnge is for 2 days
      // 'req_duration_in_days': reqDurationInDays ?? 2
    };
  }
}
