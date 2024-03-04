import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_choices_chips.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';

//FIXME: Add refreshindicator to fetchnew data.

class AllReqToBooksListview extends StatelessWidget {
  const AllReqToBooksListview({
    super.key,
    required this.context,
    required this.stream,
  });

  final BuildContext context;
  final Stream<List<Map<String, dynamic>>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomShimmerContainer(
              height: 150, width: double.infinity, borderRadius: 15);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Check if data has data and is not empty
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.bellCancel,
                  size: 50,
                  color: context.secondary,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'No one has requested your book yet.',
                  style: TextStyle(
                    color: context.secondary,
                  ),
                )
              ],
            ),
          );
        } else {
          final booksList = snapshot.data!; // Safe access after checking
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              itemCount: booksList.length,
              itemBuilder: (context, index) {
                final bookData = booksList[index];
                return buildBookRequestWidget(context, bookData);
              },
            ),
          );
        }
      },
    );
  }
}

//! works but futurebuilder
// class AllReqToBooksListview extends StatelessWidget {
//   const AllReqToBooksListview({
//     super.key,
//     required this.context,
//     required this.future,
//   });

//   final BuildContext context;
//   final Future<List<Map<String, dynamic>>> future;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Map<String, dynamic>> booksList = snapshot.data ?? [];

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: ListView.builder(
//               itemCount: booksList.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> bookData = booksList[index];
//                 return buildBookRequestWidget(context, bookData);
//               },
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

//
Widget buildBookRequestWidget(
    BuildContext context, Map<String, dynamic> bookData) {
  return Container(
    decoration: BoxDecoration(
        color: context.tertiaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: ListTile(
      title: Text(
        bookData['req_book_id'],
        style: TextStyle(color: context.onTertiaryContainer),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookData['req_book_owner_id'],
            style: TextStyle(color: context.onTertiaryContainer),
          ),
          Text(
            Utils.formatDateTime(
              bookData['req_timestamp'],
            ),
            style: TextStyle(color: context.onTertiaryContainer),
          ),
          BookReqChoiceChips(onTapAccept: () {}, onTapDecline: () {})
        ],
      ),
    ),
  );
}
