// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';

Widget buildBookCoverImg({
  required BuildContext context,
  required String heroKey,
  required String bookCoverImageUrl,
}) {
  return Center(
    child: Container(
      height: 180,
      width: 130,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 5,
          ),
        ],
      ),
      child: Hero(
        tag: heroKey,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedImage(
              imageUrl: bookCoverImageUrl,
            )),
      ),
    ),
  );
}
