import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/profile/widgets/your_books_listview.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';

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
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: UserBooksGridView(
                    context: context,
                    stream: BookFetchService().getUserListedBooks())
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
