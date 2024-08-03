import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/model/book_rating.dart';

class BookRatingService {
  final CollectionReference bookRatingCollection =
      FirebaseFirestore.instance.collection('book_ratings');

  Future<void> updateBookRating(
      String userId, String bookId, int newRating) async {
    try {
      CollectionReference ratingsRef =
          FirebaseFirestore.instance.collection('book_ratings');
      QuerySnapshot querySnapshot = await ratingsRef
          .where(BookRatingConfig.bookId, isEqualTo: bookId)
          .where(BookRatingConfig.userId, isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User has already rated the book, so update the existing rating
        DocumentSnapshot ratingSnapshot = querySnapshot.docs.first;
        await ratingSnapshot.reference.update({'rating': newRating});
      } else {
        // User has not rated the book yet, so create a new rating
        await ratingsRef.add({
          BookRatingConfig.bookId: bookId,
          BookRatingConfig.userId: userId,
          BookRatingConfig.rating: newRating,
        });
      }

      logger.i("✅✅Book rating updated");
    } catch (e) {
      logger.i('Error updating book rating in Firestore: $e');
    }
  }

  Future<void> updateAverageRating(String bookId) async {
    try {
      CollectionReference ratingsRef =
          FirebaseFirestore.instance.collection('book_ratings');
      QuerySnapshot querySnapshot = await ratingsRef
          .where(BookRatingConfig.bookId, isEqualTo: bookId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Calculate the average rating
        int totalRating = 0;
        querySnapshot.docs.forEach((doc) {
          BookRating rating =
              BookRating.fromMap(doc.data() as Map<String, dynamic>);
          totalRating += rating.rating;
        });
        int averageRating = (totalRating / querySnapshot.docs.length).round();

        // Update the book_rating field in the book document
        DocumentReference bookRef =
            FirebaseFirestore.instance.collection('books').doc(bookId);
        await bookRef.update({'book_ratings': averageRating});

        logger.i("✅✅Average rating updated");
      } else {
        logger.i("No ratings found for this book");
      }
    } catch (e) {
      logger.i('Error updating average rating in Firestore: $e');
    }
  }

  // Get rating for specific book and user
  Stream<int> getBookRatingStream(String userId, String bookId) {
    try {
      CollectionReference ratingsRef =
          FirebaseFirestore.instance.collection('book_ratings');
      return ratingsRef
          .where(BookRatingConfig.bookId, isEqualTo: bookId)
          .where(BookRatingConfig.userId, isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.get(BookRatingConfig.rating);
        } else {
          return 0;
        }
      });
    } catch (e) {
      logger.i('Error fetching book rating from Firestore: $e');
      return Stream.value(0);
    }
  }
}
