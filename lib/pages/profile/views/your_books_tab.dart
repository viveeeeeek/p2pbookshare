import 'package:flutter/material.dart';

class YourBooksTabView extends StatelessWidget {
  const YourBooksTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Placeholder()
                // AllBooksGrid(
                //     context: context,
                //     stream: ProfileHandler().getUserBooksStream(context)),
                ),
          )
        ],
      ),
    );
  }
}
