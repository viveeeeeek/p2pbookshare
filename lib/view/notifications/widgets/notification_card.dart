// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/extensions/timestamp_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/services/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';
import 'package:p2pbookshare/view/user_book/user_book_details_view.dart';

final _navigateToUserBookDetailsView =
    ({required BuildContext context, required Book bookData}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return UserBookDetailsView(
      bookData: bookData,
      heroKey: '${bookData.bookCoverImageUrl}-request_notification_card',
    );
  }));
};

Widget NotificationCard(
    BuildContext context, Map<String, dynamic> bookRequestDocument) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: BookFetchService()
        .getBookDetailsById(bookRequestDocument[BorrowRequestConfig.reqBookID]),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Return a loading indicator if data is still being fetched
        return const Padding(
          padding: EdgeInsets.all(6.0),
          child: P2PBookShareShimmerContainer(
            height: 85,
            width: double.infinity,
            borderRadius: 15,
          ),
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        // Handle the error or the case where no matching book is found
        return const Text('Error loading book details');
      } else {
        // Access the book details from the snapshot
        Map<String, dynamic> bookData = snapshot.data!;

        return FutureBuilder(
            future: FirebaseUserService().getUserDetailsById(
                bookRequestDocument[BorrowRequestConfig.requesterID]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  Map<String, dynamic> userData = snapshot.data!;
                  logger.i('User data: $userData');
                  final Book _bookData = Book(
                      bookTitle: bookData[BookConfig.bookTitle],
                      bookAuthor: bookData[BookConfig.bookAuthor],
                      bookPublication: bookData[BookConfig.bookPublication],
                      bookCondition: bookData[BookConfig.bookCondition],
                      bookGenre: bookData[BookConfig.bookGenre],
                      bookAvailability: bookData[BookConfig.bookAvailability],
                      bookCoverImageUrl: bookData[BookConfig.bookCoverImageUrl],
                      bookOwnerID: bookData[BookConfig.bookOwnerID],
                      bookID: bookData[BookConfig.bookID],
                      location: bookData[
                          BookConfig.location], // Directly access GeoPoint
                      bookRating: bookData[BookConfig.bookRating],
                      completeAddress: bookData[BookConfig.completeAddress]);
                  final Timestamp _reqTimeStamp =
                      bookRequestDocument[BorrowRequestConfig.timestamp];
                  return GestureDetector(
                    onTap: () => _navigateToUserBookDetailsView(
                        context: context, bookData: _bookData),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Hero(
                        tag:
                            '${bookData[BookConfig.bookCoverImageUrl]}-request_notification_card',
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          child: SizedBox(
                              height: 60,
                              width: 40,
                              child: CachedImage(
                                imageUrl:
                                    bookData[BookConfig.bookCoverImageUrl],
                              )),
                        ),
                      ),
                      title: Text(bookData[BookConfig.bookTitle]),
                      // subtitle: Text(
                      //   '${Utils.formatDateTime(bookRequestDocument[BookRequestConfig.timestamp])}',
                      // style: const TextStyle(fontSize: 12),
                      // ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(MdiIcons.accountOutline, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                userData[UserConstants.displayName]
                                    .toLowerCase(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(MdiIcons.clockTimeOneOutline, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                '${_reqTimeStamp.toDateTime()}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(MdiIcons.arrowRight),
                        onPressed: () => _navigateToUserBookDetailsView(
                            context: context, bookData: _bookData),
                      ),
                    ),
                  );
                } else {
                  return const Text('Error loading user details');
                }
              } else {
                return const SizedBox();
              }
            });
      }
    },
  );
}
