import 'dart:async';

import 'package:flutter/material.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/global/constants/app_constants.dart';
import 'package:p2pbookshare/pages/home/widgets/category_book_list.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget buildCategorizedBookList(BuildContext context, String genre) {
    return Consumer<BookFetchService>(
      builder: (context, bookFetchServices, _) {
        return CategorizedBookList(
          context: context,
          stream: bookFetchServices.getCategoryWiseBooks(genre),
        );
      },
    );
  }

  late StreamSubscription<bool> subscription;
  bool _hasDocuments = false;

  @override
  void initState() {
    super.initState();
    subscription = BookRequestService()
        .hasBookRequests('book_requests')
        .listen((hasDocuments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // your state change goes here
          _hasDocuments = hasDocuments;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel(); // Cleanup the stream subscription
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
          child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //       icon: Icon(MdiIcons.bellOutline),
        //       onPressed: () {},
        //     )
        //   ],
        // ),
        body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text: 'Welcome,\n',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                userDataProvider.userModel!.userName ?? 'User',
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]))
              ];
            },
            body: Column(
              children: [
                /// Card widget to show alert of new book requests
                /// Calculate total number of requests and based on that show dynamic title 'You have x new book requests'
                if (_hasDocuments)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      // height: 300,
                      width: constraints.maxWidth,
                      child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'New Book Requests',
                                  style: TextStyle(fontSize: 22),
                                ),
                                Text(
                                  'You have {bookRequestService.notificationCount} new  borrow request for your books waiting for your approval.',
                                  style: TextStyle(color: context.onSurface),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FilledButton(
                                        onPressed: () {},
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
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ! Categorized book listview
                        for (String genre in AppConstants.bookGenres)
                          buildCategorizedBookList(context, genre),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      )),
    );
  }
}
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   Widget buildCategorizedBookList(BuildContext context, String genre) {
//     return Consumer<BookFetchService>(
//       builder: (context, bookFetchServices, _) {
//         return CategorizedBookList(
//           context: context,
//           stream: bookFetchServices.getCategoryWiseBooks(genre),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final userDataProvider = Provider.of<UserDataProvider>(context);
//     final bookRequestService = Provider.of<BookRequestService>(context);

//     return LayoutBuilder(
//       builder: (context, constraints) => SafeArea(
//         child: Scaffold(
//             // appBar: AppBar(
//             //   elevation: 0,
//             //   actions: [
//             //     IconButton(
//             //       icon: Icon(MdiIcons.bellOutline),
//             //       onPressed: () {},
//             //     )
//             //   ],
//             // ),
//             body: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
//                     child: Column(
//                       children: [
//                         /// Welcome Text and Notification Icon
//                         Text.rich(
//                           TextSpan(
//                             children: <InlineSpan>[
//                               const TextSpan(
//                                 text: 'Welcome,\n',
//                                 style: TextStyle(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: userDataProvider.userModel!.userName ??
//                                     'User',
//                                 style: const TextStyle(
//                                   fontSize: 25,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),

//                   /// Card widget to show alert of new book requests
//                   /// Calculate total number of requests and based on that show dynamic title 'You have x new book requests'
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: SizedBox(
//                       // height: 300,
//                       width: constraints.maxWidth,
//                       child: Card(
//                           elevation: 4,
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'New Book Requests',
//                                   style: TextStyle(fontSize: 22),
//                                 ),
//                                 Text(
//                                   'You have 3 new  borrow request for your books waiting for your approval.',
//                                   style: TextStyle(color: context.onSurface),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     FilledButton(
//                                         onPressed: () {},
//                                         child: const Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text('View All'),
//                                             SizedBox(
//                                               width: 10,
//                                             ),
//                                             Icon(Icons.arrow_forward_rounded)
//                                           ],
//                                         ))
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )
//                           //  P2pbookshareStreamBuilder(
//                           //   dataStream:
//                           //       bookRequestService.fetchIncomingBookRequests(),
//                           //   successBuilder: (data) {
//                           //     final bookRequestDocument = data;
//                           //     return ListView.builder(
//                           //       itemCount: bookRequestDocument.length,
//                           //       itemBuilder: (context, index) {
//                           //         final bookData = bookRequestDocument[index];
//                           //         return BookRequestNotificationCard(
//                           //             context, bookData);
//                           //       },
//                           //     );
//                           //   },
//                           //   waitingBuilder: () {
//                           //     return const CircularProgressIndicator();
//                           //   },
//                           //   errorBuilder: (error) {
//                           //     return Center(child: Text('Error: $error'));
//                           //   },
//                           // ),
                      
//                           ),
//                     ),
//                   ),

           
//                   // ! Categorized book listview
//                   for (String genre in AppConstants.bookGenres)
//                     buildCategorizedBookList(context, genre),
//                 ],
//               ),
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }
