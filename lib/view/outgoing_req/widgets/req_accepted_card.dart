// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:p2pbookshare/core/extensions/color_extension.dart';

class ReqAcceptedCard extends StatelessWidget {
  const ReqAcceptedCard({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request accepted',
            style: TextStyle(fontSize: 22, color: context.onPrimaryContainer),
          ),
          const SizedBox(height: 3),
          Text(
              'You can now chat with the peer and discuss about the book exchange.',
              style: TextStyle(color: context.onPrimaryContainer)),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FilledButton(
                  onPressed: onPressed,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(MdiIcons.messageOutline),
                        const SizedBox(width: 8),
                        const Text('Chat book owner')
                      ])),
            ],
          ),
        ],
      ),
    );
  }
}
