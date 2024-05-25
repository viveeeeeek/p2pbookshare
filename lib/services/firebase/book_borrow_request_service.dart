// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/model/borrow_request.dart';

class BookRequestService with ChangeNotifier {
  /// Instance of the current [User]
  final user = FirebaseAuth.instance.currentUser;

  /// Flag to check if a request exists
  bool _bookRequestExists = false;
  bool get bookRequestExists => _bookRequestExists;

  /// Flag to check if the book is available to borrow
  bool _isBookAvailableForBorrow = false;
  bool get isBookAvailableForBorrow => _isBookAvailableForBorrow;

  // Create Firestore collection references
  final CollectionReference bookRequestsCollection =
      FirebaseFirestore.instance.collection('book_requests');
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
//TODO: Create seperate exception handling class
// Helper method for logging errors
  void logFirestoreError(String operation, dynamic error) {
    logger.e('Error $operation book request from Firestore: $error');
  }

  // Helper method to build the query for the book request
  Query buildBookRequestQuery(BorrowRequest bookRequest) {
    return bookRequestsCollection
        .where(BorrowRequestConfig.reqBookID, isEqualTo: bookRequest.reqBookID)
        .where(BorrowRequestConfig.reqBookOwnerID,
            isEqualTo: bookRequest.reqBookOwnerID)
        .where(BorrowRequestConfig.requesterID,
            isEqualTo: bookRequest.requesterID);
  }

  /// Method to check if a [BorrowRequest] already exists for the current user and book
  /// This method is used to prevent duplicate requests / multiple requests for the same book
  Future<bool> checkIfRequestAlreadyMade(BorrowRequest bookRequest) async {
    try {
      /// Check if the book status is available for borrow
      /// If the book is not available, return false
      /// If the book is available, proceed to check if the request exists
      var querySnapshot = await buildBookRequestQuery(bookRequest).get();
      if (querySnapshot.docs.isNotEmpty) {
        _bookRequestExists = true;
        return true;
      } else {
        _bookRequestExists = false;
        return false;
      }
    } catch (e) {
      logFirestoreError('checking existing', e);
      _bookRequestExists = false;
      notifyListeners();
      return false; // Return false if an error occurs
    }
  }

