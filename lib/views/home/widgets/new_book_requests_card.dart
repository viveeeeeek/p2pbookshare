import 'package:flutter/material.dart';
import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/views/notifications/notification_view.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/global/utils/extensions/color_extension.dart';
import 'package:p2pbookshare/providers/firebase/book_request_service.dart';

class NewBookRequestsCard extends StatelessWidget {
  const NewBookRequestsCard({super.key, required this.userUid});

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookRequestHandlingService>(
      builder: (context, bookRequestService, child) {
        return P2pbookshareStreamBuilder(
            dataStream: bookRequestService
                .countNoOfBookRequestsReceivedAsStream(userUid),
            successBuilder: (data) {
              final _count = data;
              logger.info('No of requests: ${data}');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  // height: 300,
                  width: double.infinity,
                  child: Card(
                      elevation: 4,
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   _count! > 1
                              //       ? 'New Book Requests'
                              //       : 'New Book Request',
                              //   style: const TextStyle(fontSize: 22),
                              // ),
                              // Text(
                              //   _count > 1
                              //       ? 'You have $_count new borrow requests for your books waiting for your approval.'
                              //       : 'You have $_count new borrow request for your books waiting for your approval.',
                              //   style: TextStyle(color: context.onSurface),
                              // ),
                              const Text(
                                'New Book Request',
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                'You have $_count new borrow request for your books waiting for your approval.',
                                style: TextStyle(color: context.onSurface),
                              ),
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
                          ))),
                ),
              );
            },
            waitingBuilder: () {
              return const CustomShimmerContainer(
                  height: 100, width: double.infinity, borderRadius: 8);
            },
            errorBuilder: (error) {
              return Text('Error: $error');
            });
      },
    );
  }
}
