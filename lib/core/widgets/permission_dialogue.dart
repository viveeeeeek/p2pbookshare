// import 'package:flutter/material.dart';

// class PermissionDialog extends StatelessWidget {
//   final Function? onEnableLocationPressed;

//   const PermissionDialog({super.key, this.onEnableLocationPressed});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Location Permission Required'),
//       content: const SingleChildScrollView(
//         child: ListBody(
//           children: <Widget>[
//             Text(
//                 'Please enable location permissions and services to use this feature.'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog
//           },
//           child: const Text('CANCEL'),
//         ),
//         TextButton(
//           onPressed: onEnableLocationPressed as void Function()? ?? () {},
//           child: const Text('ENABLE LOCATION'),
//         ),
//       ],
//     );
//   }
// }

// // Inside your StatefulWidget or StatelessWidget
// showPermissionDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return PermissionDialog(
//         onEnableLocationPressed: () {
//           // Add code to handle enabling location services here
//           // For example, open device settings to enable location services
//           // You can use packages like 'url_launcher' to launch settings
//           // url_launcher: https://pub.dev/packages/url_launcher
//         },
//       );
//     },
//   );
// }
