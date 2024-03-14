import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';

Widget buildCategoryAndGenre(
    {required BuildContext context,
    required int bookRating,
    required String bookGenre,
    required String bookCondition}) {
  return IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(
              Icons.category_outlined,
              color: context.onSecondaryContainer,
              size: 20,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              bookGenre,
            )
          ],
        ),
        //
        SizedBox(
          height: 25,
          child: VerticalDivider(
            color: context.surfaceVariant, // Adjust color as needed
            thickness: 1.3, // Adjust thickness as needed
          ),
        ),
        Column(
          children: [
            Icon(
              MdiIcons.starOutline,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              size: 20,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              bookRating.toString(),
            )
          ],
        ),
        SizedBox(
          height: 25,
          child: VerticalDivider(
            color: context.surfaceVariant, // Adjust color as needed
            thickness: 1.3, // Adjust thickness as needed
          ),
        ),
        Column(
          children: [
            Icon(
              Icons.check_outlined,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              size: 20,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              bookCondition,
            )
          ],
        ),
      ],
    ),
  );
}
