import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/book.dart';
// ignore: unused_import
import 'package:p2pbookshare/services/authentication/authentication.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';
import 'package:provider/provider.dart';

class TopRatedBookscarousel extends StatelessWidget {
  const TopRatedBookscarousel({super.key, required this.topBooksFuture});

  final Stream<List<Map<String, dynamic>>> topBooksFuture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: topBooksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: P2PBookShareShimmerContainer(
                    height: 180, width: 400, borderRadius: 15),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data'));
            } else {
              final userDataProvider = Provider.of<UserDataProvider>(context);
              List<Map<String, dynamic>> booksList = snapshot.data!;
              List<Widget> bookCards = booksList.map((bookData) {
                Book book = Book.fromMap(bookData);
                return BookCard(
                    bookData: book,
                    currentUserId: userDataProvider.userModel!.userUid!);
              }).toList();

              return CarouselView(
                onTap: (value) {
                  Book book = Book.fromMap(booksList[value]);
                  String heroKey = '${book.bookCoverImageUrl}-carouselview';
                  if (book.bookOwnerID != userDataProvider.userModel!.userUid) {
                    context.pushNamed(AppRouterConstants.requestBookView,
                        extra: book, pathParameters: {'heroKey': heroKey});
                  } else {
                    heroKey = '${book.bookCoverImageUrl}-userbookview';
                    context.pushNamed(AppRouterConstants.userBookDetailsView,
                        extra: book, pathParameters: {'heroKey': heroKey});
                  }
                },
                itemExtent: 150,
                children: bookCards,
              );
            }
          },
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard(
      {super.key, required this.bookData, required this.currentUserId});

  final Book bookData;

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    String heroKey;
    if (bookData.bookOwnerID == currentUserId) {
      heroKey = '${bookData.bookCoverImageUrl}-userbookview';
    } else {
      heroKey = '${bookData.bookCoverImageUrl}-carouselview';
    }
    ;
    return Stack(
      children: [
        Hero(
          tag: heroKey,
          child: Container(
            height: 200,
            width: 160,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedImage(
                imageUrl: bookData.bookCoverImageUrl,
              ),
            ),
          ),
        ),
        _buildGradientOverlay(),
        Positioned(
          bottom: 10,
          left: 10,
          child: _buildBookInfo(bookData, context),
        ),
      ],
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfo(Book book, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              color: context.primary,
            ),
            Text(
              book.bookRating.toString(),
              style: TextStyle(
                color: context.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          book.bookTitle,
          style: TextStyle(
            color: context.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
