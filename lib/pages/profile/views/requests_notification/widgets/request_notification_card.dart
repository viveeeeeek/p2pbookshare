import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';

Widget BookRequestNotificationCard(
    BuildContext context, Map<String, dynamic> bookRequestDocument) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: BookFetchService()
        .getBookDetailsById(bookRequestDocument['req_book_id']),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Return a loading indicator if data is still being fetched
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomShimmerContainer(
              height: 100, width: double.infinity, borderRadius: 15),
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        // Handle the error or the case where no matching book is found
        return const Text('Error loading book details');
      } else {
        // Access the book details from the snapshot
        Map<String, dynamic> reqBookData = snapshot.data!;

        return ListTile(
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: SizedBox(
                height: 60,
                width: 40,
                child: CachedImage(imageUrl: reqBookData['book_coverimg_url'])),
          ),
          title: Text(reqBookData['book_title']),
          subtitle: Text(
            '${Utils.formatDateTime(bookRequestDocument['req_timestamp'])}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: Icon(MdiIcons.arrowRight),
            onPressed: () {},
          ),
        );

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       ClipRRect(
        //         borderRadius: const BorderRadius.all(Radius.circular(8)),
        //         child: SizedBox(
        //           height: 120,
        //           width: 80,
        //           child: CachedImage(
        //             imageUrl: reqBookData['book_coverimg_url'] ??
        //                 'https://firebasestorage.googleapis.com/v0/b/p2pbookshareapp.appspot.com/o/book_cover_images%2F2024227211945_91ocU8970hL._AC_UF1000%2C1000_QL80_.jpg?alt=media&token=2d4a5952-37bf-4c47-afcf-7096751f79c5',
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 16),
        //       Expanded(
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       reqBookData['book_title'],
        //       style: const TextStyle(
        //           fontSize: 14, fontWeight: FontWeight.bold),
        //     ),
        //     const SizedBox(height: 8),
        //     Row(
        //       children: [
        //         const Text(
        //           'From: ',
        //           style: TextStyle(fontSize: 12, color: Colors.grey),
        //         ),
        //         Text(
        //           startDate.toDateOnly(),
        //           style:
        //               const TextStyle(fontSize: 12, color: Colors.grey),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       children: [
        //         const Text(
        //           'To: ',
        //           style: TextStyle(fontSize: 12, color: Colors.grey),
        //         ),
        //         Text(
        //           endDate.toDateOnly(),
        //           style:
        //               const TextStyle(fontSize: 12, color: Colors.grey),
        //         ),
        //       ],
        //     ),
        //             const SizedBox(height: 8),
        //             BookReqChoiceChips(
        //               onTapAccept: () {},
        //               onTapDecline: () {},
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.end,
        //               children: [
        //                 Text(
        //                   Utils.formatDateTime(
        //                       bookRequestDocument['req_timestamp']),
        //                   style:
        //                       const TextStyle(fontSize: 9, color: Colors.grey),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      }
    },
  );
}
