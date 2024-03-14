// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: userModel.userPhotoUrl != null
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          child: SizedBox(
                              height: 120,
                              width: 120,

                              /// Custom cached image widget
                              child: CachedImage(
                                  imageUrl: userModel.userPhotoUrl!)),
                        )
                      : CircularProgressIndicator(
                          color: Theme.of(context).indicatorColor,
                        ),
                ),
              ),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userModel.userName!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            // style: context.titleLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Limiting to 2 lines to prevent excessive expansion
          ),
          Text(
            userModel.userEmailAddress!,
            // style: const TextStyle(
            //   fontSize: 16,
            //   color: Colors.grey,
            // ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}


              /// Show count of numbers of books listed by user
              /**
                StreamBuilder(
                  stream: BookRequestHandlingService()
                      .countNoOfBooksUploadedAsStream(),
                  builder: (context, snapshot) {
                    if (ConnectionState == ConnectionState.waiting) {
                      return const P2PBookShareShimmerContainer(
                          height: 15, width: 100, borderRadius: 4);
                    } else if (snapshot.hasError) {
                      return const P2PBookShareShimmerContainer(
                          height: 15, width: 100, borderRadius: 4);
                    } else if (snapshot.hasData) {
                      return Text('No of books listed : ${snapshot.data}');
                    } else {
                      return const Text('Error loading book count');
                    }
                  }),

          */
