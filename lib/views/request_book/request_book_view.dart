import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/global/utils/extensions/color_extension.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/model/book_model.dart';
import 'package:p2pbookshare/model/book_request.dart';
import 'package:p2pbookshare/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/providers/shared_prefs/ai_summary_prefs.dart';
import 'package:p2pbookshare/providers/userdata_provider.dart';
import 'package:p2pbookshare/view_models/request_book_viewmodel.dart';

import 'widgets/widgets.dart';

//FIXME: On confirmation of borrow duration, the dialog should be dismissed and the user should be navigated to the previous screen

// Suggest better name for this screen

/// This screen is used to display the details of a book and to request the book from the owner.
///
/// The screen is displayed when the user taps on a book from the [HomeView] or [SearchView].
///
/// The screen displays the book details and a button to request the book from the owner.

class RequestBookView extends StatefulWidget {
  const RequestBookView(
      {super.key, required this.bookData, required this.heroKey});

  final BookModel bookData;
  final String heroKey;

  @override
  State<RequestBookView> createState() => _RequestBookViewState();
}

class _RequestBookViewState extends State<RequestBookView> {
  @override
  Widget build(BuildContext context) {
    final bookRequestServices =
        Provider.of<BookRequestHandlingService>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final requestBookViewModel = Provider.of<RequestBookViewModel>(context);
    String currentUserUid = userDataProvider.userModel!.userUid!;

    /// Handle date range selection.
    /// Selects date range and confirms it before sending the actual book borrow request.
    handleDateRangeSelection(BuildContext context) async {
      Future.delayed(const Duration(milliseconds: 500), () {
        return Utils.alertDialog(
            context: context,
            title: 'Select Borrow Duration',
            description:
                'Please choose the date range for which you wish to borrow the book',
            actionText: 'Ok',
            onConfirm: () {
              Navigator.of(context).pop();
            });
      });

      /// awaits for daterange picker and stores the bool inside [isConfirmed]
      final bool isConfirmed =
          await requestBookViewModel.pickDateRange(context);

      if (isConfirmed) {
        // Show confirmation dialog
        if (context.mounted)
          Utils.alertDialog(
            context: context,
            title: 'Confirmation',
            description: 'Do you want to proceed with the selected date range?',
            actionText: 'Proceed',
            onConfirm: () async {
              // Send borrow request
              await bookRequestServices.sendBookBorrowRequest(
                BookRequestModel(
                    reqBookID: widget.bookData.bookID!,
                    reqBookOwnerID: widget.bookData.bookOwnerID,
                    requesterID: currentUserUid,
                    reqStartDate: Timestamp.fromDate(
                        requestBookViewModel.selectedStartDate!),
                    reqEndDate: Timestamp.fromDate(
                        requestBookViewModel.selectedEndDate!)
                    // reqDurationInDays:
                    //     requestBookViewModel.selectedDays,
                    ),
              );
              requestBookViewModel.clearSelectedDates();
              if (mounted) Navigator.of(context).pop();
            },
          );
      }
    }

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
                            tag: widget.heroKey,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      //! Borrow button
                      BorrowButton(
                        bookRequestServices: bookRequestServices,
                        bookData: widget.bookData,
                        currentUserUid: currentUserUid,
                        height: 60,
                        width: constraints.maxWidth * 0.85,
                        onPressed: () => handleDateRangeSelection(context),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      //! Category & Genre
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  color: context.onSecondaryContainer,
                                  size: 20,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(widget.bookData.bookGenre)
                              ],
                            ),
                            //
                            SizedBox(
                              height: 25,
                              child: VerticalDivider(
                                color: context
                                    .surfaceVariant, // Adjust color as needed
                                thickness: 1.3, // Adjust thickness as needed
                              ),
                            ),
                            Column(
                              children: [
                                Icon(
                                  MdiIcons.starOutline,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  size: 20,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(widget.bookData.bookRating.toString())
                              ],
                            ),
                            SizedBox(
                              height: 25,
                              child: VerticalDivider(
                                color: context
                                    .surfaceVariant, // Adjust color as needed
                                thickness: 1.3, // Adjust thickness as needed
                              ),
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.check_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  size: 20,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(widget.bookData.bookCondition)
                              ],
                            ),
                          ],
                        ),
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
