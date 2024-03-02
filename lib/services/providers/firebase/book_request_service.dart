import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/book_request.dart';
import 'package:simple_logger/simple_logger.dart';

class BookRequestService with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  final logger = SimpleLogger();

  bool _bookRequestExists = false;
  bool get bookRequestExists => _bookRequestExists;

  bool _isRequestsAvailableForBook = false;
  bool get isRequestsAvailableForBook => _isRequestsAvailableForBook;

  Future<bool> checkIfRequestAlreadyMade(BookRequestModel bookRequest) async {
    try {
      var bookRequestsCollection =
          FirebaseFirestore.instance.collection('book_requests');

      // Query to check if a request exists for the current user and book
      var querySnapshot = await bookRequestsCollection
          .where('req_book_id', isEqualTo: bookRequest.reqBookID)
          .where('req_book_owner_id', isEqualTo: bookRequest.reqBookOwnerID)
          .where('reqeuster_id', isEqualTo: bookRequest.requesterID)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        _bookRequestExists = true;
        return true;
      } else {
        _bookRequestExists = false;
        return false;
      }
    } catch (e) {
      logger.warning('Error checking existing request: $e');
      _bookRequestExists = false;
      notifyListeners();
      return false; // Return false if an error occurs
    }
  }

  sendBookBorrowRequest(BookRequestModel bookRequest) async {
    try {
      bool requestExists = await checkIfRequestAlreadyMade(bookRequest);

      if (requestExists) {
        logger.info('❌Request already made'); // Print message if request exists
        _bookRequestExists = true;
        notifyListeners();
      } else {
        var bookRequestsCollection =
            FirebaseFirestore.instance.collection('book_requests');
        Map<String, dynamic> bookRequestsData = bookRequest.toMap();
        await bookRequestsCollection.add(bookRequestsData);
        logger.info("✅ Book request created");
        _bookRequestExists = true;
        notifyListeners();
      }
    } catch (e) {
      logger.warning('Error creating book request to Firestore: $e');
    }
  }

  /// Stream to fetch all the incoming book requests to the user.
  Stream<List<Map<String, dynamic>>> fetchIncomingBookRequests() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Stream.value([]);
    } else {
      try {
        CollectionReference bookRequestCollection =
            FirebaseFirestore.instance.collection('book_requests');

        Query query = bookRequestCollection.where('req_book_owner_id',
            isEqualTo: currentUser.uid);
        return query.snapshots().map((querySnapshot) {
          if (querySnapshot.docs.isEmpty) {
            return [];
          }
          return querySnapshot.docs
              .map((document) => document.data() as Map<String, dynamic>)
              .toList();
        });
      } catch (e) {
        logger.info('Error retrieving book requests from Firestore: $e');
        return Stream.value([]);
      }
    }
  }

  /// Stream to fetch all the incoming book requests to the user.
  Stream<List<Map<String, dynamic>>> streamAllRequestsToBook(
      String bookId) async* {
    try {
      CollectionReference bookRequestCollection =
          FirebaseFirestore.instance.collection('book_requests');

      QuerySnapshot querySnapshot = await bookRequestCollection
          .where('req_book_id', isEqualTo: bookId)
          .get();

      bool hasData = querySnapshot.docs.isNotEmpty;
      logger.info('$hasData');
      _isRequestsAvailableForBook = true;

      yield querySnapshot.docs
          .map((document) => document.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logger.info('Error retrieving book requests from Firestore: $e');
      _isRequestsAvailableForBook = false;
      notifyListeners();
      // Emit an empty list if there's an error
      yield [];
    }
  }

  //! qorking but with future
  // Future<List<Map<String, dynamic>>> fetchAllRequestsToBook(
  //     String bookId) async {
  //   try {
  //     CollectionReference bookRequestCollection =
  //         FirebaseFirestore.instance.collection('book_requests');

  //     QuerySnapshot querySnapshot = await bookRequestCollection
  //         .where('req_book_id', isEqualTo: bookId)
  //         .get();

  //     bool hasData = querySnapshot.docs.isNotEmpty;
  //     logger.info('$hasData');

  //     _isRequestsAvailableForBook = hasData;
  //     return querySnapshot.docs
  //         .map((document) => document.data() as Map<String, dynamic>)
  //         .toList();
  //   } catch (e) {
  //     logger.info('Error retrieving book requests from Firestore: $e');
  //     _isRequestsAvailableForBook = false;
  //     return [];
  //   }
  // }
}
