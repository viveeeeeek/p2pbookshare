// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p2pbookshare/core/utils/logging.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';

/// A service class for fetching books from Firestore.
class BookFetchService with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;

  /// Gets books dynamically by category.
  ///
  /// - Reference to the 'books' collection
  /// - Query documents based on the 'category' field
  /// - Listen for real-time updates using snapshots()
  /// - Convert documents to a list of maps
  /// - Check if there are any documents in the collection
  ///
  /// Returns a stream containing a list of maps, where each map represents book data.
  Stream<List<Map<String, dynamic>>> getCategoryWiseBooks(String category) {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      Query query =
          booksCollection.where(BookConfig.bookGenre, isEqualTo: category);

      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logger.i('Error retrieving books by category from Firestore: $e');
      return Stream.value([]);
    }
  }

  /// Gets all books.
  ///
  /// - Reference to the 'books' collection
  /// - Listen for real-time updates using snapshots()
  /// - Convert documents to a list of maps
  /// - Check if there are any documents in the collection
  ///
  /// Returns a stream containing a list of maps, where each map represents book data.
  Stream<List<Map<String, dynamic>>> getAllBooks() {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      Query query = booksCollection;

      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logger.i('Error retrieving books from Firestore: $e');
      return Stream.value([]);
    }
  }

  /// Gets books listed by the current user.
  ///
  /// - Reference to the 'books' collection
  /// - Query documents based on the BookConfig.bookOwnerID field (current user)
  /// - Listen for real-time updates using snapshots()
  /// - Convert documents to a list of maps
  /// - Check if there are any documents in the collection
  ///
  /// Returns a stream containing a list of maps, where each map represents book data.
  Stream<List<Map<String, dynamic>>> getUserListedBooks() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Stream.value([]);
    }

    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      Query query = booksCollection.where(BookConfig.bookOwnerID,
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
      logger.i('Error retrieving books from Firestore: $e');
      return Stream.value([]);
    }
  }

  /// Fetch book details by given bookID

  Future<Map<String, dynamic>?> getBookDetailsById(String bookId) async {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      QuerySnapshot querySnapshot = await booksCollection
          .where(BookConfig.bookID, isEqualTo: bookId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // Return null if no matching book is found
      }

      var document = querySnapshot.docs.first;
      var bookData = document.data() as Map<String, dynamic>;

      return bookData;
    } catch (e) {
      logger.i('Error retrieving book details from Firestore: $e');
      return null;
    }
  }

  /// fetch top 7 books with highest book_rating
  Stream<List<Map<String, dynamic>>> getTopRatedBooks() {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      Query query = booksCollection
          .orderBy(BookConfig.bookRating, descending: true)
          .limit(6);

      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logger.i('Error retrieving top rated books from Firestore: $e');
      return Stream.value([]);
    }
  }
}
