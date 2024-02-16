// import 'package:flutter/material.dart';
// import 'package:p2pbookshare/pages/all_books/widgets/all_books_grid.dart';
// import 'package:p2pbookshare/services/providers/firebase/book_upload_services.dart';
// import 'package:provider/provider.dart';

// class ViewAllBooksScreen extends StatelessWidget {
//   const ViewAllBooksScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final fbBookServices = Provider.of<BookUploadServices>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Books'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//             // Navigator.pushNamedAndRemoveUntil(
//             //   context,
//             //   'home',
//             //   (route) => false, // To remove all routes from the stack
//             // );
//           },
//         ),
//         elevation: 0,
//       ),
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context);
//           return true;
//         },
//         child: Column(
//           children: [
//             Expanded(
//               child: AllBooksGrid(
//                 context: context,
//                 stream: fbBookServices.getAllBooks(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
