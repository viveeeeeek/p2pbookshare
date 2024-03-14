import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';

// Widget buildNoRequestsWidget(BuildContext context) {
//   return
// }

class NoRequestsWidget extends StatelessWidget {
  const NoRequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.bellOffOutline,
              size: 50,
              color: context.secondary,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'No new requests!',
              style: TextStyle(
                color: context.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
