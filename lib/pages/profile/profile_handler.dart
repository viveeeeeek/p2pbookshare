import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:provider/provider.dart';

class ProfileHandler {
  getUserBooksStream(BuildContext context) {
    final bookFetchServices = Provider.of<BookFetchService>(context);
    return bookFetchServices.getUserListedBooks();
  }
}
