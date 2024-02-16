import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';

class BookImageStack extends StatelessWidget {
  final String bookImgUrl, bookTitle, bookID;
  const BookImageStack(
      {super.key,
      required this.bookImgUrl,
      required this.bookTitle,
      required this.bookID});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: CachedBookCoverImg(bookCoverImgUrl: bookImgUrl)),

        /// Gradient container
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            //! This added height to gradient overlaps the gap
            height: 200,
            width: 150,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              bookTitle,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  // color: Theme.of(context).colorScheme.secondary,
                  color: Colors.white70),
            ),
          ),
        )
      ],
    );
  }
}
