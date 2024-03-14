import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class P2PBookShareShimmerContainer extends StatelessWidget {
  final double height, width, borderRadius;
  const P2PBookShareShimmerContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
        highlightColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .background, // You can remove this line if not needed
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
          width: width,
        ));
  }
}
