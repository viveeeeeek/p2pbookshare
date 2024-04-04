// Flutter imports:
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.vertical(
          //     top: Radius.circular(20), bottom: Radius.circular(5))
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(80),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
