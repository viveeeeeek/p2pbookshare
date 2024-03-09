import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/views/notifications/widgets/notification_card.dart';
import 'package:p2pbookshare/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/providers/firebase/book_request_service.dart';
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
        // appBar: const PreferredSize(
        //   preferredSize: Size.fromHeight(toolbarHeight),
        //   child: SearchAppBar(),
        // ),
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: NestedScrollView(headerSliverBuilder: (cpntext, _) {
          return [
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(
                height: 20,
              )
            ]))
          ];
        }, body: Consumer2<BookFetchService, BookRequestHandlingService>(
          builder: (context, bookFetchServices, bookRequestService, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Incoming requests",
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: P2pbookshareStreamBuilder(
                    dataStream: bookRequestService.fetchNotifications(),
                    successBuilder: (data) {
                      final bookRequestDocument = data;
                      return ListView.builder(
                        itemCount: bookRequestDocument.length,
                        itemBuilder: (context, index) {
                          final bookData = bookRequestDocument[index];
                          return NotificationCard(context, bookData);
                        },
                      );
                    },
                    waitingBuilder: () {
                      return const CircularProgressIndicator();
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
      ),
    ));
  }
}
