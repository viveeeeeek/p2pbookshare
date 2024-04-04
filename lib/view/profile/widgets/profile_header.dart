// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
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
          userModel.profilePictureUrl != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: SizedBox(
                      height: 75,
                      width: 75,

                      /// Custom cached image widget
                      child:
                          CachedImage(imageUrl: userModel.profilePictureUrl!)),
                )
              : CircularProgressIndicator(
                  color: Theme.of(context).indicatorColor,
                ),

          const SizedBox(width: 25),
          const SizedBox(height: 12),
          // Username
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: context.surfaceVariant.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      MdiIcons.at,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      userModel.username!,
                      style: const TextStyle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              StreamBuilder(
                  stream: BookRequestService().countNoOfBooksUploadedAsStream(),
                  builder: (context, snapshot) {
                    if (ConnectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      logger.e('Error loading book count');
                      return const SizedBox();
                    } else if (snapshot.hasData) {
                      return Row(
                        children: [
                          Icon(MdiIcons.bookOutline, size: 16),
                          Text('${snapshot.data}'),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ],
          ),
          const SizedBox(height: 6),
          // User display name
          Text(
            userModel.displayName!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            // style: context.titleLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Limiting to 2 lines to prevent excessive expansion
          ),

          Text(
            userModel.emailAddress!,
            style: const TextStyle(), // User email address
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
