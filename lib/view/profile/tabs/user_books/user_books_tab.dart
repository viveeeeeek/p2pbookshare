// Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';

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
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: BookFetchService().getUserListedBooks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Center(child: Text('No books found.'));
                    } else {
                      List<Map<String, dynamic>> booksList = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: false,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              3, // Change to 3 for three items per row
                          crossAxisSpacing: 8, // Adjust spacing as needed
                          mainAxisSpacing: 8, // Adjust spacing as needed
                          childAspectRatio: 0.77, // Maintain 1:1 aspect ratio
                        ),
                        physics: const ClampingScrollPhysics(),
                        itemCount: booksList.length,
                        itemBuilder: (context, index) {
                          return buildCategoryBooksWidget(
                              context, booksList[index]);
                        },
                      );
                    }
                  },
                )),
          )
        ],
      ),
    );
  }
}

Widget buildCategoryBooksWidget(
    BuildContext context, Map<String, dynamic> bookData) {
  return GestureDetector(
    onTap: () {
      context.pushNamed(AppRouterConstants.userBookDetailsView,
          extra: Book.fromMap(bookData),
          pathParameters: {
            'heroKey': '${bookData[BookConfig.bookCoverImageUrl]}-userbookview'
          });
    },
    child: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: SizedBox(
            height: 180,
            width: 130,
            child: CachedImage(
              imageUrl: bookData[BookConfig.bookCoverImageUrl],
              // borderRadius: const BorderRadius.all(Radius.circular(5)
              // ),
            ),
          ),
        )),
  );
}
