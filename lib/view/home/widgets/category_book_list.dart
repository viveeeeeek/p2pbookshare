import 'package:flutter/material.dart';

import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/view/home/widgets/book_card.dart';
import 'package:p2pbookshare/view/request_book/request_book_view.dart';
import 'package:p2pbookshare/view/user_book/user_book_details_view.dart';

class CategorizedBookList extends StatelessWidget {
  const CategorizedBookList({
    super.key,
    required this.context,
    required this.stream,
    required this.currentUserID,
  });

  final BuildContext context;
  final Stream<List<Map<String, dynamic>>> stream;
  final String currentUserID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: P2PBookShareShimmerContainer(
                height: 180, width: 400, borderRadius: 15),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        } else {
          List<Map<String, dynamic>> booksList = snapshot.data!;
          final placeholderItem = {'isPlaceholder': true};
          booksList.insert(0, placeholderItem);

          return SizedBox(
              height: 250,
              // color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 4),
                    child: Text(
                        // 'cat',
                        booksList[1][BookConfig.bookGenre] ?? 'Category',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    //This is the maximum height that horizontal listview will have
                    height: 200,
                    child: ListView.builder(
                      // physics: const,
                      scrollDirection: Axis.horizontal,
                      itemCount: booksList.length,
                      itemBuilder: (context, index) {
                        if (booksList[index]['isPlaceholder'] == true) {
                          return const SizedBox(width: 15);
                        } else {
                          Map<String, dynamic> bookData = booksList[index];
                          return buildCategoryBooksWidget(
                              context, bookData, currentUserID);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ));
        }
      },
    );
  }
}

Widget buildCategoryBooksWidget(
    BuildContext context, Map<String, dynamic> bookData, String currentUserID) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: GestureDetector(
      onTap: () {
        if (currentUserID == bookData[BookConfig.bookOwnerID]) {
          logger.i('User is the owner of the book');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserBookDetailsView(
                heroKey:
                    '${bookData[BookConfig.bookCoverImageUrl]}-categorizedbooklist',
                bookData: Book.fromMap(bookData),
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestBookView(
                heroKey:
                    '${bookData[BookConfig.bookCoverImageUrl]}-categorizedbooklist',
                bookData: Book.fromMap(bookData),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: BookCard(
          cardHeight: 200,
          cardWidth: 150,
          heroKey:
              '${bookData[BookConfig.bookCoverImageUrl]}-categorizedbooklist',
          title: bookData[BookConfig.bookTitle],
          imageUrl: bookData[BookConfig.bookCoverImageUrl],
        ),
      ),
    ),
  );
}
