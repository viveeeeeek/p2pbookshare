import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/search/widgets/search_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
      ),
      body: Column(
        children: [
          searchbookSearchBar('Search books'),
          // Expanded(child: searchBookListingResult()),

          // Expanded(
          //   child: _buildSearchResults(),
          // ),
        ],
      ),
    );
  }
}
