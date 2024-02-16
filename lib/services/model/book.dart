// book_model.dart
//TODO Change book catergoryname to book genre insdie firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String bookTitle;
  final String bookAuthor;
  // final String bookDescription;
  final String bookPublication;
  final String bookCondition;
  final String bookCategory;
  final bool bookAvailability;
  final String bookCoverImageUrl;
  final String bookOwner;
  final String? bookID;
  final GeoPoint? location;

  Book(
      {required this.bookTitle,
      required this.bookAuthor,
      // required this.bookDescription,
      required this.bookPublication,
      required this.bookCondition,
      required this.bookCategory,
      required this.bookAvailability,
      required this.bookCoverImageUrl,
      required this.bookOwner,
      this.bookID, // Making bookID nullable
      required this.location});

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      bookTitle: map['book_title'],
      bookAuthor: map['book_author'],
      // bookDescription: map['book_description'],
      bookPublication: map['book_publication'],
      bookCondition: map['book_condition'],
      bookCategory: map['book_category'],
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book_title': bookTitle,
      'book_author': bookAuthor,
      // 'book_description': bookDescription,
      'book_publication': bookPublication,
      'book_condition': bookCondition,
      'book_category': bookCategory,
      'book_availability': bookAvailability,
      'book_coverimg_url': bookCoverImageUrl,
      'book_owner': bookOwner,
      'book_id': bookID,
      'book_exchange_location': location, // Use GeoPoint directly
    };
  }
}
