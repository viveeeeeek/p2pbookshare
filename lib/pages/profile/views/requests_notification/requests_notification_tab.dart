import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import '../../widgets/widgets.dart';
//FIXME: Sort incoming request by time. [recent -> old]

class RequestsNotificationTab extends StatelessWidget {
  const RequestsNotificationTab(
      {super.key, required this.incomingBookReqStream});

  final Stream<List<Map<String, dynamic>>> incomingBookReqStream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // child:
      // IncomingBookReqListView(
      //     context: context, stream: incomingBookReqStream),
      child: P2pbookshareStreamBuilder(
        dataStream: incomingBookReqStream,
        successBuilder: (data) {
          final bookRequestDocument = data;
          return ListView.builder(
            itemCount: bookRequestDocument.length,
            itemBuilder: (context, index) {
              final bookData = bookRequestDocument[index];
              return BookRequestNotificationCard(context, bookData);
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
    );
  }
}
