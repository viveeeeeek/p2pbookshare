import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/widgets/no_requests_widget.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/view/notifications/widgets/notification_card.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
//TODO: Add sort by date

class NotificationView extends StatefulWidget {
  const NotificationView({
    super.key,
  });

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Incoming requests",
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Consumer2<BookFetchService, BookBorrowRequestService>(
                builder:
                    (context, bookFetchServices, bookRequestService, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      //     child: StreamBuilder(
                      //   stream: bookRequestService.fetchNotifications(),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const CircularProgressIndicator();
                      //     } else if (snapshot.hasError) {
                      //       return Center(
                      //           child: Text('Error: ${snapshot.error}'));
                      //     } else if (!snapshot.hasData ||
                      //         snapshot.data!.isEmpty) {
                      //       return const NoRequestsWidget();
                      //     } else if (snapshot.hasData &&
                      //         snapshot.data != null) {
                      //       final bookRequestDocument = snapshot.data!;
                      //       return ListView.builder(
                      //         itemCount: bookRequestDocument.length,
                      //         itemBuilder: (context, index) {
                      //           final bookData = bookRequestDocument[index];
                      //           return NotificationCard(context, bookData);
                      //         },
                      //       );
                      //     } else if (snapshot.hasData &&
                      //         snapshot.data == null) {
                      //       return const Text('No notifications');
                      //     } else {
                      //       return const Text('Something went wrong :/');
                      //     }
                      //   },
                      // ))
                      Expanded(
                        child: P2pbookshareStreamBuilder(
                          dataStream: bookRequestService.fetchNotifications(),
                          successBuilder: (data) {
                            if (data == null || data.isEmpty) {
                              return const NoRequestsWidget();
                            } else {
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final bookData = data[index];
                                  return NotificationCard(context, bookData);
                                },
                              );
                            }
                          },
                          waitingBuilder: () {
                            return const SizedBox();
                          },
                          errorBuilder: (error) {
                            return Center(child: Text('Error: $error'));
                          },
                        ),
                      ),
                    ],
                  );
                },
              )),
        ));
  }
}
