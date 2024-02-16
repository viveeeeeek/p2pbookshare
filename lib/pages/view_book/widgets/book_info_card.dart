import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/book.dart';

class BookDetailsCard extends StatelessWidget {
  final double cardWidth;
  const BookDetailsCard(
      {super.key, required this.bookData, required this.cardWidth});

  final Book bookData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      // decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.secondaryContainer,
      //     borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            bookData.bookTitle,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          Text(
            bookData.bookAuthor,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),

          Text(
            bookData.bookPublication,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          // ),
          const SizedBox(
            height: 35,
          ),
          //! Category
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  Icons.category_outlined,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Genre',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(bookData.bookCategory)
                ],
              ),
              const Spacer(),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Condition',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(bookData.bookCondition)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
