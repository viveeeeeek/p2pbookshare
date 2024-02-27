import 'package:flutter/material.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:p2pbookshare/pages/home/widgets/book_card.dart';

class AllBooksGrid extends StatelessWidget {
  const AllBooksGrid({
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
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No books found.'));
        } else {
          List<Map<String, dynamic>> booksList = snapshot.data!;
          return GridView.builder(
            shrinkWrap: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Change to 3 for three items per row
              crossAxisSpacing: 10, // Adjust spacing as needed
              mainAxisSpacing: 10, // Adjust spacing as needed
              childAspectRatio: 0.88, // Maintain 1:1 aspect ratio
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: booksList.length,
            itemBuilder: (context, index) {
              return buildBookWidget(booksList[index]);
            },
          );
        }
      },
    );
  }
}

Widget buildBookWidget(Map<String, dynamic> bookData) {
  return BookCard(
      cardHeight: 200,
      cardWidth: 150,
      bookCoverImgurl: bookData['book_coverimg_url'],
      title: bookData['book_title']);
  // return Stack(
  //   children: [
  //     ClipRRect(
  //       borderRadius: const BorderRadius.all(Radius.circular(15)),
  //       child: SizedBox(
  //         height: 180,
  //         width: 150,
  //         child: CachedImage(
  //           imageUrl: bookData['book_coverimg_url'],
  //         ),
  //       ),
  //     ),
  //     Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             bookData['book_title'],
  //             style: const TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             bookData['book_author'],
  //             style: const TextStyle(
  //               fontSize: 13,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ]),
  //   ],
  // );
}
