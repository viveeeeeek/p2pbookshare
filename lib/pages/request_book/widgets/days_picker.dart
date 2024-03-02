// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:p2pbookshare/pages/request_book/request_book_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class NumberOfDaysSelector extends StatefulWidget {
//   final ValueChanged<DateTime> onDatesChanged;

//   const NumberOfDaysSelector({
//     Key? key,
//     required this.onDatesChanged,
//   }) : super(key: key);

//   @override
//   _NumberOfDaysSelectorState createState() => _NumberOfDaysSelectorState();
// }

// class _NumberOfDaysSelectorState extends State<NumberOfDaysSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RequestBookViewModel>(
//       builder: (context, requestBookViewModel, child) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               readOnly: true,
//               onTap: () => requestBookViewModel.pickStartDate(context),
//               // onTap: () => requestBookViewModel.pickStartDate(
//               //     context: context,
//               //     selectedStartDate: widget.initialStartDate,
//               //     onDatesChanged: widget.onDatesChanged),
//               decoration: InputDecoration(
//                 labelText: 'From',
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.expand_more),
//                   onPressed: () => requestBookViewModel.pickStartDate(context),
//                 ),
//               ),

//               controller: TextEditingController(
//                 text: DateFormat('dd-MM-yyyy').format(
//                     requestBookViewModel.selectedStartDate ?? DateTime.now()),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             TextField(
//               readOnly: true,
//               onTap: () => requestBookViewModel.pickEndDate(context),
//               // onTap: () => requestBookViewModel.pickEndDate(
//               //     context: context,
//               //     selectedStartDate: requestBookViewModel.selectedStartDate ??
//               //         widget.initialStartDate,
//               //     selectedEndDate: requestBookViewModel.selectedEndDate ??
//               //         widget.initialEndDate,
//               //     onDatesChanged: widget.onDatesChanged),
//               decoration: InputDecoration(
//                 labelText: 'To',
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.expand_more),
//                   onPressed: () => requestBookViewModel.pickEndDate(context),
//                   // onPressed: () => requestBookViewModel.pickEndDate(
//                   //     context: context,
//                   //     selectedStartDate:
//                   //         requestBookViewModel.selectedStartDate ??
//                   //             widget.initialStartDate,
//                   //     selectedEndDate: requestBookViewModel.selectedEndDate ??
//                   //         widget.initialEndDate,
//                   //     onDatesChanged: widget.onDatesChanged),
//                 ),
//               ),
//               controller: TextEditingController(
//                 text: DateFormat('dd-MM-yyyy').format(
//                     requestBookViewModel.selectedEndDate ??
//                         requestBookViewModel.initialEndDate),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


   // Text(
            //   'Number of Days: ${requestBookViewModel.selectedEndDate?.difference(requestBookViewModel.selectedStartDate!).inDays + 1}',
            //   style: const TextStyle(fontSize: 16),
            // ),

// class NumberOfDaysSelector extends StatefulWidget {
//   final int initialDays;
//   final ValueChanged<int> onChanged;

//   const NumberOfDaysSelector(
//       {super.key, required this.initialDays, required this.onChanged});

//   @override
//   _NumberOfDaysSelectorState createState() => _NumberOfDaysSelectorState();
// }

// class _NumberOfDaysSelectorState extends State<NumberOfDaysSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RequestBookViewModel>(
//       builder: (context, viewBookHnadler, child) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.remove),
//               onPressed: () {
//                 viewBookHnadler.decrementDay();
//               },
//             ),
//             Text(
//               '${viewBookHnadler.selectedDays} days',
//               style: const TextStyle(fontSize: 16),
//             ),
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () {
//                 viewBookHnadler.incrementDay();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
