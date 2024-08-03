import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/services/firebase/book_rating_service.dart';

class OutgoingreqViewModel {
  BookRatingService _bookRatingService = BookRatingService();

  updateBookRating(String userId, String bookId, int rating) async {
    try {
      await _bookRatingService.updateBookRating(userId, bookId, rating);
      await _bookRatingService.updateAverageRating(bookId);
    } catch (e) {
      logger.i('Error updating book rating in Firestore: $e');
    }
  }
}
