// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:p2pbookshare/core/app_init_handler.dart';
// import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
// import 'package:p2pbookshare/model/book_model.dart';
// import 'package:p2pbookshare/model/book_request_model.dart';
// import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
// import 'package:p2pbookshare/view/outgoing_req/outgoing_req_details_view.dart';
// import 'package:provider/provider.dart';

// class BorrowButtonOld extends StatelessWidget {
//   const BorrowButtonOld(
//       {super.key,
//       required this.bookData,
//       required this.currentUserUid,
//       required this.onPressed,
//       required this.bookRequestServices});
//   final Function() onPressed;
//   final BookModel bookData;
//   final String currentUserUid;
//   final BookBorrowRequestService bookRequestServices;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BookBorrowRequestService>(
//       builder: (context, consumer, child) {
//         return Center(
//             child: StreamBuilder(
//           stream: consumer.checkBookAvailability(bookData.bookID!),
//           builder: (context, AsyncSnapshot<bool> snapshot) {
//             if (snapshot.connectionState == ConnectionState.active) {
//               if (snapshot.hasData) {
//                 logger.info('Is book available: ${snapshot.data}');
//                 if (snapshot.data!) {
//                   // directly use snapshot.data
//                   return FutureBuilder(
//                       future: consumer.checkIfRequestAlreadyMade(
//                           BookBorrowRequest(
//                               reqBookID: bookData.bookID!,
//                               reqBookOwnerID: bookData.bookOwnerID,
//                               requesterID: currentUserUid)),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const P2PBookShareShimmerContainer(
//                               height: 60,
//                               width: double.infinity,
//                               borderRadius: 30);
//                         }
//                         if (snapshot.hasData && snapshot.data != null) {
//                           final _isRequestAlreadyMade = snapshot.data;
//                           if (_isRequestAlreadyMade == false) {
                            // return buildBorrowButton(
                            //     onPressed: onPressed,
                            //     height: 60,
                            //     width: double.infinity);
//                           } else if (_isRequestAlreadyMade == true) {
//                             return StreamBuilder(
//                                 stream: consumer.getBookRequestStatus(
                                    // BookBorrowRequest(
                                    //     reqBookID: bookData.bookID!,
                                    //     reqBookOwnerID: bookData.bookOwnerID,
                                    //     requesterID: currentUserUid)),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return const P2PBookShareShimmerContainer(
//                                         height: 60,
//                                         width: double.infinity,
//                                         borderRadius: 12);
//                                   } else if (snapshot.hasData &&
//                                       snapshot.data != null) {
//                                     final bookRequestData = snapshot.data!;

//                                     logger.info(
//                                         '⚓⚓BookRequestData: $bookRequestData');
//                                     final _reqStatus =
//                                         // ignore: unnecessary_null_comparison
//                                         bookRequestData != null
//                                             ? bookRequestData['req_status']
//                                             : null;
//                                     final _buttonText = _reqStatus == 'pending'
//                                         ? 'Request pending...'
//                                         : _reqStatus == 'accepted'
//                                             ? 'Request accepted'
//                                             : 'Borrow';
//                                     if (_reqStatus == 'pending' ||
//                                         _reqStatus == 'accepted') {
//                                       return SizedBox(
//                                         height: 60,
//                                         width: double.infinity,
//                                         child: FilledButton(
//                                             onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         OutgoingReqDetailsView(
                                              //       bookrequestModel:
                                              //           BookBorrowRequest(
                                              //         reqBookID:
                                              //             bookRequestData[
                                              //                 'req_book_id'],
                                              //         reqBookOwnerID:
                                              //             bookRequestData[
                                              //                 'req_book_owner_id'],
                                              //         requesterID:
                                              //             bookRequestData[
                                              //                 'requester_id'],
                                              //         reqBookStatus:
                                              //             bookRequestData[
                                              //                 'req_book_status'],
                                              //         reqEndDate:
                                              //             bookRequestData[
                                              //                 'req_end_date'],
                                              //         reqStartDate:
                                              //             bookRequestData[
                                              //                 'req_start_date'],
                                              //         reqID: bookRequestData[
                                              //             'req_id'],
                                              //         reqStatus:
                                              //             bookRequestData[
                                              //                 'req_status'],
                                              //         timestamp:
                                              //             bookRequestData[
                                              //                 'req_timestamp'],
                                              //       ),
                                              //     ),
                                              //   ),
                                              // );
//                                             },
//                                             child: Text(_buttonText)),
//                                       );
//                                     } else {
//                                       return const SizedBox();
//                                     }
//                                   } else {
//                                     return const Text('Something went wrong');
//                                   }
//                                 });
//                           } else {
//                             return const SizedBox();
//                           }
//                         } else {
//                           return const SizedBox();
//                         }
//                       });
//                 } else {
//                   return const FilledButton.tonal(
//                       onPressed: null, child: Text('Not available'));
//                 }
//               } else {
//                 return const SizedBox();
//               }
//             } else {
//               return const Text('error');
//             }
//           },
//         ));
//       },
//     );
//   }
// }

// Widget buildBorrowButton(
//     {required Function() onPressed,
//     required double height,
//     required double width}) {
//   return SizedBox(
//     height: height,
//     width: width,
//     child: FilledButton(
//       onPressed: onPressed,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // const Icon(
//           //   Icons.handshake_outlined,
//           // ),
//           Icon(MdiIcons.handshakeOutline),
//           const SizedBox(width: 8),
//           const Text(
//             'Borrow',
//             style: TextStyle(fontSize: 18),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// /**
 
       
//  */