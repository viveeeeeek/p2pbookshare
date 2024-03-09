import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/app_init_handler.dart';

import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book_model.dart';
import 'package:p2pbookshare/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/providers/firebase/user_service.dart';
import 'package:p2pbookshare/views/user_book/user_book_details_view.dart';

Widget NotificationCard(
    BuildContext context, Map<String, dynamic> bookRequestDocument) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: BookFetchService()
        .getBookDetailsById(bookRequestDocument['req_book_id']),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Return a loading indicator if data is still being fetched
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomShimmerContainer(
              height: 100, width: double.infinity, borderRadius: 15),
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        // Handle the error or the case where no matching book is found
        return const Text('Error loading book details');
      } else {
        // Access the book details from the snapshot
        Map<String, dynamic> bookData = snapshot.data!;

        return FutureBuilder(
            future: FirebaseUserService()
                .getUserDetailsById(bookRequestDocument['reqeuster_id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  Map<String, dynamic> userData = snapshot.data!;
                  logger.info('User data: $userData');
                  return ListTile(
                    leading: Hero(
                      tag:
                          '${bookData['book_coverimg_url']}-request_notification_card',
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        child: SizedBox(
                            height: 60,
                            width: 40,
                            child: CachedImage(
                              imageUrl: bookData['book_coverimg_url'],
                            )),
                      ),
                    ),
                    title: Text(bookData['book_title']),
                    // subtitle: Text(
                    //   '${Utils.formatDateTime(bookRequestDocument['req_timestamp'])}',
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
                              userData['username'].toLowerCase(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(MdiIcons.clockTimeOneOutline, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              '${Utils.formatDateTime(bookRequestDocument['req_timestamp'])}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(MdiIcons.arrowRight),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UserBookDetailsView(
                            bookData: BookModel(
                                bookTitle: bookData['book_title'],
                                bookAuthor: bookData['book_author'],
                                bookPublication: bookData['book_publication'],
                                bookCondition: bookData['book_condition'],
                                bookGenre: bookData['book_genre'],
                                bookAvailability: bookData['book_availability'],
                                bookCoverImageUrl:
                                    bookData['book_coverimg_url'],
                                bookOwnerID: bookData['book_owner'],
                                bookID: bookData['book_id'],
                                location: bookData[
                                    'book_exchange_location'], // Directly access GeoPoint
                                bookRating: bookData['book_rating'],
                                completeAddress:
                                    bookData['book_exchange_address']),
                            heroKey:
                                '${bookData['book_coverimg_url']}-request_notification_card',
                          );
                        }));
                      },
                    ),
                  );
                } else {
                  return const Text('Error loading user details');
                }
              } else {
                return const CircularProgressIndicator();
              }
            });
      }
    },
  );
}
