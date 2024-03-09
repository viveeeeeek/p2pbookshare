import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_logger/simple_logger.dart';

import 'package:p2pbookshare/model/book_request.dart';

class BookRequestHandlingService with ChangeNotifier {
  /// Instance of the current user
  final user = FirebaseAuth.instance.currentUser;

  /// Instance of the logger
  final logger = SimpleLogger();

  /// Flag to check if a request exists
  bool _bookRequestExists = false;
  bool get bookRequestExists => _bookRequestExists;
  //TODO: Flag not implemeneted

  /// Flag to check if the book requests are available for current user
  bool _isBookRequestAvailable = false;
  bool get isBookRequestAvailable => _isBookRequestAvailable;

  /// Flag to check if the book is available for borrow
  bool _isBookAvailableForBorrow = false;
  bool get isBookAvailableForBorrow => _isBookAvailableForBorrow;

  /// Method to check if a request already exists for the current user and book
  /// This method is used to prevent duplicate requests / multiple requests for the same book
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

  ///Method to check if the book is available for borrow
  ///This method is used to check if the book is available for borrow
  ///Returns a boolean value as a stream
  Stream<bool> checkIfBookIsAvailableForBorrowAsStream(String bookID) {
    var bookRequestsCollection = FirebaseFirestore.instance.collection('books');

    // Query to check if the book is available for borrow
    return bookRequestsCollection
        .where('book_id', isEqualTo: bookID)
        .where('book_availability', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Method to send a book borrow request to the owner of the book
  /// This method is used to send a request to the owner of the book
  sendBookBorrowRequest(BookRequestModel bookRequestModel) async {
    try {
      try {
        Stream<bool> bookAvailability =
            await checkIfBookIsAvailableForBorrowAsStream(
                bookRequestModel.reqBookID);

        if (bookAvailability == false) {
          _isBookAvailableForBorrow = false;
          notifyListeners();
          logger.info('❌Book not available for borrow');
        } else {
          _isBookAvailableForBorrow = true;
          notifyListeners();
          bool requestExists =
              await checkIfRequestAlreadyMade(bookRequestModel);

          if (requestExists) {
            logger.info(
                '❌Request already made'); // Print message if request exists
            _bookRequestExists = true;
            notifyListeners();
          } else {
            var bookRequestsCollection =
                FirebaseFirestore.instance.collection('book_requests');
            Map<String, dynamic> bookRequestsData = bookRequestModel.toMap();
            await bookRequestsCollection.add(bookRequestsData);
            logger.info("✅ Book request created");
            _bookRequestExists = true;
            notifyListeners();
          }
        }
      } catch (e) {
        logger.warning('Error creating book request to Firestore: $e');
      }
    } catch (e) {
      logger.warning('Error creating book request to Firestore: $e');
    }
  }

  /// Stream to fetch all the incoming book requests to the user.
  /// This method is used to fetch all the incoming book requests to the user
  /// Returns a stream of list of maps
  Stream<List<Map<String, dynamic>>> fetchNotifications() {
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
  /// This method is used to fetch all the incoming book requests for the specific book
  /// Used in User book details page to display the requests for the book
  Stream<List<Map<String, dynamic>>> fetchRequestsForBook(
      String bookId) async* {
    try {
      CollectionReference bookRequestCollection =
          FirebaseFirestore.instance.collection('book_requests');

      QuerySnapshot querySnapshot = await bookRequestCollection
          .where('req_book_id', isEqualTo: bookId)
          .get();

      bool hasData = querySnapshot.docs.isNotEmpty;
      logger.info('$hasData');
      // _isRequestsAvailableForBook = true;

      yield querySnapshot.docs
          .map((document) => document.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logger.info('Error retrieving book requests from Firestore: $e');
      // _isRequestsAvailableForBook = false;
      // notifyListeners();
      // Emit an empty list if there's an error
      yield [];
    }
  }

  /// Method to check if the request exists for the book
  /// This method is used when deleting the book listing from the user's profile
  Future<bool> requestExists(String bookID) async {
    try {
      var bookRequestsCollection =
          FirebaseFirestore.instance.collection('book_requests');

      // Query to check if a request exists for the current user and book
      var querySnapshot = await bookRequestsCollection
          .where('req_book_id', isEqualTo: bookID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true; // Book request exists
      } else {
        return false; // Book request does not exist
      }
    } catch (e) {
      logger.warning('Error checking existing request: $e');
      return false; // Return false if an error occurs
    }
  }

  /// This method is used in the home view to display the book requests notification card

  Stream<bool> hasBookRequestsForCurrentUser(
      String collectionPath, String userId) {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    return collectionRef
        .where('req_book_owner_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Method to count total numbers of documents inside a collection
  /// and return the count as a stream
  Stream<int> countDocumentsInCollectionAsStream(
      {required String collectionPath,
      required String fieldName,
      required String fieldValue}) async* {
    final collectionRef = FirebaseFirestore.instance
        .collection(collectionPath)
        .where(fieldName, isEqualTo: fieldValue);
    await for (var snapshot in collectionRef.snapshots()) {
      yield snapshot.docs.length;
    }
  }

  /// Method to count total numbers of book requests received by the user
  /// and return the count as a stream
  /// This method is used in the homeview to inside book requests notification card
  Stream<int> countNoOfBookRequestsReceivedAsStream(String userUid) {
    return countDocumentsInCollectionAsStream(
        collectionPath: 'book_requests',
        fieldName: 'req_book_owner_id',
        fieldValue: userUid);
  }

  /// Method to count total numbers of books uploaded by the user
  /// and return the count as a stream
  /// This method is used in the profile header to display the number of books
  Stream<int> countNoOfBooksUploadedAsStream() {
    return countDocumentsInCollectionAsStream(
        collectionPath: 'books',
        fieldName: 'book_owner',
        fieldValue: user!.uid);
  }

  /// Method to get the books requested by current user
  /// This method is used to get the books requested by the current user
  /// Returns a stream of list of maps
  Stream<List<Map<String, dynamic>>> getBooksRequestedByCurrentUser() async* {
    try {
      CollectionReference bookRequestCollection =
          FirebaseFirestore.instance.collection('book_requests');

      QuerySnapshot querySnapshot = await bookRequestCollection
          .where('reqeuster_id', isEqualTo: user!.uid)
          .get();

      bool hasData = querySnapshot.docs.isNotEmpty;
      logger.info('$hasData');
      // _isRequestsAvailableForBook = true;

      yield querySnapshot.docs
          .map((document) => document.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      logger.info('Error retrieving book requests from Firestore: $e');
      // _isRequestsAvailableForBook = false;
      // notifyListeners();
      // Emit an empty list if there's an error
      yield [];
    }
  }
}
