import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/global/constants/app_constants.dart';
import 'package:p2pbookshare/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/providers/userdata_provider.dart';

import 'widgets/widgets.dart';

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
          currentUserID:
              Provider.of<UserDataProvider>(context).userModel!.userUid!,
        );
      },
    );
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
                    body: NestedScrollView(headerSliverBuilder: (context, _) {
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
            }, body:
                        // Stack(
                        //   children: [
                        //     /// Expanded widget to show categorized book list
                        //     /// This will show list of books based on their genre
                        //     /// The list is scrollable and can be scrolled horizontally
                        //     Expanded(
                        //       child: SingleChildScrollView(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             const SizedBox(
                        //               height: 15,
                        //             ),
                        //             // ! Categorized book listview
                        //             for (String genre in AppConstants.bookGenres)
                        //               buildCategorizedBookList(context, genre),
                        //           ],
                        //         ),
                        //       ),
                        //     ),

                        //     /// Card widget to show alert of new book requests
                        //     /// Calculate total number of requests and based on that show dynamic title 'You have x new book requests'
                        //     // if (bookRequestService.isBookRequestAvailable)
                        //     //   const NewBookRequestsCard(),
                        //     Positioned(
                        //       bottom: 0,
                        //       right: 0,
                        //       left: 0,
                        //       child: Consumer<BookRequestHandlingService>(
                        //         builder: (context, bookRequesthandlingService, child) {
                        //           return P2pbookshareStreamBuilder(
                        //               dataStream: bookRequesthandlingService
                        //                   .hasBookRequestsForCurrentUser('book_requests',
                        //                       userDataProvider.userModel!.userUid!),
                        //               successBuilder: (data) {
                        //                 if (data != null && data != false) {
                        //                   logger.info('Streambuilder data success: $data');
                        //                   return NewBookRequestsCard(
                        //                     userUid: userDataProvider.userModel!.userUid!,
                        //                   );
                        //                 } else {
                        //                   return const SizedBox();
                        //                 }
                        //               },
                        //               waitingBuilder: () {
                        //                 return const Padding(
                        //                   padding: EdgeInsets.all(20.0),
                        //                   child: CustomShimmerContainer(
                        //                       height: 125,
                        //                       width: double.infinity,
                        //                       borderRadius: 8),
                        //                 );
                        //               },
                        //               errorBuilder: (error) {
                        //                 return Text('Error: $error');
                        //               });
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // )),
                        Consumer<BookRequestHandlingService>(
              builder: (context, bookRequesthandlingService, child) {
                //FIXME: Use of p2pbooksharestreambuilder
                return StreamBuilder(
                  stream:
                      bookRequesthandlingService.hasBookRequestsForCurrentUser(
                    'book_requests',
                    userDataProvider.userModel!.userUid!,
                  ),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    bool hasData = snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data != false;
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: hasData
                                  ? 150
                                  : 0), // Adjust this value as needed
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // ! Categorized book listview
                                  for (String genre in AppConstants.bookGenres)
                                    buildCategorizedBookList(context, genre),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (hasData)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: NewBookRequestsCard(
                              userUid: userDataProvider.userModel!.userUid!,
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            )))));
  }
}
