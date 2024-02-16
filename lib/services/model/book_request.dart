// book_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BookRequest {
  final String reqBookID, reqBookOwnerID, requesterID;
  String? reqBookStatus;
  Timestamp? timestamp;

  BookRequest({
    required this.reqBookID,
    required this.reqBookOwnerID,
    this.reqBookStatus,
    this.timestamp,
    required this.requesterID,
  });

  factory BookRequest.fromMap(Map<String, dynamic> map) {
    return BookRequest(
        reqBookID: map['req_book_id'],
        reqBookOwnerID: map['req_book_owwner_id'],
        reqBookStatus: 'available',
        requesterID: map['reqeuster_id'],
        timestamp: Timestamp.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'req_book_id': reqBookID,
      'req_book_owwner_id': reqBookOwnerID,
      'req_book_status': reqBookStatus ?? 'available',
      'reqeuster_id': requesterID,
      'req_timestamp': Timestamp.now()
    };
  }
}
