import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/pages/profile/views/requests_notification/widgets/request_notification_card.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:provider/provider.dart';

class NotifListView extends StatefulWidget {
  const NotifListView({
    super.key,
  });

  @override
  NotifListViewState createState() => NotifListViewState();
}

class NotifListViewState extends State<NotifListView> {
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
        }, body: Consumer2<BookFetchService, BookRequestService>(
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
                    dataStream: bookRequestService.fetchIncomingBookRequests(),
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
                ),
              ],
            );
          },
        )),
      ),
    ));
  }
}

// class BookTile extends StatelessWidget {
//   final Map<String, dynamic> bookData;

//   const BookTile({
//     Key? key,
//     required this.bookData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(5)),
//         child: Hero(
//           tag: '${bookData['book_coverimg_url']}-searchscreen',
//           child: SizedBox(
//             width: 40,
//             height: 60,
//             child: CachedImage(imageUrl: bookData['book_coverimg_url']),
//           ),
//         ),
//       ),
//       title: Text(bookData['book_title']),
//       subtitle: Text(bookData['book_author']),
//       onTap: () {},
//     );
//   }
// }
