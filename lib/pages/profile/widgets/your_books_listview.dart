import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/shimmer_container.dart';
import 'package:p2pbookshare/pages/home/widgets/book_card.dart';
import 'package:p2pbookshare/pages/view_book/view_book_screen.dart';
import 'package:p2pbookshare/services/model/book.dart';

class YourBooksListView extends StatelessWidget {
  const YourBooksListView({
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
          return const Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: CustomShimmerContainer(
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
                  return buildCategoryBooksWidget(context, bookData);
                }
              },
            ),
          );
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
                  completeAddress: bookData['book_exchange_address']),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: BookCard(
            cardHeight: 200,
            cardWidth: 150,
            bookCoverImgurl: bookData['book_coverimg_url'],
            title: bookData['book_title']),
      ),
    ),
  );
}
