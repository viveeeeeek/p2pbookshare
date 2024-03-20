import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/timestamp_extension.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/model/borrow_request.dart';

class OutgoingReqDetailsCard extends StatelessWidget {
  const OutgoingReqDetailsCard({super.key, required this.bookRequestModel});

  final BorrowRequest bookRequestModel;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  bookRequestModel.reqBookStatus == 'available'
                      ? Icon(MdiIcons.checkCircleOutline)
                      : Icon(MdiIcons.cancel),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${bookRequestModel.reqBookStatus}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
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
              const Divider(),
              Text(
                '${bookRequestModel.reqStartDate!.toDayAndDate()}',
              ),
              Container(
                height: 20,
                width: 1,
                color: Colors.grey,
              ),
              Text(
                '${bookRequestModel.reqEndDate!.toDayAndDate()}',
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${bookRequestModel.timestamp!.toDayAndTime()}',
                    style: TextStyle(
                        fontSize: 12, color: context.onSurfaceVariant),
                  ),
                ],
              ),
            ])));
  }
}

// class OutgoingReqDetailsCard2 extends StatelessWidget {
//   const OutgoingReqDetailsCard2({super.key, required this.bookRequestModel});

//   final BookRequestModel bookRequestModel;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: Padding(
//             padding: const EdgeInsets.all(15),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Requested book id: ${bookRequestModel.reqBookID}'),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Request ID: ${bookRequestModel.reqID}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Owner ID: ${bookRequestModel.reqBookOwnerID}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Request ID: ${bookRequestModel.reqID}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Request Start Date: ${Utils.formatDateTime(bookRequestModel.reqStartDate!)}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Request End Date: ${Utils.formatDateTime(bookRequestModel.reqEndDate!)}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Request Book Status: ${bookRequestModel.reqBookStatus}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Request Timestamp: ${Utils.formatDateTime(bookRequestModel.timestamp!)}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 'Requester ID: ${bookRequestModel.requesterID}',
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ])));
//   }
// }
