import 'package:flutter/material.dart';

import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/views/user_book/user_book_details_view.dart';
import 'package:p2pbookshare/model/book_model.dart';

class UserBooksGridView extends StatelessWidget {
  const UserBooksGridView({
    super.key,
    required this.context,
    required this.stream,
  });

  final BuildContext context;
  final Stream<List<Map<String, dynamic>>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found.'));
        } else {
          List<Map<String, dynamic>> booksList = snapshot.data!;
          return GridView.builder(
            shrinkWrap: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Change to 3 for three items per row
              crossAxisSpacing: 8, // Adjust spacing as needed
              mainAxisSpacing: 8, // Adjust spacing as needed
              childAspectRatio: 0.77, // Maintain 1:1 aspect ratio
            ),
            physics: const ClampingScrollPhysics(),
            itemCount: booksList.length,
            itemBuilder: (context, index) {
              return buildCategoryBooksWidget(context, booksList[index]);
            },
          );
        }
      },
    );
  }
}

Widget buildCategoryBooksWidget(
    BuildContext context, Map<String, dynamic> bookData) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserBookDetailsView(
            bookData: BookModel(
                bookTitle: bookData['book_title'],
                bookAuthor: bookData['book_author'],
                bookPublication: bookData['book_publication'],
                bookCondition: bookData['book_condition'],
                bookGenre: bookData['book_genre'],
                bookAvailability: bookData['book_availability'],
                bookCoverImageUrl: bookData['book_coverimg_url'],
                bookOwnerID: bookData['book_owner'],
                bookID: bookData['book_id'],
                location: bookData[
                    'book_exchange_location'], // Directly access GeoPoint
                completeAddress: bookData['book_exchange_address']),
            heroKey: '${bookData['book_coverimg_url']}-userbookview',
          ),
        ),
      );
    },
    child: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: SizedBox(
            height: 180,
            width: 130,
            child: CachedImage(
              imageUrl: bookData['book_coverimg_url'],
              // borderRadius: const BorderRadius.all(Radius.circular(5)
              // ),
            ),
          ),
        )),
  );
}
