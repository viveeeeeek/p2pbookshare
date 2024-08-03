import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/services/firebase/book_rating_service.dart';
import 'package:p2pbookshare/view_model/outgoing_req_viewmodel.dart';

class RatingBar extends StatefulWidget {
  const RatingBar(
      {super.key,
      required this.requestID,
      required this.bookId,
      required this.userId});
  final String userId;
  final String bookId;
  final String requestID;
  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int _rating = 0;

  OutgoingreqViewModel _outgoingreqViewModel = OutgoingreqViewModel();
  BookRatingService _bookRatingService = BookRatingService();

  @override
  Widget build(BuildContext context) {
    return P2pbookshareStreamBuilder(
        dataStream: _bookRatingService.getBookRatingStream(
            widget.userId, widget.bookId),
        successBuilder: (snapshot) {
          _rating = snapshot as int;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  _rating > index ? Icons.star : Icons.star_border,
                  color: context.primary,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                    _outgoingreqViewModel.updateBookRating(
                        widget.userId, widget.bookId, _rating);
                  });
                },
              );
            }),
          );
        },
        waitingBuilder: () {
          return const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: P2PBookShareShimmerContainer(
                height: 20, width: double.infinity, borderRadius: 10),
          );
        },
        errorBuilder: (e) {
          return Text('Error: $e');
        });
  }
}
