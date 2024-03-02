import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:p2pbookshare/pages/request_book/widgets/book_info_card.dart';
import 'package:p2pbookshare/pages/user_book/widgets/all_req_to_book_listview.dart';
import 'package:p2pbookshare/services/model/book_model.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class UserBookView extends StatefulWidget {
  const UserBookView({
    super.key,
    required this.bookData,
    required this.heroKey,
  });

  final BookModel bookData;
  final String heroKey;

  @override
  State<UserBookView> createState() => _UserBookViewState();
}

class _UserBookViewState extends State<UserBookView> {
  // String currentUserUid = '';

  @override
  Widget build(BuildContext context) {
    // final userDataProvider = Provider.of<UserDataProvider>(context);

    // // final _currentUserUid = userDataProvider.userModel!.userUid!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookData.bookTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Consumer<BookRequestService>(
                builder: (context, bookRequestService, child) {
                  return NestedScrollView(
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 180,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 4),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Hero(
                                    tag: widget.heroKey,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedImage(
                                        imageUrl:
                                            widget.bookData.bookCoverImageUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Book Detail Card
                                Expanded(
                                  child: BookDetailsCard(
                                    bookData: widget.bookData,
                                    cardWidth: 200,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
                              ],
                            ),
                          ])),
                        ];
                      },
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Incoming requests for book',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: AllReqToBooksListview(
                              context: context,
                              stream:
                                  bookRequestService.streamAllRequestsToBook(
                                widget.bookData.bookID!,
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              ))),
    );
  }
}
