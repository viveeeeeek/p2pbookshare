// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/book_img_stack.dart';
import 'package:p2pbookshare/pages/view_book/view_book_screen.dart';
import 'package:p2pbookshare/services/model/book.dart';

class CategorizedBookList extends StatelessWidget {
  const CategorizedBookList({
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
                        booksList[1]['book_category'] ?? 'Category',
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
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: booksList.length,
                      itemBuilder: (context, index) {
                        if (booksList[index]['isPlaceholder'] == true) {
                          return const SizedBox(width: 15);
                        } else {
                          Map<String, dynamic> bookData = booksList[index];
                          return buildCategoryBooksWidget(context, bookData);
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
    BuildContext context, Map<String, dynamic> bookData) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewBookScreen(
              bookData: Book(
                bookTitle: bookData['book_title'],
                bookAuthor: bookData['book_author'],
                bookPublication: bookData['book_publication'],
                bookCondition: bookData['book_condition'],
                bookCategory: bookData['book_category'],
                bookAvailability: bookData['book_availability'],
                bookCoverImageUrl: bookData['book_coverimg_url'],
                bookOwner: bookData['book_owner'],
                bookID: bookData['book_id'],
                location: bookData[
                    'book_exchange_location'], // Directly access GeoPoint
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: BookImageStack(
            bookID: bookData['book_id'],
            bookImgUrl: bookData['book_coverimg_url'],
            bookTitle: bookData['book_title']),
      ),
    ),
  );
}
