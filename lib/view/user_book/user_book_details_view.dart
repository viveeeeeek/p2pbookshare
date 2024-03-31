import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/borrow_req_detail_card.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/provider/firebase/book_listing_service.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view/chat/chat_view.dart';
import 'package:p2pbookshare/view/request_book/widgets/book_info_card.dart';
import 'package:p2pbookshare/view_model/user_book_details_viewmodel.dart';

import 'widgets/widgets.dart';

//FIXME: Add confirmation dialog before accepting the book request alerting that all other requests would be rejected automatically.
class UserBookDetailsView extends StatefulWidget {
  const UserBookDetailsView({
    super.key,
    required this.bookData,
    required this.heroKey,
  });

  final Book bookData;
  final String heroKey;

  @override
  State<UserBookDetailsView> createState() => _UserBookDetailsViewState();
}

class _UserBookDetailsViewState extends State<UserBookDetailsView> {
  FirebaseUserService _firebaseUserService = FirebaseUserService();
  final _userBookDetailsViewModel = UserBookDetailsViewModel();
  String _receiverName = '',
      _receiverId = '',
      _chatRoomId = '',
      _receiverImageUrl = '';

  /// Set the receiver details
  Future<void> setReceiverDetails(String receiverId) async {
    _receiverId = receiverId;
    final userDetails =
        await _firebaseUserService.getUserDetailsById(_receiverId);
    _receiverName = userDetails![UserConstants.displayName];
    _receiverImageUrl = userDetails[UserConstants.profilePictureUrl];
  }

  /// Get the receiver id and chat room id
  /// based on the book request data
  /// and the current user id
  _getReceiverIdAndChatRoomId(Map<String, dynamic> bookRequestdata) async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String bookId = widget.bookData.bookID!;

    if (currentUserUid == bookRequestdata[BorrowRequestConfig.reqBookOwnerID]) {
      await setReceiverDetails(
          bookRequestdata[BorrowRequestConfig.requesterID]);
    } else {
      await setReceiverDetails(
          bookRequestdata[BorrowRequestConfig.reqBookOwnerID]);
    }

    _chatRoomId =
        ChatService.createChatRoomId(bookId, currentUserUid, _receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your book listing details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Consumer2<BookRequestService, BookListingService>(
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                IconButton(
                                  onPressed: () => _userBookDetailsViewModel
                                      .deleteBookListing(
                                          context,
                                          widget.bookData.bookID!,
                                          widget.bookData.bookCoverImageUrl),
                                  icon: Icon(MdiIcons.deleteOutline),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),

                            // Book Detail Card
                            BookDetailsCard(
                              bookData: widget.bookData,
                              cardWidth: 300,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ])),
                        ];
                      },
                      body: StreamBuilder(
                          stream: bookRequestService.checkBookRequestAccepted(
                              widget.bookData.bookID!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Show shimmer container while the data is being fetched
                              return const P2PBookShareShimmerContainer(
                                  height: 150,
                                  width: double.infinity,
                                  borderRadius: 15);
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              final bookRequestdata = snapshot.data!;
                              // Request accepted card if the book request is accepted
                              if (bookRequestdata[
                                      BorrowRequestConfig.reqStatus] ==
                                  'accepted') {
                                _getReceiverIdAndChatRoomId(bookRequestdata);

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      // Chat and complete exchange buttons
                                      StreamBuilder(
                                          stream: bookRequestService
                                              .checkBookRequestAccepted(
                                                  widget.bookData.bookID!),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const P2PBookShareShimmerContainer(
                                                  height: 50,
                                                  width: double.infinity,
                                                  borderRadius: 15);
                                            } else if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              final bookRequestdata =
                                                  snapshot.data!;
                                              if (bookRequestdata[
                                                      BorrowRequestConfig
                                                          .reqStatus] ==
                                                  'accepted') {
                                                if (bookRequestdata[
                                                        BorrowRequestConfig
                                                            .reqBookOwnerID] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      FilledButton(
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(MdiIcons
                                                                  .messageOutline),
                                                              const SizedBox(
                                                                  width: 8),
                                                              const Text(
                                                                'Chat borrower',
                                                              )
                                                            ]),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return ChatView(
                                                              receiverId:
                                                                  _receiverId,
                                                              receiverName:
                                                                  _receiverName,
                                                              receiverimgUrl:
                                                                  _receiverImageUrl,
                                                              chatRoomId:
                                                                  _chatRoomId,
                                                              bookId: widget
                                                                  .bookData
                                                                  .bookID!,
                                                            );
                                                          }));
                                                        },
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Complete exchange'),
                                                                  content:
                                                                      const Text(
                                                                          'Marking this exchange complete will relist the book and delete the borrow request and associated chat.\n\nAre you sure you want to proceed?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        _userBookDetailsViewModel.completeBookExchange(
                                                                            context:
                                                                                context,
                                                                            chatRoomID:
                                                                                _chatRoomId,
                                                                            bookID:
                                                                                widget.bookData.bookID!,
                                                                            bookRequestID: bookRequestdata[BorrowRequestConfig.reqID]);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Confirm'),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: const Text(
                                                            'Complete exchange'),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              } else {
                                                return const SizedBox();
                                              }
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),

                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Text(
                                        'Ongoing exchange request details',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Current exchange request details
                                      CurrentRequestDetails(
                                          bookRequestModel:
                                              BorrowRequest.fromMap(
                                                  bookRequestdata)),
                                    ],
                                  ),
                                );
                              } else {
                                // Incoming borrow requests listview
                                return IncomingReqListView(
                                    widget: widget,
                                    receiverName: _receiverName,
                                    bookRequestService: bookRequestService,
                                    userBookDetailsViewModel:
                                        _userBookDetailsViewModel);
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
