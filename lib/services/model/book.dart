// book_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String bookTitle;
  final String bookAuthor;
  // final String bookDescription;
  final String? bookPublication;
  final String bookCondition;
  final String bookGenre;
  final bool bookAvailability;
  final String bookCoverImageUrl;
  final String bookOwner;
  final String? bookID;
  final GeoPoint? location;
  final String completeAddress;

  BookModel(
      {required this.bookTitle,
      required this.bookAuthor,
      // required this.bookDescription,
      this.bookPublication,
      required this.bookCondition,
      required this.bookGenre,
      required this.bookAvailability,
      required this.bookCoverImageUrl,
      required this.bookOwner,
      this.bookID, // Making bookID nullable
      required this.location,
      required this.completeAddress});

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
        bookTitle: map['book_title'],
        bookAuthor: map['book_author'],
        // bookDescription: map['book_description'],
        bookPublication: map['book_publication'],
        bookCondition: map['book_condition'],
        bookGenre: map['book_genre'],
        bookAvailability: map['book_availability'],
        bookCoverImageUrl: map['book_coverimg_url'],
        bookOwner: map['book_owner'],
        bookID: map['book_id'],
        location: map['book_exchange_location'] != null
            ? GeoPoint(
                map['book_exchange_location'].latitude,
                map['book_exchange_location'].longitude,
              )
            : null,
        completeAddress: map['book_exchange_address']);
  }

  Map<String, dynamic> toMap() {
    return {
      'book_title': bookTitle,
      'book_author': bookAuthor,
      // 'book_description': bookDescription,
      'book_publication': bookPublication,
      'book_condition': bookCondition,
      'book_genre': bookGenre,
      'book_availability': bookAvailability,
      'book_coverimg_url': bookCoverImageUrl,
      'book_owner': bookOwner,
      'book_id': bookID,
      'book_exchange_location': location, // Use GeoPoint directly
      'book_exchange_address': completeAddress
    };
  }
}
