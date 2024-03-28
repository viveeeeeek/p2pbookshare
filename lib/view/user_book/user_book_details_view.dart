import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/chat_room.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view/chat/chat_view.dart';
import 'package:p2pbookshare/view/outgoing_req/widgets/req_accepted_card.dart';
import 'package:p2pbookshare/view/request_book/widgets/book_info_card.dart';
import 'package:p2pbookshare/model/book.dart';
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

  final Book bookData;
  final String heroKey;

  @override
  State<UserBookDetailsView> createState() => _UserBookDetailsViewState();
}

class _UserBookDetailsViewState extends State<UserBookDetailsView> {
  FirebaseUserService _firebaseUserService = FirebaseUserService();
  String _receiverName = '';
  final _userBookDetailsViewModel = UserBookDetailsViewModel();
  String _receiverId = '';
  String _chatRoomId = '';
  String _receiverImageUrl = '';
  // String _currentUserId = '';

  Future<void> setReceiverDetails(String receiverId) async {
    _receiverId = receiverId;
    _receiverName = await _firebaseUserService
        .getUserDetailsById(_receiverId)
        .then((value) => value![UserConstants.userName]);
    _receiverImageUrl = await _firebaseUserService
        .getUserDetailsById(_receiverId)
        .then((value) => value![UserConstants.userPhotoUrl]);
  }

  @override
  Widget build(BuildContext context) {
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
                                Future<void> setReceiverDetails(
                                    String receiverId) async {
                                  _receiverId = receiverId;
                                  _receiverName = await _firebaseUserService
                                      .getUserDetailsById(_receiverId)
                                      .then((value) =>
                                          value![UserConstants.userName]);
                                  _receiverImageUrl = await _firebaseUserService
                                      .getUserDetailsById(_receiverId)
                                      .then((value) =>
                                          value![UserConstants.userPhotoUrl]);
                                }

                                _getReceiverIdAndChatRoomId() async {
                                  final currentUserUid =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  String bookId = widget.bookData.bookID!;

                                  if (currentUserUid ==
                                      bookRequestdata[
                                          BorrowRequestConfig.reqBookOwnerID]) {
                                    await setReceiverDetails(bookRequestdata[
                                        BorrowRequestConfig.requesterID]);
                                  } else {
                                    await setReceiverDetails(bookRequestdata[
                                        BorrowRequestConfig.reqBookOwnerID]);
                                  }

                                  _chatRoomId = ChatService.createChatRoomId(
                                      bookId, currentUserUid, _receiverId);
                                }

                                _getReceiverIdAndChatRoomId();

                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ReqAcceptedCard(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ChatView(
                                            receiverId: _receiverId,
                                            receiverName: _receiverName,
                                            receiverimgUrl: _receiverImageUrl,
                                            chatRoomId: _chatRoomId,
                                          );
                                        }));
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                // Incoming book requests listview
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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

                                          Future<ChatRoom>
                                              getReceiverIdAndChatRoomId(
                                                  Map<String, dynamic>
                                                      bookData) async {
                                            String currentUserId = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            String bookId = bookData[
                                                BorrowRequestConfig.reqBookID];
                                            String receiverId;
                                            if (currentUserId ==
                                                widget.bookData.bookOwnerID) {
                                              receiverId = bookData[
                                                  BorrowRequestConfig
                                                      .requesterID];
                                            } else {
                                              receiverId = bookData[
                                                  BorrowRequestConfig
                                                      .reqBookOwnerID];
                                            }
                                            String chatRoomId =
                                                ChatService.createChatRoomId(
                                                    bookId,
                                                    currentUserId,
                                                    receiverId);
                                            logger.info(
                                                '⚙️🔨Chat room id: $chatRoomId, receiverId: $receiverId, receiverName: $_receiverName, currentUserId: $currentUserId');
                                            return ChatRoom(
                                              userIds: [
                                                currentUserId,
                                                receiverId
                                              ],
                                              bookId: widget.bookData.bookID!,
                                              chatRoomId: chatRoomId,
                                              bookBorrowRequestId: bookData[
                                                  BorrowRequestConfig.reqID],
                                            );
                                          }

                                          return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: bookRequestData.length,
                                            itemBuilder: (context, index) {
                                              final requestData =
                                                  bookRequestData[index];
                                              return FutureBuilder<ChatRoom>(
                                                future:
                                                    getReceiverIdAndChatRoomId(
                                                        requestData),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.hasData) {
                                                    ChatRoom chatRoom =
                                                        snapshot.data!;
                                                    return incomingRequestCard(
                                                      context: context,
                                                      bookRequestData:
                                                          requestData,
                                                      onAccept: () =>
                                                          _userBookDetailsViewModel
                                                              .acceptIncomingBookRequest(
                                                                  context,
                                                                  chatRoom),
                                                      onDecline: () =>
                                                          _userBookDetailsViewModel
                                                              .rejectIncomingBookRequest(
                                                                  context,
                                                                  requestData[
                                                                      BorrowRequestConfig
                                                                          .reqID]),
                                                    );
                                                  } else {
                                                    // Show a loading indicator while the ChatRoom is being created
                                                    return const CircularProgressIndicator();
                                                  }
                                                },
                                              );
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


  /// Container to show ongouing exchange progress
  /// with the user who requested the book
  /// This container will show the user's details
  /// and the status of the book exchange
  /// (i.e. if the book is received or not)
  /// Show progress bar for exchange prorgesss
  /**
                                     Container(
                                      child: Column(children: [
                                        const Text(
                                          'Ongoing Exchange',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        StreamBuilder(
                                            stream: bookRequestService
                                                .fetchAcceptedRequestForBook(
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
                                                final bookRequestData =
                                                    snapshot.data!;
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      bookRequestData.length,
                                                  itemBuilder: (context, index) {
                                                    final bookData =
                                                        bookRequestData[index];
                                                    return buildOngoingExchangeCard(
                                                        context: context,
                                                        bookRequestData: bookData,
                                                        onBookReceived: () =>
                                                            _userBookDetailsViewModel
                                                                .markBookReceived(
                                                                    context,
                                                                    bookData[
                                                                        BookRequestConfig.reqID]));
                                                  },
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            }),]),
                                    ),
                                   */
                                  

  /// Incoming requests title
  /**
                                     StreamBuilder(
                                        stream:
                                            bookRequestService.isRequestsAvailableForBook(
                                                widget.bookData.bookID!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.data == true) {
                                            return const Padding(
                                              padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Incoming Requests',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }),
                                    */