// import 'package:flutter/material.dart';
// import 'package:p2pbookshare/services/model/book.dart';

import 'package:flutter/material.dart';
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
          // Text(
          //   bookData.bookTitle,
          //   style: context.titleLarge,
          // ),
          // Text(
          //   bookData.bookAuthor,
          //   style: context.labelLarge,
          // ),
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
