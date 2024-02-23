import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/view_book/view_book_handler.dart';
import 'package:p2pbookshare/services/model/book.dart';
import 'package:p2pbookshare/services/model/book_request.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';

class BorrowButton extends StatefulWidget {
  const BorrowButton({
    Key? key,
    required this.bookRequestServices,
    required this.bookData,
    required this.userDataProvider,
  }) : super(key: key);

  final BookRequestService bookRequestServices;
  final Book bookData;
  final UserDataProvider userDataProvider;

  @override
  _BorrowButtonState createState() => _BorrowButtonState();
}

class _BorrowButtonState extends State<BorrowButton> {
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
        BookRequest(
          reqBookID: widget.bookData.bookID!,
          reqBookOwnerID: widget.bookData.bookOwner,
          requesterID: widget.userDataProvider.userModel!.userUid!,
        ),
      );

      setState(() {
        isRequestPending = requestExists;
      });
    } catch (e) {
      // Handle the error appropriately
      print('Error checking request status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRequestPending == null) {
      return const SizedBox(
        height: 60,
        child: FilledButton(
          onPressed: null,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isRequestPending!) {
      return const SizedBox(
        height: 60,
        child: FilledButton(
          onPressed: null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pending,
              ),
              const SizedBox(width: 8),
              Text(
                'Borrow request pending',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isRequestBeingMade) {
      return const SizedBox(
        height: 60,
        child: FilledButton(
          onPressed: null,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: FilledButton(
        onPressed: () async {
          setState(() {
            isRequestBeingMade = true;
          });

          // Make the borrow request
          await ViewBookHandler(widget.bookRequestServices).handleBorrowRequest(
            BookRequest(
              reqBookID: widget.bookData.bookID!,
              reqBookOwnerID: widget.bookData.bookOwner,
              requesterID: widget.userDataProvider.userModel!.userUid!,
            ),
          );

          setState(() {
            isRequestBeingMade = false;
          });
        },
        child: isRequestBeingMade
            ? const CircularProgressIndicator()
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_checkout_rounded,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Borrow',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
      ),
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
//     return FutureBuilder<bool>(
//       future: bookRequestServices.checkIfRequestAlreadyMade(BookRequest(
//         reqBookID: bookData.bookID!,
//         reqBookOwnerID: bookData.bookOwner,
//         requesterID: userDataProvider.userModel!.userUid!,
//       )),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator(); // Show loader while checking
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.data == true) {
//           return const SizedBox(
//             height: 60,
//             child: FilledButton(
//               onPressed: null,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.pending,
//                   ),
//                   const SizedBox(
//                       width: 8), // Adjust spacing between icon and text
//                   Text(
//                     'Borrow request pending',
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ); // Request already made, hide the button
//         } else {
//           return SizedBox(
//               height: 60,
//               child: FilledButton(
//                 onPressed: () async {
//                   await ViewBookHandler(bookRequestServices)
//                       .handleBorrowRequest(BookRequest(
//                           reqBookID: bookData.bookID!,
//                           reqBookOwnerID: bookData.bookOwner,
//                           requesterID: userDataProvider.userModel!.userUid!));
//                 },
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.shopping_cart_checkout_rounded,
//                       // color: Theme.of(context).colorScheme.onPrimary,
//                     ),
//                     SizedBox(width: 8), // Adjust spacing between icon and text
//                     Text(
//                       'Borrow',
//                       style: TextStyle(
//                         fontSize: 20,
//                         // color: Theme.of(context).colorScheme.onPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ));
//         }
//       },
//     );
//   }
// }
