import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/view/outgoing_req/widgets/req_accepted_card.dart';
import 'package:p2pbookshare/view/request_book/widgets/book_info_card.dart';
import 'package:p2pbookshare/model/book_model.dart';
import 'package:p2pbookshare/provider/firebase/book_listing_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/view_model/user_book_details_viewmodel.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

//FIXME: Add confirmation dialog before accepting the book request alerting that all other requests would be rejected automatically.
class UserBookDetailsView extends StatefulWidget {
  const UserBookDetailsView({
    super.key,
    required this.bookData,
    required this.heroKey,
  });

  final BookModel bookData;
  final String heroKey;

  @override
  State<UserBookDetailsView> createState() => _UserBookDetailsViewState();
}

class _UserBookDetailsViewState extends State<UserBookDetailsView> {
  @override
  Widget build(BuildContext context) {
    final _userBookDetailsViewModel = UserBookDetailsViewModel();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookData.bookTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.deleteOutline),
            onPressed: () => _userBookDetailsViewModel.deleteBookListing(
                context,
                widget.bookData.bookID!,
                widget.bookData.bookCoverImageUrl),
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Consumer2<BookBorrowRequestService, BookListingService>(
                builder:
                    (context, bookRequestService, bookListingService, child) {
                  return NestedScrollView(
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            const SizedBox(
                              height: 25,
                            ),
                            // Book cover image & details card
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 180,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 4),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Hero(
                                    tag: widget.heroKey,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedImage(
                                        imageUrl:
                                            widget.bookData.bookCoverImageUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Book Detail Card
                                BookDetailsCard(
                                  bookData: widget.bookData,
                                  cardWidth: double.infinity,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 25,
                            // ),
                            // // Button to delete the book from the database
                            // OutlinedButton(
                            //   onPressed: () =>

                            //   child: const Text('Delete Book'),
                            // ),
                          ])),
                        ];
                      },
                      body: StreamBuilder(
                          stream: bookRequestService.checkBookRequestAccepted(
                              widget.bookData.bookID!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const P2PBookShareShimmerContainer(
                                  height: 150,
                                  width: double.infinity,
                                  borderRadius: 15);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              final bookRequestdata = snapshot.data!;
                              if (bookRequestdata['req_status'] == 'accepted') {
                                return const Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),

                                    /// Container to show ongouing exchange progress
                                    /// with the user who requested the book
                                    /// This container will show the user's details
                                    /// and the status of the book exchange
                                    /// (i.e. if the book is received or not)
                                    /// Show progress bar for exchange prorgesss
                                    ///
                                    // Container(
                                    //   child: Column(children: [
                                    //     const Text(
                                    //       'Ongoing Exchange',
                                    //       style: TextStyle(
                                    //         fontSize: 18,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(
                                    //       height: 10,
                                    //     ),
                                    //     StreamBuilder(
                                    //         stream: bookRequestService
                                    //             .fetchAcceptedRequestForBook(
                                    //                 widget.bookData.bookID!),
                                    //         builder: (context, snapshot) {
                                    //           if (snapshot.connectionState ==
                                    //               ConnectionState.waiting) {
                                    //             return const P2PBookShareShimmerContainer(
                                    //                 height: 150,
                                    //                 width: double.infinity,
                                    //                 borderRadius: 15);
                                    //           } else if (snapshot.hasData &&
                                    //               snapshot.data != null) {
                                    //             final bookRequestData =
                                    //                 snapshot.data!;
                                    //             return ListView.builder(
                                    //               scrollDirection:
                                    //                   Axis.vertical,
                                    //               itemCount:
                                    //                   bookRequestData.length,
                                    //               itemBuilder: (context, index) {
                                    //                 final bookData =
                                    //                     bookRequestData[index];
                                    //                 return buildOngoingExchangeCard(
                                    //                     context: context,
                                    //                     bookRequestData: bookData,
                                    //                     onBookReceived: () =>
                                    //                         _userBookDetailsViewModel
                                    //                             .markBookReceived(
                                    //                                 context,
                                    //                                 bookData[
                                    //                                     'req_id']));
                                    //               },
                                    //             );
                                    //           } else {
                                    //             return const SizedBox();
                                    //           }
                                    //         }),]),
                                    // ),
                                    ReqAcceptedCard(),
                                  ],
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Incoming requests title
                                    // StreamBuilder(
                                    //     stream:
                                    //         bookRequestService.isRequestsAvailableForBook(
                                    //             widget.bookData.bookID!),
                                    //     builder: (context, snapshot) {
                                    //       if (snapshot.hasData && snapshot.data == true) {
                                    //         return const Padding(
                                    //           padding: EdgeInsets.only(bottom: 10),
                                    // child: Text(
                                    //   'Incoming Requests',
                                    //   style: TextStyle(
                                    //     fontSize: 18,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    //         );
                                    //       } else {
                                    //         return const SizedBox();
                                    //       }
                                    //     }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Incoming Requests',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: StreamBuilder(
                                      stream: bookRequestService
                                          .fetchRequestsForBook(
                                              widget.bookData.bookID!),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const P2PBookShareShimmerContainer(
                                              height: 150,
                                              width: double.infinity,
                                              borderRadius: 15);
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const NoRequestsWidget();
                                        } else if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          final bookRequestData =
                                              snapshot.data!;
                                          return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: bookRequestData.length,
                                            itemBuilder: (context, index) {
                                              final bookData =
                                                  bookRequestData[index];
                                              return incomingRequestCard(
                                                  context: context,
                                                  bookRequestData: bookData,
                                                  onAccept: () =>
                                                      _userBookDetailsViewModel
                                                          .acceptIncomingBookRequest(
                                                              context,
                                                              bookData[
                                                                  'req_id'],
                                                              widget.bookData
                                                                  .bookID!),
                                                  onDecline: () =>
                                                      _userBookDetailsViewModel
                                                          .rejectIncomingBookRequest(
                                                              context,
                                                              bookData[
                                                                  'req_id']));
                                            },
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    )),
                                  ],
                                );
                              }
                            } else {
                              return Text(
                                  'Error: ${snapshot.error.toString()}');
                            }
                          }));
                },
              ))),
    );
  }
}
