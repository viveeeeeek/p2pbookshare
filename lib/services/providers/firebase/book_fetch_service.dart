import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_logger/simple_logger.dart';

/// A service class for fetching books from Firestore.
class BookFetchService with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  final logger = SimpleLogger();

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
      Query query = booksCollection.where('book_genre', isEqualTo: category);

      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logger.info('Error retrieving books by category from Firestore: $e');
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
      logger.info('Error retrieving books from Firestore: $e');
      return Stream.value([]);
    }
  }

  /// Gets books listed by the current user.
  ///
  /// - Reference to the 'books' collection
  /// - Query documents based on the 'book_owner' field (current user)
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
      Query query =
          booksCollection.where('book_owner', isEqualTo: currentUser.uid);

      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logger.info('Error retrieving books from Firestore: $e');
      return Stream.value([]);
    }
  }

  /// Fetch book details by given bookID

  Future<Map<String, dynamic>?> getBookDetailsById(String bookId) async {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      QuerySnapshot querySnapshot =
          await booksCollection.where('book_id', isEqualTo: bookId).get();

      if (querySnapshot.docs.isEmpty) {
        return null; // Return null if no matching book is found
      }

      var document = querySnapshot.docs.first;
      var bookData = document.data() as Map<String, dynamic>;

      return bookData;
    } catch (e) {
      logger.info('Error retrieving book details from Firestore: $e');
      return null;
    }
  }
}
