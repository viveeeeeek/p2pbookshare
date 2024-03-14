import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/model/book_model.dart';

import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/view/user_book/user_book_details_view.dart';

class UserBooksTab extends StatelessWidget {
  const UserBooksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: BookFetchService().getUserListedBooks(),
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              3, // Change to 3 for three items per row
                          crossAxisSpacing: 8, // Adjust spacing as needed
                          mainAxisSpacing: 8, // Adjust spacing as needed
                          childAspectRatio: 0.77, // Maintain 1:1 aspect ratio
                        ),
                        physics: const ClampingScrollPhysics(),
                        itemCount: booksList.length,
                        itemBuilder: (context, index) {
                          return buildCategoryBooksWidget(
                              context, booksList[index]);
                        },
                      );
                    }
                  },
                )),
          )
        ],
      ),
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
