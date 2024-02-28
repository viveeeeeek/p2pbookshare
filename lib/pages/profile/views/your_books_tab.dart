import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/all_books/widgets/all_books_grid.dart';
import 'package:p2pbookshare/pages/profile/profile_handler.dart';

class YourBooksTabView extends StatelessWidget {
  const YourBooksTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Placeholder()
                // AllBooksGrid(
                //     context: context,
                //     stream: ProfileHandler().getUserBooksStream(context)),
                ),
          )
        ],
      ),
    );
  }
}
