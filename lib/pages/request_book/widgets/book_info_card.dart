// import 'package:flutter/material.dart';
// import 'package:p2pbookshare/services/model/book.dart';

import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/book_model.dart';

class BookDetailsCard extends StatelessWidget {
  final double cardWidth;
  const BookDetailsCard(
      {super.key,
      required this.bookData,
      required this.cardWidth,
      required this.crossAxisAlignment,
      this.mainAxisAlignment});

  final BookModel bookData;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          Text(
            bookData.bookTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // color: Theme.of(context).colorScheme.onSecondaryContainer
            ),
          ),
          Text(
            bookData.bookAuthor,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          bookData.bookPublication != null
              ? Text(
                  bookData.bookPublication!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

// class BookDetailsCard extends StatelessWidget {
//   final double cardWidth;
//   const BookDetailsCard(
//       {super.key, required this.bookData, required this.cardWidth});

//   final BookModel bookData;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: cardWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             bookData.bookTitle,
//             style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.onSecondaryContainer),
//           ),
//           Text(
//             bookData.bookAuthor,
//             style: TextStyle(
//                 fontSize: 14,
//                 color: Theme.of(context).colorScheme.onSecondaryContainer),
//           ),
//           bookData.bookPublication != null
//               ? Text(
//                   bookData.bookPublication!,
//                   style: TextStyle(
//                       fontSize: 14,
//                       color:
//                           Theme.of(context).colorScheme.onSecondaryContainer),
//                 )
//               : const SizedBox()
//         ],
//       ),
//     );
//   }
// }
