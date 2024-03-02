import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/shimmer_container.dart';
import 'package:p2pbookshare/services/model/book_model.dart';
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
    required this.height,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  final BookRequestService bookRequestServices;
  final BookModel bookData;
  final String currentUserUid;
  final double height, width;
  final void Function() onPressed;

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
              return CustomShimmerContainer(
                height: widget.height,
                width: widget.width,
                borderRadius: 35,
              ); // Show loader while checking
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              bool requestExists = snapshot.data == true;
              return SizedBox(
                height: widget.height,
                width: widget.width,
                child: FilledButton(
                  onPressed: !requestExists ? widget.onPressed : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        requestExists
                            ? Icons.pending
                            : Icons.shopping_cart_checkout_rounded,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        requestExists ? 'Borrow request pending' : 'Borrow',
                        style: const TextStyle(
                          fontSize: 20,
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
