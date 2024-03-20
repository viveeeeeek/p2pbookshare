import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/view/outgoing_req/outgoing_req_details_view.dart';
import 'package:provider/provider.dart';

class OutgoingNotificationTab extends StatelessWidget {
  const OutgoingNotificationTab({super.key, required this.currentUseruid});
  final String currentUseruid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: Consumer<BookRequestService>(
              builder: (context, bookRequestHandlingService, child) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: bookRequestHandlingService
                            .getBooksRequestedByCurrentUser(currentUseruid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No books found.'));
                          } else {
                            List<Map<String, dynamic>> booksList =
                                snapshot.data!;
                            logger.info('BooksList: $booksList');
                            return GridView.builder(
                              shrinkWrap: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    3, // Change to 3 for three items per row
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio:
                                    0.77, // Maintain 1:1 aspect ratio
                              ),
                              physics: const ClampingScrollPhysics(),
                              itemCount: booksList.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                    future: BookFetchService()
                                        .getBookDetailsById(booksList[index]
                                            [BorrowRequestConfig.reqBookID]),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const P2PBookShareShimmerContainer(
                                            height: 200,
                                            width: double.infinity,
                                            borderRadius: 15);
                                      } else if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        Map<String, dynamic> bookData =
                                            snapshot.data!;
                                        logger.info('BookData: $bookData');
                                        return FutureBuilder(
                                            future: BookRequestService()
                                                .getRequestDetailsByID(
                                                    booksList[index][
                                                        BorrowRequestConfig
                                                            .reqID]),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const P2PBookShareShimmerContainer(
                                                    height: 200,
                                                    width: double.infinity,
                                                    borderRadius: 15);
                                              } else if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                final bookRequestData =
                                                    snapshot.data!;
                                                logger.info(
                                                    '⚓⚓BookRequestData: $bookRequestData');
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OutgoingReqDetailsView(
                                                          bookrequestModel:
                                                              BorrowRequest(
                                                            reqBookID: bookRequestData[
                                                                BorrowRequestConfig
                                                                    .reqBookID],
                                                            reqBookOwnerID:
                                                                bookRequestData[
                                                                    BorrowRequestConfig
                                                                        .reqBookOwnerID],
                                                            requesterID:
                                                                bookRequestData[
                                                                    BorrowRequestConfig
                                                                        .requesterID],
                                                            reqBookStatus:
                                                                bookRequestData[
                                                                    BorrowRequestConfig
                                                                        .reqBookStatus],
                                                            reqEndDate: bookRequestData[
                                                                BorrowRequestConfig
                                                                    .reqEndDate],
                                                            reqStartDate:
                                                                bookRequestData[
                                                                    BorrowRequestConfig
                                                                        .reqStartDate],
                                                            reqID: bookRequestData[
                                                                BorrowRequestConfig
                                                                    .reqID],
                                                            reqStatus: bookRequestData[
                                                                BorrowRequestConfig
                                                                    .reqStatus],
                                                            timestamp: bookRequestData[
                                                                BorrowRequestConfig
                                                                    .timestamp],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(6)),
                                                    child: CachedImage(
                                                      imageUrl: bookData[
                                                          BookConfig
                                                              .bookCoverImageUrl],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const Text(
                                                    'Error loading book details');
                                              }
                                            });
                                      } else {
                                        return const Text(
                                            'Error loading book details');
                                      }
                                    });
                              },
                            );
                          }
                        }));
              },
            ),
          )
        ],
      ),
    );
  }
}
