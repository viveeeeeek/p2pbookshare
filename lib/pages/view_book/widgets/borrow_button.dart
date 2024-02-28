import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/shimmer_container.dart';
import 'package:p2pbookshare/services/model/book.dart';
import 'package:p2pbookshare/services/model/book_request.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';

class BorrowButton extends StatefulWidget {
  const BorrowButton({
    Key? key,
    required this.bookRequestServices,
    required this.bookData,
    required this.currentUserUid,
  }) : super(key: key);

  final BookRequestService bookRequestServices;
  final BookModel bookData;
  final String currentUserUid;

  @override
  _BorrowButtonState createState() => _BorrowButtonState();
}

class _BorrowButtonState extends State<BorrowButton> {
  SimpleLogger logger = SimpleLogger();
  bool? isRequestPending;
  bool isRequestBeingMade = false;

  @override
  void initState() {
    super.initState();
    checkIfRequestAlreadyMade();
  }

  Future<void> checkIfRequestAlreadyMade() async {
    try {
      bool requestExists =
          await widget.bookRequestServices.checkIfRequestAlreadyMade(
        BookRequestModel(
          reqBookID: widget.bookData.bookID!,
          reqBookOwnerID: widget.bookData.bookOwner,
          requesterID: widget.currentUserUid,
        ),
      );

      setState(() {
        isRequestPending = requestExists;
      });
    } catch (e) {
      // Handle the error appropriately
      logger.info('Error checking request status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookRequestService>(
      builder: (context, consumer, child) {
        return FutureBuilder<bool>(
          future: consumer.checkIfRequestAlreadyMade(BookRequestModel(
            reqBookID: widget.bookData.bookID!,
            reqBookOwnerID: widget.bookData.bookOwner,
            requesterID: widget.currentUserUid,
          )),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomShimmerContainer(
                height: 60,
                width: double.infinity,
                borderRadius: 35,
              ); // Show loader while checking
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              bool requestExists = snapshot.data == true;
              return SizedBox(
                height: 60,
                child: FilledButton(
                  onPressed: !requestExists
                      ? () async {
                          await consumer.sendBookBorrowRequest(BookRequestModel(
                              reqBookID: widget.bookData.bookID!,
                              reqBookOwnerID: widget.bookData.bookOwner,
                              requesterID: widget.currentUserUid));
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        requestExists
                            ? Icons.pending
                            : Icons.shopping_cart_checkout_rounded,
                        // Choose the appropriate icon based on request status
                        // color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(
                          width: 8), // Adjust spacing between icon and text
                      Text(
                        requestExists ? 'Borrow request pending' : 'Borrow',
                        style: const TextStyle(
                          fontSize: 20,
                          // color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}






  
// class BorrowButton extends StatelessWidget {
//   const BorrowButton({
//     super.key,
//     required this.bookRequestServices,
//     required this.bookData,
//     required this.userDataProvider,
//   });

//   final BookRequestService bookRequestServices;
//   final Book bookData;
//   final UserDataProvider userDataProvider;

//   @override
//   Widget build(BuildContext context) {
    // return FutureBuilder<bool>(
    //   future: bookRequestServices.checkIfRequestAlreadyMade(BookRequest(
    //     reqBookID: bookData.bookID!,
    //     reqBookOwnerID: bookData.bookOwner,
    //     requesterID: userDataProvider.userModel!.userUid!,
    //   )),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const CircularProgressIndicator(); // Show loader while checking
    //     } else if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     } else if (snapshot.data == true) {
    //       return const SizedBox(
    //         height: 60,
    //         child: FilledButton(
    //           onPressed: null,
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const Icon(
    //                 Icons.pending,
    //               ),
    //               const SizedBox(
    //                   width: 8), // Adjust spacing between icon and text
    //               Text(
    //                 'Borrow request pending',
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ); // Request already made, hide the button
    //     } else {
    //       return SizedBox(
    //           height: 60,
    //           child: FilledButton(
                // onPressed: () async {
                  // await ViewBookHandler(bookRequestServices)
                  //     .handleBorrowRequest(BookRequest(
                  //         reqBookID: bookData.bookID!,
                  //         reqBookOwnerID: bookData.bookOwner,
                  //         requesterID: userDataProvider.userModel!.userUid!));
                // },
    //             child: const Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   Icons.shopping_cart_checkout_rounded,
    //                   // color: Theme.of(context).colorScheme.onPrimary,
    //                 ),
    //                 SizedBox(width: 8), // Adjust spacing between icon and text
    //                 Text(
    //                   'Borrow',
    //                   style: TextStyle(
    //                     fontSize: 20,
    //                     // color: Theme.of(context).colorScheme.onPrimary,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ));
//         }
//       },
//     );
//   }
// }
