// Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/services/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/services/firebase/book_fetch_service.dart';

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
                            return const Center(
                                child: Text('No books requested.'));
                          } else {
                            List<Map<String, dynamic>> booksList =
                                snapshot.data!;
                            logger.i('BooksList: $booksList');
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
                                        logger.i('BookData: $bookData');
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
                                                logger.i(
                                                    '⚓⚓BookRequestData: $bookRequestData');
                                                return GestureDetector(
                                                  onTap: () {
                                                    //       Navigator.push(
                                                    //         context,
                                                    //         MaterialPageRoute(
                                                    //           builder: (context) =>
                                                    //               OutgoingReqDetailsView(
                                                    //             bookrequestModel:
                                                    //                 BorrowRequest(
                                                    //               reqBookID: bookRequestData[
                                                    //                   BorrowRequestConfig
                                                    //                       .reqBookID],
                                                    //               reqBookOwnerID:
                                                    //                   bookRequestData[
                                                    //                       BorrowRequestConfig
                                                    //                           .reqBookOwnerID],
                                                    //               requesterID:
                                                    //                   bookRequestData[
                                                    //                       BorrowRequestConfig
                                                    //                           .requesterID],
                                                    //               reqBookStatus:
                                                    //                   bookRequestData[
                                                    //                       BorrowRequestConfig
                                                    //                           .reqBookStatus],
                                                    //               reqEndDate: bookRequestData[
                                                    //                   BorrowRequestConfig
                                                    //                       .reqEndDate],
                                                    //               reqStartDate:
                                                    //                   bookRequestData[
                                                    //                       BorrowRequestConfig
                                                    //                           .reqStartDate],
                                                    //               reqID: bookRequestData[
                                                    //                   BorrowRequestConfig
                                                    //                       .reqID],
                                                    //               reqStatus: bookRequestData[
                                                    //                   BorrowRequestConfig
                                                    //                       .reqStatus],
                                                    //               timestamp: bookRequestData[
                                                    //                   BorrowRequestConfig
                                                    //                       .timestamp],
                                                    //             ),
                                                    //           ),
                                                    //         ),
                                                    //       );
                                                    // //
                                                    context.pushNamed(
                                                      AppRouterConstants
                                                          .outgoingRequestDetailsView,
                                                      extra:
                                                          BorrowRequest.fromMap(
                                                              bookRequestData),
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
