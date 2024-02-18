import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';

class BookCard extends StatelessWidget {
  final String bookCoverImgurl;
  final String title;

  const BookCard({
    Key? key,
    required this.bookCoverImgurl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate aspect ratio based on the outer SizedBox dimensions

    return SizedBox(
      height: 210,
      width: 150,
      child: Hero(
        tag: bookCoverImgurl,
        child: Card(
          elevation: 3, // Adjust the elevation as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CachedImage(bookCoverImgUrl: bookCoverImgurl)),
                ),
                Text(
                  title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
