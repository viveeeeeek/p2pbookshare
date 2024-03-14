import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';

class ReqPendingcard extends StatelessWidget {
  const ReqPendingcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your request is pending',
              style:
                  TextStyle(fontSize: 22, color: context.onTertiaryContainer)),
          const SizedBox(
            height: 3,
          ),
          Text(
              'The owner has not yet accepted or rejected your request. Please wait for the owner to respond. You will be able to chat with the owner once the request is accepted.',
              style: TextStyle(color: context.onTertiaryContainer)),
        ],
      ),
    );
  }
}