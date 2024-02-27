import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/widgets.dart';
import 'package:p2pbookshare/services/model/user.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start, // Center vertically
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Center(
                // TODO: change cached network image to custo cached image
                child: userModel.userPhotoUrl != null
                    ? ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        child: SizedBox(
                            height: 120,
                            width: 120,
                            child:
                                CachedImage(imageUrl: userModel.userPhotoUrl!)),
                      )
                    : CircularProgressIndicator(
                        color: Theme.of(context).indicatorColor,
                      ), //! IMPLEMENTATION OF CACHED PROFILE IMAGE
              ),
            ),
            const Text('No of books listed : XXX'),
            const SizedBox(width: 25),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userModel.userName!,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2, // Limiting to 2 lines to prevent excessive expansion
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
    );
  }
}

// class UserProfileCard extends StatelessWidget {
//   const UserProfileCard({
//     super.key,
//     required this.userModel,
//   });
//   final UserModel userModel;
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//               width: 100,
//               height: 100,
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
//             const SizedBox(height: 16),
//             Text(
//               userModel.userName!,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               userModel.userEmailAddress!,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
