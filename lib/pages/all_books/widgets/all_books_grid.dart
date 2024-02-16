import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class AllBooksGrid extends StatelessWidget {
  const AllBooksGrid({
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
          return const Center(child: Text('No books found.'));
        } else {
          List<Map<String, dynamic>> booksList = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.7, // Adjust this aspect ratio as needed
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: booksList.length,
              itemBuilder: (context, index) {
                return buildBookWidget(booksList[index]);
              },
            ),
          );
        }
      },
    );
  }
}

Widget buildBookWidget(Map<String, dynamic> bookData) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: SizedBox(
          width: 200,
          height: 250,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: bookData['book_coverimg_url'],
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: 250,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bookData['book_title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bookData['book_author'],
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
