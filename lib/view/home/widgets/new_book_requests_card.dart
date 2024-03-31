import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/view/notifications/notification_view.dart';

class NewBookRequestCard extends StatelessWidget {
  const NewBookRequestCard({super.key, required this.userUid});

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookRequestService>(
      builder: (context, bookRequestService, child) {
        return P2pbookshareStreamBuilder(
            dataStream: bookRequestService
                .countNoOfBookRequestsReceivedAsStream(userUid),
            successBuilder: (data) {
              final _count = data;
              logger.i('No of requests: ${data}');
              if (_count > 0) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: context.primaryContainer.withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Book Requests',
                            style: TextStyle(
                                fontSize: 22,
                                color: context.onPrimaryContainer),
                          ),
                          Text(
                              'You have $_count new borrow request for your books waiting for your approval.',
                              style: TextStyle(
                                  // fontSize: 16,
                                  color: context.onPrimaryContainer)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationView()));
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('View All'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.arrow_forward_rounded)
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      )),
                );
              } else {
                return const SizedBox(
                    // height: 30,
                    );
              }
            },
            waitingBuilder: () {
              return const P2PBookShareShimmerContainer(
                  height: 100, width: double.infinity, borderRadius: 8);
            },
            errorBuilder: (error) {
              return Text('Error: $error');
            });
      },
    );
  }
}
