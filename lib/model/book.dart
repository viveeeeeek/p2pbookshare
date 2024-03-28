// book_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';

class Book {
  final String bookTitle;
  final String bookAuthor;
  // final String bookDescription;
  final String? bookPublication;
  final String bookCondition;
  final String bookGenre;
  final bool bookAvailability;
  final String bookCoverImageUrl;
  final String bookOwnerID;
  final String? bookID;
  final int? bookRating;
  final GeoPoint? location;
  final String completeAddress;

  Book(
      {required this.bookTitle,
      required this.bookAuthor,
      // required this.bookDescription,
      this.bookPublication,
      required this.bookCondition,
      required this.bookGenre,
      required this.bookAvailability,
      required this.bookCoverImageUrl,
      required this.bookOwnerID,
      this.bookID, // Making bookID nullable
      this.bookRating,
      required this.location,
      required this.completeAddress});

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        bookTitle: map[BookConfig.bookTitle],
        bookAuthor: map[BookConfig.bookAuthor],
        // bookDescription: map['book_description'],
        bookPublication: map[BookConfig.bookPublication],
        bookCondition: map[BookConfig.bookCondition],
        bookGenre: map[BookConfig.bookGenre],
        bookAvailability: map[BookConfig.bookAvailability],
        bookCoverImageUrl: map[BookConfig.bookCoverImageUrl],
        bookOwnerID: map[BookConfig.bookOwnerID],
        bookID: map[BookConfig.bookID],
        bookRating: map[BookConfig.bookRating] ?? 0,
        location: map[BookConfig.location] != null
            ? GeoPoint(
                map[BookConfig.location].latitude,
                map[BookConfig.location].longitude,
              )
            : null,
        completeAddress: map[BookConfig.completeAddress]);
  }

  Map<String, dynamic> toMap() {
    return {
      BookConfig.bookTitle: bookTitle,
      BookConfig.bookAuthor: bookAuthor,
      // 'book_description': bookDescription,
      BookConfig.bookPublication: bookPublication,
      BookConfig.bookCondition: bookCondition,
      BookConfig.bookGenre: bookGenre,
      BookConfig.bookAvailability: bookAvailability,
      BookConfig.bookCoverImageUrl: bookCoverImageUrl,
      BookConfig.bookOwnerID: bookOwnerID,
      BookConfig.bookID: bookID,
      BookConfig.bookRating: bookRating,
      BookConfig.location: location,
      BookConfig.completeAddress: completeAddress
    };
  }
}
