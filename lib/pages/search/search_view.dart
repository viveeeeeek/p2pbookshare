import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/constants/app_constants.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:p2pbookshare/pages/search/search_viewmodel.dart';
import 'package:p2pbookshare/pages/search/widgets/search_app_bar.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    super.key,
  });

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    const double toolbarHeight = kToolbarHeight + 8;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(toolbarHeight),
        child: SearchAppBar(),
      ),
      body: SafeArea(
        child: Consumer2<BookFetchService, SearchViewModel>(
          builder: (context, bookFetchServices, searchViewModel, child) {
            // Build ChoiceChip on list of available genre
            Widget buildChoiceChip(String genre) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  label: Text(genre),
                  onSelected: (selected) {
                    if (selected) {
                      searchViewModel.setSelectedGenre(genre);
                    } else {
                      searchViewModel.clearSelectedGenre();
                    }
                  },
                  selected: searchViewModel.selectedGenreFilter == genre,
                ),
              );
            }

            // Method to get bookStream dynamically based on the selected choice chip
            Stream<List<Map<String, dynamic>>> getSelectedStream() {
              if (searchViewModel.selectedGenreFilter == 'All') {
                return bookFetchServices.getAllBooks();
              } else if (searchViewModel.selectedGenreFilter != 'All' &&
                  searchViewModel.searchQuery.isNotEmpty) {
                return bookFetchServices.getAllBooks();
              } else {
                return bookFetchServices
                    .getCategoryWiseBooks(searchViewModel.selectedGenreFilter);
              }
            }

            return Column(
              children: [
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      ChoiceChip(
                        label: const Text('All'),
                        onSelected: (selected) {
                          if (selected) {
                            searchViewModel.setSelectedGenre('All');
                          } else {
                            searchViewModel.clearSelectedGenre();
                          }
                        },
                        selected: searchViewModel.selectedGenreFilter == 'All',
                      ),
                      const SizedBox(width: 6),
                      for (String genre in AppConstants.bookGenres)
                        buildChoiceChip(genre),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                // Book List
                Expanded(
                  child: StreamBuilder(
                    stream: getSelectedStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        List<Map<String, dynamic>> booksList = snapshot.data!;

                        if (searchViewModel.searchQuery.isEmpty &&
                            booksList.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              itemCount: booksList.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> bookData =
                                    booksList[index];
                                //FIXME: Create BookModle instance and pass it. which can be the passed on to the viewbookscreen when clicked on the search result listtile
                                return BookTile(
                                  title: bookData['book_title'],
                                  author: bookData['book_author'],
                                  imageUrl: bookData['book_coverimg_url'],
                                );
                              },
                            ),
                          );
                        } else if (searchViewModel.searchQuery.isNotEmpty &&
                            booksList.any((book) => book['book_title']
                                .toString()
                                .toLowerCase()
                                .startsWith(searchViewModel.searchQuery
                                    .toLowerCase()))) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              itemCount: booksList.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> bookData =
                                    booksList[index];
                                if (bookData['book_title']
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(searchViewModel.searchQuery
                                        .toLowerCase())) {
                                  return BookTile(
                                    title: bookData['book_title'],
                                    author: bookData['book_author'],
                                    imageUrl: bookData['book_coverimg_url'],
                                  );
                                }
                                return Container(); // Return an empty container for non-matching items
                              },
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Center(child: Text('No book found :/')),
                          );
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final VoidCallback? onTap;

  const BookTile({
    Key? key,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: SizedBox(
          width: 40,
          height: 60,
          child: CachedImage(imageUrl: imageUrl),
        ),
      ),
      title: Text(title),
      subtitle: Text(author),
      onTap: onTap,
    );
  }
}
