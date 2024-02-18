import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';

class YourBookDetailedScreen extends StatelessWidget {
  @override
  const YourBookDetailedScreen({
    super.key,
    this.uniqueImgKey,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverUrl,
    required this.bookPublication,
    required this.bookCondition,
    this.bookID,
  });

  final String? uniqueImgKey,
      bookTitle,
      bookAuthor,
      bookCoverUrl,
      bookPublication,
      bookCondition,
      bookID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: CachedImage(
                  bookCoverImgUrl: bookCoverUrl!,
                ),
              ),
              const Spacer(),
              Text(
                bookTitle!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                bookAuthor!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              Text(
                bookPublication!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              Text(
                bookCondition!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your edit functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor:
                    //     Theme.of(context).colorScheme.primaryContainer
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        // Symbols.delete_rounded,
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      Text(
                        'Delete Book',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
