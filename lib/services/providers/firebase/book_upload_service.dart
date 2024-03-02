import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/book_model.dart';
import 'package:simple_logger/simple_logger.dart';

class BookUploadService with ChangeNotifier {
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
  Future<void> addNewBookListing(BookModel book) async {
    try {
      CollectionReference booksCollection =
          FirebaseFirestore.instance.collection('books');
      Map<String, dynamic> bookData = book.toMap();
      DocumentReference docRef = await booksCollection.add(bookData);
      String bookId = docRef.id;
      await docRef.update({'book_id': bookId});
      logger.info("✅✅Book added");
    } catch (e) {
      logger.info('Error adding book details to Firestore: $e');
    }
  }
}
