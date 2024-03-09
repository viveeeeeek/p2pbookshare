import 'package:flutter/material.dart';

import 'package:p2pbookshare/views/profile/widgets/user_books_grid_view.dart';
import 'package:p2pbookshare/providers/firebase/book_fetch_service.dart';

class UserBooksTab extends StatelessWidget {
  const UserBooksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: UserBooksGridView(
                    context: context,
                    stream: BookFetchService().getUserListedBooks())),
          )
        ],
      ),
    );
  }
}
