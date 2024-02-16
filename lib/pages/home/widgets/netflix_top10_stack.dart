// import 'package:flutter/material.dart';

// List bookRatingCount = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

// class NFtop10Stack extends StatelessWidget {
//   const NFtop10Stack({super.key, this.bookRatingCount});

//   final String? bookRatingCount;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Text(
//           bookRatingCount!,
//           style: TextStyle(
//             fontSize: 125,
//             letterSpacing: 5,
//             fontWeight: FontWeight.bold,
//             shadows: [
//               Shadow(
//                 color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
//                 blurRadius: 35,
//               ),
//             ],
//             foreground: Paint()
//               ..style = PaintingStyle.stroke
//               ..strokeWidth = 2
//               ..color = Colors.white,
//           ),
//         ),
//         Text(
//           bookRatingCount!,
//           style: TextStyle(
//               fontSize: 125,
//               letterSpacing: 5,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.background),
//         ),
//       ],
//     );
//   }
// }
