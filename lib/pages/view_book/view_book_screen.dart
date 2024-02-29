import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/global/widgets/cached_image.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/ai_summary_prefs.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'widgets/widgets.dart';
import 'package:p2pbookshare/services/model/book.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:provider/provider.dart';

class ViewBookScreen extends StatefulWidget {
  const ViewBookScreen({super.key, required this.bookData});

  final BookModel bookData;

  @override
  State<ViewBookScreen> createState() => _ViewBookScreenState();
}

class _ViewBookScreenState extends State<ViewBookScreen> {
  String currentUserUid = '';

  @override
  Widget build(BuildContext context) {
    final bookRequestServices = Provider.of<BookRequestService>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);

    currentUserUid = userDataProvider.userModel!.userUid!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookData.bookTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(MdiIcons.share))],
      ),
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Stack(children: [
              SingleChildScrollView(
                child: Container(
                  //! To keep seperation between card and sunmit button cus of stacked
                  margin: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      //! Book Cover Img
                      Center(
                        child: Container(
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
                            tag: widget.bookData.bookCoverImageUrl,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedImage(
                                  imageUrl: widget.bookData.bookCoverImageUrl,
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //! Book Detail Card
                      BookDetailsCard(
                        bookData: widget.bookData,
                        cardWidth: constraints.maxWidth,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //! Borrow button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // ),
                          Expanded(
                            child: BorrowButton(
                              bookRequestServices: bookRequestServices,
                              bookData: widget.bookData,
                              currentUserUid: currentUserUid,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      //! Category & Genre
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: context.secondaryContainer,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Icon(
                              Icons.category_outlined,
                              color: context.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Genre',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(widget.bookData.bookGenre)
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Condition',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(widget.bookData.bookCondition)
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      Center(
                        child: AISummarycard(
                            bookdata: widget.bookData,
                            aiSummarySPrefs: new AISummaryPrefs()),
                      ),
                      const SizedBox(
                        height: 15,
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
                          bookData: widget.bookData,
                          cardWidth: constraints.maxWidth),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}
