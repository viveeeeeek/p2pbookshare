import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/book_request.dart';
import 'package:simple_logger/simple_logger.dart';

class BookRequestService with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  final logger = SimpleLogger();

  Future<bool> checkIfRequestAlreadyMade(BookRequest bookRequest) async {
    try {
      var bookRequestsCollection =
          FirebaseFirestore.instance.collection('book_requests');

      // Query to check if a request exists for the current user and book
      //TODO  req_book_owner spelling fix in irebase colection
      //TODO if book req is made check its status and according to te status show borrowbutton or borrowedbookstatus screen
      var querySnapshot = await bookRequestsCollection
          .where('req_book_id', isEqualTo: bookRequest.reqBookID)
          .where('req_book_owwner_id', isEqualTo: bookRequest.reqBookOwnerID)
          .where('reqeuster_id', isEqualTo: bookRequest.requesterID)
          .get();

      return querySnapshot.docs.isNotEmpty; // Return true if request exists
    } catch (e) {
      logger.warning('Error checking existing request: $e');
      return false; // Return false if an error occurs
    }
  }

  void sendBookBorrowRequest(BookRequest bookRequest) async {
    try {
      bool requestExists = await checkIfRequestAlreadyMade(bookRequest);

      if (requestExists) {
        logger.info('❌Request already made'); // Print message if request exists
      } else {
        var bookRequestsCollection =
            FirebaseFirestore.instance.collection('book_requests');
        Map<String, dynamic> bookRequestsData = bookRequest.toMap();
        await bookRequestsCollection.add(bookRequestsData);
        logger.info("✅ Book request created");
      }
    } catch (e) {
      logger.warning('Error creating book request to Firestore: $e');
    }
  }
}
