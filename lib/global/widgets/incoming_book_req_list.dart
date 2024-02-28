import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:intl/intl.dart';

class IncomingBookReqListView extends StatelessWidget {
  const IncomingBookReqListView({
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No book requests yet.'));
        } else {
          List<Map<String, dynamic>> booksList = snapshot.data!;
          return ListView.builder(
              itemCount: booksList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildBookWidget(context, booksList[index]);
              });
        }
      },
    );
  }
}

Widget buildBookWidget(BuildContext context, Map<String, dynamic> bookData) {
  // Fucntion to convert [Timestamp] into proper DateTime format.
  String _formatTimestamp(Timestamp timestamp) {
    // Converting timestamp to date
    DateTime dateTime = timestamp.toDate();
    String formattedDateTime =
        DateFormat('EEEE, MMM d, yyyy - hh:mm a').format(dateTime);
    return formattedDateTime;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: SizedBox(
            height: 100,
            width: 75,
            child: CachedImage(
              imageUrl: bookData['book_coverimg_url'] ??
                  'https://firebasestorage.googleapis.com/v0/b/p2pbookshareapp.appspot.com/o/book_cover_images%2F2024227211945_91ocU8970hL._AC_UF1000%2C1000_QL80_.jpg?alt=media&token=2d4a5952-37bf-4c47-afcf-7096751f79c5',
            ),
          ),
        ),
        const SizedBox(width: 10.0), // Adjust spacing as needed
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                bookData['book_title'] ?? 'Lorem Ipsum',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                bookData['book_author'] ?? 'AuthorN',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4.0),
              Text(
                _formatTimestamp(bookData['req_timestamp']),
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InputChip(
                    label: const Text('Accept'),
                    onPressed: () {
                      // Handle accept logic here
                    },
                    // backgroundColor: context.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none, // Remove the outer border
                    ),
                  ),

                  const SizedBox(width: 5.0), // Add spacing between chips
                  InputChip(
                    label: const Text('Decline'),
                    onPressed: () {
                      // Handle decline logic here
                    },
                    // backgroundColor: context.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
