// import 'package:flutter/material.dart';

// class BookCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;

//   const BookCard({super.key, required this.imageUrl, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4, // Adjust the elevation as needed
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8.0),
//               child: Image.network(
//                 imageUrl,
//                 height: 160, // Adjust the height as needed
//                 width: 130,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 // fontSize: 16.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
