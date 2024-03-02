import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/profile/widgets/your_books_listview.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';

class YourBooksTabView extends StatelessWidget {
  const YourBooksTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
