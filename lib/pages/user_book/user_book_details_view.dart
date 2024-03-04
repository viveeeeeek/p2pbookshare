import 'package:flutter/material.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_choices_chips.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/pages/request_book/widgets/book_info_card.dart';
import 'package:p2pbookshare/services/model/book_model.dart';
import 'package:p2pbookshare/services/providers/firebase/book_listing_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:provider/provider.dart';

class UserBookDetailsView extends StatefulWidget {
  const UserBookDetailsView({
    super.key,
    required this.bookData,
    required this.heroKey,
  });

  final BookModel bookData;
  final String heroKey;

  @override
  State<UserBookDetailsView> createState() => _UserBookDetailsViewState();
}

class _UserBookDetailsViewState extends State<UserBookDetailsView> {
  // String currentUserUid = '';

  @override
  Widget build(BuildContext context) {
    // final userDataProvider = Provider.of<UserDataProvider>(context);

    // // final _currentUserUid = userDataProvider.userModel!.userUid!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookData.bookTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Consumer2<BookRequestService, BookListingService>(
                builder:
                    (context, bookRequestService, bookListingService, child) {
                  return NestedScrollView(
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 180,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 4),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Hero(
                                    tag: widget.heroKey,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedImage(
                                        imageUrl:
                                            widget.bookData.bookCoverImageUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Book Detail Card
                                Expanded(
                                  child: BookDetailsCard(
                                    bookData: widget.bookData,
                                    cardWidth: 200,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
                              ],
                            ),
                          ])),
                        ];
                      },
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Button to delete the book from the database
                          FilledButton(
                            onPressed: () async {
                              final _requestExists = await bookRequestService
                                  .requestExists(widget.bookData.bookID!);
                              if (_requestExists) {
                                if (mounted)
                                  Utils.snackBar(
                                      context: context,
                                      message: 'Request exists for this book',
                                      actionLabel: 'Ok',
                                      durationInSecond: 2,
                                      onPressed: () {});
                              } else {
                                await bookListingService.deleteBookListing(
                                    widget.bookData.bookID!,
                                    widget.bookData.bookCoverImageUrl);
                                if (mounted) {
                                  Utils.snackBar(
                                      context: context,
                                      message: 'Deleted Book Successfully',
                                      actionLabel: 'Ok',
                                      durationInSecond: 1,
                                      onPressed: () {});
                                  await Future.delayed(const Duration(
                                      seconds:
                                          1)); // Wait for snackbar to finish
                                  if (mounted) Navigator.pop(context);
                                }
                              }
                            },
                            child: const Text('Delete Book'),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Incoming requests for book',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child:

                                  // AllReqToBooksListview(
                                  //   context: context,
                                  //   stream:
                                  //   bookRequestService.streamAllRequestsToBook(
                                  // widget.bookData.bookID!,
                                  //   ),
                                  // ),
                                  P2pbookshareStreamBuilder(
                            dataStream:
                                bookRequestService.streamAllRequestsToBook(
                                    widget.bookData.bookID!),
                            successBuilder: (data) {
                              final booksList =
                                  data; // Safe access after checking
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ListView.builder(
                                  itemCount: booksList.length,
                                  itemBuilder: (context, index) {
                                    final bookData = booksList[index];
                                    return buildBookRequestWidget(
                                        context, bookData);
                                  },
                                ),
                              );
                            },
                            waitingBuilder: () {
                              return const CustomShimmerContainer(
                                  height: 150,
                                  width: double.infinity,
                                  borderRadius: 15);
                            },
                            errorBuilder: (error) {
                              return Center(child: Text('Error: $error'));
                            },
                            // errorBuilder: Center(child: Text('Error: ${snapshot.error}'));
                          )),
                        ],
                      ));
                },
              ))),
    );
  }
}

Widget buildBookRequestWidget(
    BuildContext context, Map<String, dynamic> bookData) {
  return Container(
    decoration: BoxDecoration(
        color: context.tertiaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: ListTile(
      title: Text(
        bookData['req_book_id'],
        style: TextStyle(color: context.onTertiaryContainer),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookData['req_book_owner_id'],
            style: TextStyle(color: context.onTertiaryContainer),
          ),
          Text(
            Utils.formatDateTime(
              bookData['req_timestamp'],
            ),
            style: TextStyle(color: context.onTertiaryContainer),
          ),
          BookReqChoiceChips(onTapAccept: () {}, onTapDecline: () {})
        ],
      ),
    ),
  );
}
