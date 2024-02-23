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
    return Card(
      elevation: 3, // Adjust the elevation as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: 200,
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                // Hero animation with url as unique tag for each book
                child: Hero(
                  tag: bookCoverImgurl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: SizedBox(
                        height: 150,
                        width: 130,
                        child: CachedImage(imageUrl: bookCoverImgurl)),
                  ),
                ),
              ),
              Text(
                title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
