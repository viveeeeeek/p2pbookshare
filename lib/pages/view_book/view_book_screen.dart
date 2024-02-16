import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';
import 'widgets/widgets.dart';
import 'package:p2pbookshare/services/model/book.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:provider/provider.dart';
import '../../services/providers/userdata_provider.dart';

class ViewBookScreen extends StatelessWidget {
  const ViewBookScreen({super.key, required this.bookData});

  final Book bookData;

  @override
  Widget build(BuildContext context) {
    final bookRequestServices = Provider.of<BookRequestService>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final locationProvider = Provider.of<LocationService>(context);
    print('✅✅✅✅${bookData.location!.latitude}');

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(bookData.bookTitle),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(children: [
              SingleChildScrollView(
                child: Container(
                  //! To keep seperation between card and sunmit button cus of stacked
                  margin: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //! Book Cover Img
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 210,
                              width: 160,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 4),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedBookCoverImg(
                                      bookCoverImgUrl:
                                          bookData.bookCoverImageUrl)),
                            ),
                            const Positioned(
                                top: 0, right: 0, child: FavouriteButton()),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //! Book Detail Card
                      BookDetailsCard(
                        bookData: bookData,
                        cardWidth: constraints.maxWidth,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const Text(
                        'Exchange location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BookExchangeLocationCard(
                          bookData: bookData, cardWidth: constraints.maxWidth),
                      const SizedBox(
                        height: 15,
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${bookData.bookAuthor} ${bookData.bookPublication} ${bookData.bookCategory}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ),
                    BorrowButton(
                        bookRequestServices: bookRequestServices,
                        bookData: bookData,
                        userDataProvider: userDataProvider),
                  ],
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}
