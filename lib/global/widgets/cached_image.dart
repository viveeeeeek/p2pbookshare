import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String bookCoverImgUrl;

  const CachedImage({
    Key? key,
    required this.bookCoverImgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: bookCoverImgUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
        highlightColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
        child: Material(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const SizedBox(
            width: 100.0,
            height: 100.0,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.red, // Placeholder for error case
      ),
    );
  }
}
