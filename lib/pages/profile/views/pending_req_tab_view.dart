import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/all_books/widgets/all_books_grid.dart';
import 'package:p2pbookshare/pages/profile/profile_handler.dart';

class PendingReqTabView extends StatelessWidget {
  const PendingReqTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AllBooksGrid(
                  context: context,
                  stream: ProfileHandler().getUserBooksStream(context)),
            ),
          )
        ],
      ),
    );
  }
}
