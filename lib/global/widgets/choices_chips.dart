import 'package:flutter/material.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';

class BookReqChoiceChips extends StatelessWidget {
  const BookReqChoiceChips(
      {super.key, required this.onTapAccept, required this.onTapDecline});

  final void Function()? onTapAccept, onTapDecline;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InputChip(
          label: const Text('Decline'),
          onPressed: onTapDecline,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 5.0),
        InputChip(
          label: const Text('Accept'),
          onPressed: onTapAccept,

          // backgroundColor: context.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide.none, // Remove the outer border
          ),
        ),
      ],
    );
  }
}
