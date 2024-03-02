import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/incoming_book_req_list.dart';
//FIXME: Sort incoming request by time. [recent -> old]

class IncomingBookReqView extends StatelessWidget {
  const IncomingBookReqView({super.key, required this.incomingBookReqStream});

  final Stream<List<Map<String, dynamic>>> incomingBookReqStream;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IncomingBookReqListView(
                  context: context, stream: incomingBookReqStream),
            ),
          )
        ],
      ),
    );
  }
}
