// book_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BookRequestModel {
  final String reqBookID, reqBookOwnerID, requesterID;
  String? reqBookStatus;
  Timestamp? timestamp;

  BookRequestModel({
    required this.reqBookID,
    required this.reqBookOwnerID,
    this.reqBookStatus,
    this.timestamp,
    required this.requesterID,
  });

  factory BookRequestModel.fromMap(Map<String, dynamic> map) {
    return BookRequestModel(
        reqBookID: map['req_book_id'],
        reqBookOwnerID: map['req_book_owner_id'],
        reqBookStatus: 'available',
        requesterID: map['reqeuster_id'],
        timestamp: Timestamp.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'req_book_id': reqBookID,
      'req_book_owner_id': reqBookOwnerID,
      'req_book_status': reqBookStatus ?? 'available',
      'reqeuster_id': requesterID,
      'req_timestamp': Timestamp.now()
    };
  }
}
