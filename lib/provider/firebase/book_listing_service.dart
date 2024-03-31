import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_logger/simple_logger.dart';

import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/model/book.dart';

class BookListingService with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;
  final logger = SimpleLogger();

  Future<String?> uploadCoverImage(File imageFile, String fileName) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('book_cover_images/$fileName');
    try {
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      logger.info('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

//! Add new book to database
/*
  1. Create a reference to the 'books' collection 2. Convert the Book object to a map
  3. Add the book details to the 'books' collection and get the document reference
  4. Get the ID of the added document 5. Update the book's document with the 'book_id' field
*/
  Future<void> addNewBookListing(Book book) async {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      Map<String, dynamic> bookData = book.toMap();
      DocumentReference docRef = await booksCollection.add(bookData);
      String bookId = docRef.id;
      await docRef.update({BookConfig.bookID: bookId});
      logger.info("✅✅Book added");
    } catch (e) {
      logger.info('Error adding book details to Firestore: $e');
    }
  }

  //Method to delete the book document from the Firestore and respective book cover image from the Firebase Storage
  Future<void> deleteBookListing(
      String bookId, String bookCoverImageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
      await FirebaseStorage.instance.refFromURL(bookCoverImageUrl).delete();
      logger.info("✅✅Book deleted");
    } catch (e) {
      logger.info('Error deleting book details from Firestore: $e');
    }
  }

  // /// Method to update the book details in the Firestore
  // /// update book availability status
  // Future<void> updateBookAvailabilityStatus(
  //     String bookId, bool isAvailable) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('books').doc(bookId).update({
  //       BookConfig.bookAvailability: isAvailable,
  //     });
  //     logger.info("✅✅Book availability status updated");
  //   } catch (e) {
  //     logger.info('Error updating book availability status in Firestore: $e');
  //   }
  // }
}
