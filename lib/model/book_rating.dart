import 'package:p2pbookshare/core/constants/model_constants.dart';

class BookRating {
  final String userId;
  final String bookId;
  final int rating;

  BookRating(
      {required this.userId, required this.bookId, required this.rating});

  // Convert a Rating to a Map
  Map<String, dynamic> toMap() {
    return {
      BookRatingConfig.userId: userId,
      BookRatingConfig.bookId: bookId,
      BookRatingConfig.rating: rating,
    };
  }

  // Create a Rating from a Map
  static BookRating fromMap(Map<String, dynamic> map) {
    return BookRating(
      userId: map[BookRatingConfig.userId] as String,
      bookId: map[BookRatingConfig.bookId] as String,
      rating: map[BookRatingConfig.rating] as int,
    );
  }
}
