// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/user.dart';

// class UserProfileCard extends StatelessWidget {
//   const UserProfileCard({
//     Key? key,
//     required this.userModel,
//   }) : super(key: key);

//   final UserModel userModel;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start, // Center vertically
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: 75,
//               height: 75,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color:
//                     Colors.grey, // Background color for the circular container
//               ),
//               child: Center(
//                 child: userModel.userPhotoUrl != null
//                     ? CachedNetworkImage(
//                         imageUrl: userModel.userPhotoUrl!,
//                         imageBuilder: (context, imageProvider) => Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         placeholder: (context, url) =>
//                             CircularProgressIndicator(
//                           color: Theme.of(context).indicatorColor,
//                         ),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                       )
//                     : CircularProgressIndicator(
//                         color: Theme.of(context).indicatorColor,
//                       ), //! IMPLEMENTATION OF CACHED PROFILE IMAGE
//               ),
//             ),
//             const SizedBox(
//               width: 75,
//             ),
//             const Text('No of books listed ; 6')
//           ],
//         ),
//         const SizedBox(height: 16),
//         Text(
//           userModel.userName!,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//           overflow: TextOverflow.ellipsis,
//           maxLines: 2, // Limiting to 2 lines to prevent excessive expansion
//         ),
//         const SizedBox(height: 8),
//         Text(
//           userModel.userEmail!,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(width: 20), // Adjust as needed for spacing
//       ],
//     );
//   }
// }

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    required this.userModel,
  });
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.grey, // Background color for the circular container
              ),
              child: Center(
                child: userModel.userPhotoUrl != null
                    ? CachedNetworkImage(
                        imageUrl: userModel.userPhotoUrl!,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          color: Theme.of(context).indicatorColor,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : CircularProgressIndicator(
                        color: Theme.of(context).indicatorColor,
                      ), //! IMPLEMENTATION OF CACHED PROFILE IMAGE
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userModel.userName!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userModel.userEmailAddress!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
