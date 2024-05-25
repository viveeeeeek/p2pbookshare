// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/widgets/no_requests_widget.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/services/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/services/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/view/notifications/widgets/notification_card.dart';

//TODO: Add sort by date
//FIXME: There are multiple heroes that share the same tag within a subtree. use onwer name inside key

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
              child: Consumer2<BookFetchService, BookRequestService>(
                builder:
                    (context, bookFetchServices, bookRequestService, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
