// import 'package:flutter/material.dart';
// import 'package:p2pbookshare/global/utils/app_utils.dart';
// import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
// import 'package:p2pbookshare/global/widgets/p2pbookshare_choices_chips.dart';
// import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
// import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';

// class IncomingBookReqListView extends StatelessWidget {
//   const IncomingBookReqListView({
//     super.key,
//     required this.context,
//     required this.stream,
//   });

//   final BuildContext context;
//   final Stream<List<Map<String, dynamic>>> stream;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(child: Text('No book requests yet.'));
//         } else {
//           List<Map<String, dynamic>> booksList = snapshot.data!;
//           return ListView.builder(
//               itemCount: booksList.length,
//               shrinkWrap: true,
//               physics: const ClampingScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return buildBookWidget(context, booksList[index]);
//               });
//         }
//       },
//     );
//   }
// }

// Widget buildBookWidget(
//     BuildContext context, Map<String, dynamic> bookRequestData) {
//   return FutureBuilder<Map<String, dynamic>?>(
//     future:
//         BookFetchService().getBookDetailsById(bookRequestData['req_book_id']),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         // Return a loading indicator if data is still being fetched
//         return const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: CustomShimmerContainer(
//               height: 100, width: double.infinity, borderRadius: 15),
//         );
//       } else if (snapshot.hasError || snapshot.data == null) {
//         // Handle the error or the case where no matching book is found
//         return const Text('Error loading book details');
//       } else {
//         // Access the book details from the snapshot
//         Map<String, dynamic> reqBookData = snapshot.data!;

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.all(Radius.circular(7)),
//                 child: SizedBox(
//                   height: 100,
//                   width: 75,
//                   child: CachedImage(
//                     imageUrl: reqBookData['book_coverimg_url'] ??
//                         'https://firebasestorage.googleapis.com/v0/b/p2pbookshareapp.appspot.com/o/book_cover_images%2F2024227211945_91ocU8970hL._AC_UF1000%2C1000_QL80_.jpg?alt=media&token=2d4a5952-37bf-4c47-afcf-7096751f79c5',
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10.0), // Adjust spacing as needed
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       reqBookData['book_title'] ?? 'Lorem Ipsum',
//                       style: const TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 4.0),
//                     Text(
//                       bookRequestData['book_author'] ?? 'AuthorN',
//                       style: const TextStyle(fontSize: 13, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 4.0),
//                     Text(
//                       Utils.formatDateTime(bookRequestData['req_timestamp']),
//                       style: const TextStyle(fontSize: 12, color: Colors.blue),
//                     ),
//                     BookReqChoiceChips(
//                       onTapAccept: () {},
//                       onTapDecline: () {},
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     },
//   );
// }