  Stream<Map<String, dynamic>> getBookRequestStatus(
      BorrowRequest bookRequest, String currentUserId) {
    try {
      var query = buildBookRequestQuery(bookRequest).snapshots();

      return query.map((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var snapshot = querySnapshot.docs.first;
          var data = snapshot.data() as Map<String, dynamic>;
          if (data[BorrowRequestConfig.requesterID] == currentUserId) {
            return data;
          }
        }
        return {};
      });
    } catch (e) {
      logFirestoreError('retrieving', e);
      return Stream.value({});
    }
  }

  /// Method to check if the [Book] is available for borrow
  /// Returns a boolean value as a stream
  Stream<bool> checkBookAvailability(String bookID) {
    var booksCollection = FirebaseFirestore.instance.collection('books');

    // Query to check if the book is available for borrow
    return booksCollection
        .where(BookConfig.bookID, isEqualTo: bookID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return false;
      }
      var doc = snapshot.docs.first;
      var bookAvailability = doc[BookConfig.bookAvailability];
      logger.i('Book availability: $bookAvailability');
      return bookAvailability;
    });
  }

  /// Stream to fetch all the incoming pending book requests to the user.
  Stream<List<Map<String, dynamic>>> fetchNotifications() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Stream.value([]);
    } else {
      try {
        Query query = bookRequestsCollection
            .where(BorrowRequestConfig.reqBookOwnerID,
                isEqualTo: currentUser.uid)
            .where(BorrowRequestConfig.reqStatus, isEqualTo: 'pending');
        return query.snapshots().map((querySnapshot) {
          if (querySnapshot.docs.isEmpty) {
            return [];
          }
          return querySnapshot.docs
              .map((document) => document.data() as Map<String, dynamic>)
              .toList();
        });
      } catch (e) {
        logFirestoreError('retrieving', e);
        return Stream.value([]);
      }
    }
  }

  /// This method is used to fetch all the incoming book requests for the specific book
  /// Used in [UserBookDetailsView] to display the requests for the book
  Stream<List<Map<String, dynamic>>> fetchRequestsForBook(String bookId) {
    try {
      Query query = bookRequestsCollection
          .where(BorrowRequestConfig.reqBookID, isEqualTo: bookId)
          .where(BorrowRequestConfig.reqStatus, isEqualTo: 'pending');
      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logFirestoreError('retrieving', e);
      return Stream.value([]);
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
          .where(BorrowRequestConfig.reqBookID, isEqualTo: bookID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true; // Book request exists
      } else {
        return false; // Book request does not exist
      }
    } catch (e) {
      logger.e('Error checking existing request: $e');
      return false; // Return false if an error occurs
    }
  }

  /// This method is used in the home view to display the book requests notification card
  Stream<bool> hasBookRequestsForCurrentUser(
      String collectionPath, String userId) {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    return collectionRef
        .where(BorrowRequestConfig.reqBookOwnerID, isEqualTo: userId)
        .where(BorrowRequestConfig.reqStatus, isEqualTo: 'pending')
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

  /// Method to count total numbers of book requests received by the user, and return the count as a stream
  /// This method is used in the homeview to inside book requests notification card
  Stream<int> countNoOfBookRequestsReceivedAsStream(String userUid) async* {
    final collectionRef = FirebaseFirestore.instance
        .collection('book_requests')
        .where(BorrowRequestConfig.reqBookOwnerID, isEqualTo: userUid)
        .where(BorrowRequestConfig.reqStatus, isEqualTo: 'pending');
    await for (var snapshot in collectionRef.snapshots()) {
      yield snapshot.docs.length;
    }
  }

  /// Method to count total numbers of books uploaded by the user, and return the count as a stream
  /// This method is used in the [ProfileView] to display the number of books
  Stream<int> countNoOfBooksUploadedAsStream() {
    return countDocumentsInCollectionAsStream(
        collectionPath: 'books',
        fieldName: 'book_owner',
        fieldValue: user!.uid);
  }

  /// Used to get the books requested by the current user
  /// Returns a stream of list of maps
  Stream<List<Map<String, dynamic>>> getBooksRequestedByCurrentUser(
      String userUid) {
    try {
      Query query = bookRequestsCollection
          .where(BorrowRequestConfig.requesterID, isEqualTo: userUid)
          .where(BorrowRequestConfig.reqStatus,
              whereIn: ['pending', 'accepted']);

      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logFirestoreError('retrieving', e);
      return Stream.value([]);
    }
  }

  /// Method to get the [BorrowRequest] details by [req_id]
  /// This method is used to get the book request details, Returns a map of book request details
  /// Used in the outgoing book request details view, to display the book request details
  Future<Map<String, dynamic>> getRequestDetailsByID(String requestID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await bookRequestsCollection.doc(requestID).get();

      return documentSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      logFirestoreError('retrieving', e);
      return {};
    }
  }

  /// Method to get book request status by request id
  /// This method is used to get the book request status by request id, Returns a map of book request status
  /// Used in the outgoing book request details view, to display the book request status
  Stream<Map<String, dynamic>> getRequestStatusbyID(String requestID) {
    try {
      return bookRequestsCollection.doc(requestID).snapshots().map((snapshot) {
        return snapshot.data() as Map<String, dynamic>;
      });
    } catch (e) {
      logFirestoreError('retrieving', e);
      return Stream.value({});
    }
  }

  /// Method to check if the book request is accepted
  /// takes [book_id] as input and returns a stream of map of book requests
  /// Used in the [UserBookDetailsView] to check if the book request is accepted
  Stream<Map<String, dynamic>> checkBookRequestAccepted(String bookID) {
    try {
      return bookRequestsCollection
          .where(BorrowRequestConfig.reqBookID, isEqualTo: bookID)
          .where(BorrowRequestConfig.reqStatus, isEqualTo: 'accepted')
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return {};
        }
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      });
    } catch (e) {
      logFirestoreError('retrieving', e);
      return Stream.value({});
    }
  }

  //! Book Request CRUD Operations
  /// This method is used in [BookRequestView] to send a [BorrowRequest] to the owner of the book
  /// It checks if the book is available for borrow and if the request already exists
  /// If the book is available and the request does not exist, it creates a new request
  sendBookBorrowRequest(BorrowRequest bookRequestModel) async {
    try {
      Map<String, dynamic> bookRequestsData = bookRequestModel.toMap();
      // Add document id as a field in the document [book_id]
      DocumentReference documentReference =
          await bookRequestsCollection.add(bookRequestsData);
      String documentId = documentReference.id;
      await documentReference.update({BorrowRequestConfig.reqID: documentId});
      logger.i("✅ Book request created");
      _bookRequestExists = true;
      notifyListeners();
    } catch (e) {
      logFirestoreError('creating', e);
    }
  }

  /// This method is used to delete the book request
  /// Used in [UserBookDetailsView] view to reject the incoming book borrow request
  deleteBookBorrowRequest(String requestID) async {
    try {
      await bookRequestsCollection.doc(requestID).delete();
      logger.i('✅ Book request deleted');
    } catch (e) {
      logFirestoreError('deleting', e);
    }
  }

  /// Method used to accept the book request
  /// Used in the [UserBookDetailsView] view to accept the book request
  /// Deletes all other pending requests for the same book
  /// Update the [book_availability] to false & [req_status] to accepted inside firestore
  acceptBookBorrowRequest(String requestID, String bookID) async {
    try {
      // Update the request status to accepted
      await bookRequestsCollection
          .doc(requestID)
          .update({BorrowRequestConfig.reqStatus: 'accepted'});
      await booksCollection
          .doc(bookID)
          .update({BookConfig.bookAvailability: false});
      // Delete all other requests for the same book
      await bookRequestsCollection
          .where(BorrowRequestConfig.reqBookID, isEqualTo: bookID)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          // Checks for all the requests for the same book which are not the accepted request
          if (element.id != requestID) {
            // Exclude the accepted request
            bookRequestsCollection.doc(element.id).delete();
          }
        });
      });
    } catch (e) {
      logFirestoreError('accepting', e);
    }
  }

  /// update borrow request status to [completed]
  /// Used in the [UserBookDetailsView] view to complete the book request
  /// Updates the [req_status] to completed inside firestore
  completeBookBorrowRequest(String bookRequestID, String bookID) async {
    try {
      // await bookRequestsCollection
      //     .doc(bookRequestID)
      //     .update({BorrowRequestConfig.reqStatus: 'completed'});
      await bookRequestsCollection.doc(bookRequestID).delete();
      await booksCollection
          .doc(bookID)
          .update({BookConfig.bookAvailability: true});
    } catch (e) {
      logFirestoreError('completing', e);
    }
  }
}
