import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/profile/profile_handler.dart';
import 'package:p2pbookshare/pages/profile/widgets/your_books_listview.dart';

class YourBooksTabView extends StatelessWidget {
  const YourBooksTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Placeholder()
          // YourBooksListView(
          //     context: context,
          //     stream: ProfileHandler().getUserBooksStream(context))
        ],
      ),
    );
  }
}
