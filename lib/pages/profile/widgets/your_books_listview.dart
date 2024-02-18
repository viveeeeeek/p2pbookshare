import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:p2pbookshare/pages/profile/widgets/shimmer_card.dart';
import 'package:p2pbookshare/pages/yourbook/yourbook_view.dart';

Widget yourBooksListView(
  BuildContext context,
  Stream<List<Map<String, dynamic>>> stream,
) {
  return StreamBuilder<List<Map<String, dynamic>>>(
      //// Using stream to conitinously listen userBooksStream from firebase
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return shimmerCardNoInternet(context, 'No books added');
        } else {
          List<Map<String, dynamic>> booksList = snapshot.data!;
          //// Create a placeholder item for the extra space
          final placeholderItem = {'isPlaceholder': true};
          //// Add the placeholder item at the beginning of the list
          booksList.insert(0, placeholderItem);

          return SizedBox(
            //! Set a specific height for the horizontal list
            height: 200,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: booksList.length,
              itemBuilder: (context, index) {
                if (booksList[index]['isPlaceholder'] == true) {
                  //// Render the placeholder item for extra spacing at start (left side)
                  return const SizedBox(width: 20);
                } else {
                  Map<String, dynamic> bookData = booksList[index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        YourBookDetailedScreen(
                                          bookTitle: bookData['book_title'],
                                          bookAuthor: bookData["book_author"],
                                          bookCoverUrl:
                                              bookData['book_coverimg_url'],
                                          bookPublication:
                                              bookData['book_publication'],
                                          bookCondition:
                                              bookData['book_condition'],
                                        )));
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 200, // Adjust the height as needed
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: CachedImage(
                                            bookCoverImgUrl:
                                                bookData['book_coverimg_url'])),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    //! This added height to gradient overlaps the gap
                                    height: 200,
                                    width: 150,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookData['book_title'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          bookData['book_author'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
      });
}
