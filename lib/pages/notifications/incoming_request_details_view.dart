import 'package:flutter/material.dart';

class IncomingRequestDetailsView extends StatelessWidget {
  final String bookTitle;
  final String requesterName;
  final String requestDate;

  const IncomingRequestDetailsView({
    super.key,
    required this.bookTitle,
    required this.requesterName,
    required this.requestDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Title: $bookTitle',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Requester Name: $requesterName',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Request Date: $requestDate',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement accept request logic
                  },
                  child: const Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement decline request logic
                  },
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
