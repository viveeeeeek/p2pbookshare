import 'package:flutter/material.dart';
import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book_model.dart';
import 'package:p2pbookshare/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/views/profile/widgets/user_books_grid_view.dart';
import 'package:p2pbookshare/views/request_book/request_book_view.dart';
import 'package:provider/provider.dart';

class OutgoingNotificationTab extends StatelessWidget {
  const OutgoingNotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: Consumer<BookRequestHandlingService>(
              builder: (context, bookRequestHandlingService, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: P2pbookshareStreamBuilder(
                      dataStream: bookRequestHandlingService
                          .getBooksRequestedByCurrentUser(),
                      successBuilder: (data) {
                        final booksList = data;
                        logger.info('BooksList: $booksList');
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
                            return FutureBuilder(
                                future: BookFetchService().getBookDetailsById(
                                    booksList[index]['req_book_id']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CustomShimmerContainer(
                                        height: 200,
                                        width: double.infinity,
                                        borderRadius: 15);
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    Map<String, dynamic> bookData =
                                        snapshot.data!;
                                    logger.info('BookData: $bookData');
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestBookView(
                                                      bookData: BookModel(
                                                        bookID:
                                                            bookData['book_id'],
                                                        bookTitle: bookData[
                                                            'book_title'],
                                                        bookAuthor: bookData[
                                                            'book_author'],
                                                        bookCondition: bookData[
                                                            'book_condition'],
                                                        bookGenre: bookData[
                                                            'book_genre'],
                                                        bookAvailability: bookData[
                                                            'book_availability'],
                                                        bookCoverImageUrl: bookData[
                                                            'book_coverimg_url'],
                                                        bookOwnerID: bookData[
                                                            'book_owner'],
                                                        location: bookData[
                                                            'book_exchange_location'],
                                                        bookRating: bookData[
                                                            'book_rating'],
                                                        completeAddress: bookData[
                                                            'book_exchange_address'],
                                                      ),
                                                      heroKey:
                                                          '${bookData['book_coverimg_url']}-outgoingbookreqtab')),
                                        );
                                      },
                                      // child: buildCategoryBooksWidget(
                                      //     context, bookData),
                                      child: Hero(
                                        tag:
                                            '${bookData['book_coverimg_url']}-outgoingbookreqtab',
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          child: SizedBox(
                                              height: 180,
                                              width: 130,
                                              child: CachedImage(
                                                imageUrl: bookData[
                                                    'book_coverimg_url'],
                                              )),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                        'Error loading book details');
                                  }
                                });
                          },
                        );
                      },
                      waitingBuilder: () {
                        return const CustomShimmerContainer(
                            height: 200,
                            width: double.infinity,
                            borderRadius: 15);
                      },
                      errorBuilder: (error) {
                        return Center(
                            child: Text('Error fetching data $error'));
                      }),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
