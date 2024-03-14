import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/timestamp_extension.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';

//TODO: Show warning dialog before accepting the book request.
/// All other requests would be rejected
/// The user would be notified about the rejection
/// Set the availibility of the book to false
//TODO: add exchange duration to the book request
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
          final Timestamp _reqTimestamp = bookRequestData['req_timestamp'];
          final Timestamp _reqStartDate = bookRequestData['req_start_date'];
          final Timestamp _reqEndDate = bookRequestData['req_end_date'];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10), // Add padding for better spacing

              tileColor: context.primaryContainer.withOpacity(
                  0.3), // Set a background color for better visibility
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14), // Add rounded corners
              ),
              // title: Text(
              //   userData['username'],
              //   // style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
              title: Row(
                children: [
                  Icon(MdiIcons.accountOutline,
                      color: context.onPrimaryContainer),
                  const SizedBox(width: 5),
                  Text(
                    userData['username'],
                    style: TextStyle(color: context.onPrimaryContainer),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5), // Add spacing
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(MdiIcons.calendarRangeOutline,
                      //     size: 16, color: context.onPrimaryContainer),
                      // const SizedBox(width: 5),
                      Text(
                        'from: ',
                        style: TextStyle(color: context.onPrimaryContainer),
                      ),
                      // const Expanded(child: SizedBox()),
                      Text(
                        '${_reqStartDate.toDayAndDate()}',
                        style: TextStyle(color: context.onPrimaryContainer),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),

                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(MdiIcons.calendarRangeOutline,
                      //     size: 16, color: context.onPrimaryContainer),
                      // const SizedBox(width: 5),
                      Text(
                        'To: ',
                        style: TextStyle(color: context.onPrimaryContainer),
                      ),
                      // const Expanded(child: SizedBox()),
                      Text(
                        '${_reqEndDate.toDayAndDate()}',
                        style: TextStyle(color: context.onPrimaryContainer),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  // const SizedBox(height: 10), // Add spacing

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Adjust button alignment
                    children: [
                      OutlinedButton.icon(
                        // Decline button to reject the request
                        // Deleted the book request from the (book_request) collection

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
