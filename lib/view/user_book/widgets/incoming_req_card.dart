// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/extensions/timestamp_extension.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';

//TODO: Show warning dialog before accepting the book request.
/// All other requests would be rejected
/// The user would be notified about the rejection
/// Set the availibility of the book to false
//TODO: Add exchange duration to the book request
Widget incomingRequestCard(
    {required BuildContext context,
    required Map<String, dynamic> bookRequestData,
    required Function() onDecline,
    required Function() onAccept}) {
  return FutureBuilder(
      future: FirebaseUserService()
          .getUserDetailsById(bookRequestData['requester_id']),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          //FIXME: Handle the uncaught exceptions like if the data is not available or is null.
          /// Remove actual implementation of widget from else block to else if  snapshot.has data || snapshot.data != null
          final userData = snapshot.data!;
          final Timestamp _reqStartDate = bookRequestData['req_start_date'];
          final Timestamp _reqEndDate = bookRequestData['req_end_date'];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10), // Add padding for better spacing

              tileColor: context.primaryContainer.withValues(
                  alpha: 0.3), // Set a background color for better visibility
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14), // Add rounded corners
              ),

              title: Row(
                children: [
                  Icon(MdiIcons.accountOutline,
                      color: context.onPrimaryContainer),
                  const SizedBox(width: 5),
                  Text(
                    userData[UserConstants.displayName],
                    style: TextStyle(color: context.onPrimaryContainer),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5), // Add spacing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 1,
                        color:
                            context.onPrimaryContainer.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_reqStartDate.toDayAndDate()}',
                            style: TextStyle(color: context.onPrimaryContainer),
                          ),
                          const Text(
                            "To",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${_reqEndDate.toDayAndDate()}',
                            style: TextStyle(color: context.onPrimaryContainer),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Adjust button alignment
                    children: [
                      // Decline button to reject the request
                      OutlinedButton.icon(
                        onPressed: onDecline,
                        icon: Icon(
                          MdiIcons.close,
                        ),
                        label: const Text(
                          'Reject',
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      // Accept button to accept the request and start the exchange
                      FilledButton.icon(
                        onPressed: onAccept,
                        icon: Icon(MdiIcons.check),
                        label: const Text('Accept'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      });
}
