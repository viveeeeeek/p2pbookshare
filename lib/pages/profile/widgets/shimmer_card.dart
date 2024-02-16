import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Shimmer.fromColors(
      baseColor:
          Theme.of(context).cardColor.withOpacity(0.6), // Shimmer base color
      highlightColor: Theme.of(context)
          .colorScheme
          .primary
          .withOpacity(0.3), // Shimmer highlight color:

      child: SizedBox(
        height: 200,
        width: 400,
        child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
      ),
    ),
  );
}

Widget shimmerCardNoInternet(BuildContext context, String shimmerText) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: SizedBox(
      height: 200,
      width: 400,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).cardColor, // Shimmer base color
              highlightColor: Theme.of(context)
                  .colorScheme
                  .secondary, // Shimmer highlight color:

              child: Text(shimmerText)),
        ),
      ),
    ),
  );
}
