import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';

class BookCard extends StatelessWidget {
  final String heroKey, imageUrl;
  final String title;
  final double cardHeight, cardWidth;

  const BookCard({
    Key? key,
    required this.heroKey,
    required this.title,
    required this.cardHeight,
    required this.cardWidth,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Adjust the elevation as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: cardHeight,
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                // Hero animation with url as unique tag for each book
                child: Hero(
                  tag: heroKey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: SizedBox(
                        height: cardHeight - 50,
                        width: cardWidth - 20,
                        child: CachedImage(imageUrl: imageUrl)),
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
