// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/app_constants.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/view/search/widgets/search_app_bar.dart';
import 'package:p2pbookshare/view_model/search_viewmodel.dart';

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
      body: Consumer2<BookFetchService, SearchViewModel>(
        builder: (context, bookFetchServices, searchViewModel, child) {
          // Build ChoiceChip on list of available genre
          //FIXME: Remove this outside body and make it a separate widget
          Widget buildChoiceChip(String genre) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: ChoiceChip(
                label: Text(
                  genre,
                  style: TextStyle(
                    color: searchViewModel.selectedGenreFilter == genre
                        ? context.onPrimaryContainer // Color when selected
                        : null, // Default color
                  ),
                ),
                // selectedColor: context.primaryContainer,
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
                      // selectedColor: context.primaryContainer,
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
                              Map<String, dynamic> bookData = booksList[index];
                              return BookTile(
                                bookData: bookData,
                              );
                            },
                          ),
                        );
                      }

                      // If search query is not empty, filter booksList based on the query
                      List<Map<String, dynamic>> matchingBooks = booksList
                          .where((book) =>
                              book[BookConfig.bookTitle]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchViewModel.searchQuery
                                      .toLowerCase()) ||
                              book[BookConfig.bookAuthor]
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchViewModel.searchQuery
                                      .toLowerCase()))
                          .toList();

                      if (matchingBooks.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                            itemCount: matchingBooks.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> bookData =
                                  matchingBooks[index];
                              return BookTile(
                                bookData: bookData,
                              );
                            },
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              Center(child: Text('No book or author found!')),
                        );
                      }
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(child: Text('Something went wrong!')),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final Map<String, dynamic> bookData;
  final _currentUserID = FirebaseAuth.instance.currentUser!.uid;

  BookTile({
    Key? key,
    required this.bookData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Hero(
          tag: '${bookData[BookConfig.bookCoverImageUrl]}-searchscreen',
          child: SizedBox(
            width: 40,
            height: 60,
            child:
                CachedImage(imageUrl: bookData[BookConfig.bookCoverImageUrl]),
          ),
        ),
      ),
      title: Text(bookData[BookConfig.bookTitle]),
      subtitle: Text(bookData[BookConfig.bookAuthor]),
      onTap: () {
        final key = '${bookData[BookConfig.bookCoverImageUrl]}-searchscreen';
        if (bookData[BookConfig.bookOwnerID] == _currentUserID) {
          context.pushNamed(AppRouterConstants.userBookDetailsView,
              extra: Book.fromMap(bookData), pathParameters: {'heroKey': key});
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => UserBookDetailsView(
          //       heroKey:
          //           '${bookData[BookConfig.bookCoverImageUrl]}-searchscreen',
          //       bookData: Book.fromMap(bookData),
          //     ),
          //   ),
          // );
        } else {
          context.pushNamed(AppRouterConstants.requestBookView,
              extra: Book.fromMap(bookData), pathParameters: {'heroKey': key});
        }
      },
    );
  }
}
