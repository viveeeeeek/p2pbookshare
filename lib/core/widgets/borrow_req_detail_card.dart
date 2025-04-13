// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/core/extensions/timestamp_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/borrow_request.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';

class CurrentRequestDetails extends StatelessWidget {
  const CurrentRequestDetails({super.key, required this.bookRequestModel});

  final BorrowRequest bookRequestModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(MdiIcons.calendarBadgeOutline),
                    const SizedBox(
                      width: 6,
                    ),
                    const Text(
                      'Exchange duration',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${bookRequestModel.reqStartDate!.toDayAndDate()}',
                        ),
                        const Text(
                          "To",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${bookRequestModel.reqEndDate!.toDayAndDate()}',
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            indent: 0,
            endIndent: 0,
            thickness: 1,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Borrow Request ID',
                ),
                Text(
                  '${bookRequestModel.reqID}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Borrower:',
                    ),
                    const SizedBox(width: 5),
                    buildPersonName(context, bookRequestModel.requesterID)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Lender:',
                    ),
                    const SizedBox(width: 5),
                    buildPersonName(context, bookRequestModel.reqBookOwnerID)
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}

Widget buildPersonName(BuildContext context, String bookOwnerID) {
  return FutureBuilder(
      future: FirebaseUserService().getUserDetailsById(bookOwnerID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final userData = snapshot.data;
          return Text(
            '${userData![UserConstants.displayName] ?? 'Lorem Ipsum'}',
            //    style: const TextStyle(fontSize: 18),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const P2PBookShareShimmerContainer(
            height: 10, width: 200, borderRadius: 6);
      });
}
