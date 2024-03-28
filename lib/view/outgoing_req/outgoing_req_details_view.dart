import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view/chat/chat_view.dart';
import 'package:p2pbookshare/view/outgoing_req/widgets/outgoing_req_details_card.dart';
import 'package:p2pbookshare/provider/firebase/book_listing_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/view/outgoing_req/widgets/req_accepted_card.dart';
import 'package:p2pbookshare/view/outgoing_req/widgets/req_pending_card.dart';
import 'package:provider/provider.dart';

class OutgoingReqDetailsView extends StatefulWidget {
  const OutgoingReqDetailsView({
    super.key,
    required this.bookrequestModel,
    // required this.heroKey,
  });

  final BorrowRequest? bookrequestModel;

  // final String heroKey;

  @override
  State<OutgoingReqDetailsView> createState() => _OutgoingReqDetailsViewState();
}

class _OutgoingReqDetailsViewState extends State<OutgoingReqDetailsView> {
  // String currentUserUid = '';
  String bookOwnerName = '';

  getBookOwnerName() async {
    final userData = await FirebaseUserService()
        .getUserDetailsById(widget.bookrequestModel!.reqBookOwnerID);

    setState(() {
      bookOwnerName = userData![UserConstants.userName];
    });
  }

  String _receiverId = '';
  String _chatRoomId = '';
  String _receiverName = '';
  String _receiverImageUrl = '';
  FirebaseUserService _firebaseUserService = FirebaseUserService();
  Future<void> setReceiverDetails(String receiverId) async {
    _receiverId = receiverId;
    _receiverName = await _firebaseUserService
        .getUserDetailsById(_receiverId)
        .then((value) => value![UserConstants.userName]);
    _receiverImageUrl = await _firebaseUserService
        .getUserDetailsById(_receiverId)
        .then((value) => value![UserConstants.userPhotoUrl]);
  }

  _getReceiverIdAndChatRoomId() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String bookId = widget.bookrequestModel!.reqBookID;

    if (currentUserUid == widget.bookrequestModel!.reqBookOwnerID) {
      await setReceiverDetails(widget.bookrequestModel!.requesterID);
    } else {
      await setReceiverDetails(widget.bookrequestModel!.reqBookOwnerID);
    }

    _chatRoomId =
        ChatService.createChatRoomId(bookId, currentUserUid, _receiverId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookOwnerName();
    _getReceiverIdAndChatRoomId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.bookData.bookTitle),
        title: const Text('Request details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
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
                            Align(
                              alignment: Alignment.center,
                              child: buildBookDetailsCard(
                                  context, widget.bookrequestModel!.reqBookID),
                            ),
                          ]))
                        ];
                      },
                      body: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: context.onSurface.withOpacity(0.2),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            StreamBuilder(
                                stream: bookRequestService.getRequestStatusbyID(
                                    widget.bookrequestModel!.reqID!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData &&
                                      snapshot.data == null) {
                                    return const SizedBox();
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    final reqStatus = snapshot
                                        .data![BorrowRequestConfig.reqStatus];
                                    if (reqStatus == 'accepted') {
                                      return ReqAcceptedCard(
                                        onPressed: () {
                                          logger.info(
                                              'Current chat id is $_chatRoomId');
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
                                      );
                                    } else {
                                      return const ReqPendingcard();
                                    }
                                  }
                                  return const SizedBox();
                                }),
                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'Your request details',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            OutgoingReqDetailsCard(
                                bookRequestModel: widget.bookrequestModel!),
                          ],
                        ),
                      ));
                },
              ))),
    );
  }
}

Widget buildBookDetailsCard(BuildContext context, String bookID) {
  return FutureBuilder(
      future: BookFetchService().getBookDetailsById(bookID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const P2PBookShareShimmerContainer(
              height: 180, width: 130, borderRadius: 2);
        } else if (snapshot.hasData && snapshot.data != null) {
          final bookData = snapshot.data;
          return Column(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedImage(
                    imageUrl: bookData!['book_coverimg_url'],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                bookData['book_title'],
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                bookData['book_author'],
                style: const TextStyle(fontSize: 16),
              )
            ],
          );
        } else {
          return const SizedBox();
        }
      });
}

// Widget buildBookOwnerName(BuildContext context, String bookOwnerID) {
//   return FutureBuilder(
//       future: FirebaseUserService().getUserDetailsById(bookOwnerID),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const P2PBookShareShimmerContainer(
//               height: 20, width: 250, borderRadius: 2);
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         final userData = snapshot.data;
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               MdiIcons.accountOutline,
//               size: 18,
//             ),
//             const SizedBox(
//               width: 6,
//             ),
//             Text(
//               '${userData!['username'] ?? 'Lorem Ipsum'}',
//               //    style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         );
//       });
// }
