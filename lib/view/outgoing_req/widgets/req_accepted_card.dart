import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
        color: context.primaryContainer.withOpacity(0.5),
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                  onPressed: onPressed,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(MdiIcons.messageOutline),
                        const SizedBox(width: 8),
                        const Text('Chat now')
                      ]))
            ],
          )
        ],
      ),
    );
  }
}
