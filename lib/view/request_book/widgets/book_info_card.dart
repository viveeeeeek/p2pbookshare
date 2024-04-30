// import 'package:flutter/material.dart';
// import 'package:p2pbookshare/services/model/book.dart';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:p2pbookshare/model/book.dart';

class BookDetailsCard extends StatelessWidget {
  final double cardWidth;
  const BookDetailsCard(
      {super.key,
      required this.bookData,
      required this.cardWidth,
      required this.crossAxisAlignment,
      this.mainAxisAlignment});

  final Book bookData;
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
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
