// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/utils/app_utils.dart';
import 'package:p2pbookshare/model/book.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/services/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/services/shared_prefs/ai_summary_prefs.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';
import 'package:p2pbookshare/view_model/request_book_viewmodel.dart';
import 'widgets/widgets.dart';

/// This screen is used to display the details of a book and to request the book from the owner.
/// The screen is displayed when the user taps on a book from the [HomeView] or [SearchView].
/// The screen displays the book details and a button to request the book from the owner.

class RequestBookView extends StatefulWidget {
  const RequestBookView(
      {super.key, required this.bookData, required this.heroKey});

  final Book bookData;
  final String heroKey;

  @override
  State<RequestBookView> createState() => _RequestBookViewState();
}

class _RequestBookViewState extends State<RequestBookView> {
  @override
  Widget build(BuildContext context) {
    final bookRequestServices = Provider.of<BookRequestService>(context);
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

      final bool _isDateRangeSelected =
          await requestBookViewModel.pickDateRange(context);
      if (_isDateRangeSelected) {
        await bookRequestServices.sendBookBorrowRequest(
          BorrowRequest(
              reqBookID: widget.bookData.bookID!,
              reqBookOwnerID: widget.bookData.bookOwnerID,
              requesterID: currentUserUid,
              reqStartDate:
                  Timestamp.fromDate(requestBookViewModel.selectedStartDate!),
              reqEndDate:
                  Timestamp.fromDate(requestBookViewModel.selectedEndDate!)
              // reqDurationInDays:
              //     requestBookViewModel.selectedDays,
              ),
        );
      }

      /// SHOW CONFIRMATION DIALOG BEFORE SENDING REQUEST
      /**
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
       */
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
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),

                      /// Book Cover Img
                      buildBookCoverImg(
                        context: context,
                        heroKey: widget.heroKey,
                        bookCoverImageUrl: widget.bookData.bookCoverImageUrl,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      /// Book Detail Card
                      BookDetailsCard(
                        bookData: widget.bookData,
                        cardWidth: constraints.maxWidth,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),

                      /// Borrow button
                      BorrowButton(
                          bookData: widget.bookData,
                          currentUserUid: currentUserUid,
                          onPressed: () => handleDateRangeSelection(context),
                          bookRequestServices: bookRequestServices),
                      const SizedBox(
                        height: 25,
                      ),

                      /// Category & Genre
                      buildCategoryAndGenre(
                          context: context,
                          bookRating: widget.bookData.bookRating!,
                          bookGenre: widget.bookData.bookGenre,
                          bookCondition: widget.bookData.bookCondition),
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

                      BookExchangeLocationCard(
                          bookData: widget.bookData,
                          cardWidth: constraints.maxWidth),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            ]))
          ],
        );
      }),
    );
  }
}
