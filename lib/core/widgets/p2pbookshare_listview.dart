// Flutter imports:
import 'package:flutter/material.dart';

class P2pbookshareStreamBuilder extends StatelessWidget {
  final Stream<dynamic> dataStream;
  final Widget Function(dynamic) successBuilder;
  final Widget Function() waitingBuilder;
  final Widget Function(dynamic) errorBuilder;

  const P2pbookshareStreamBuilder({
    super.key,
    required this.dataStream,
    required this.successBuilder,
    required this.waitingBuilder,
    required this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingBuilder();
        } else if (snapshot.hasError) {
          return errorBuilder(snapshot.error);
        } else {
          return successBuilder(snapshot.data);
        }
      },
    );
  }
}
