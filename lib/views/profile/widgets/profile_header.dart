import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_cached_image.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/providers/firebase/book_request_service.dart';

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
              StreamBuilder(
                  stream: BookRequestHandlingService()
                      .countNoOfBooksUploadedAsStream(),
                  builder: (context, snapshot) {
                    if (ConnectionState == ConnectionState.waiting) {
                      return const CustomShimmerContainer(
                          height: 15, width: 100, borderRadius: 4);
                    } else if (snapshot.hasError) {
                      return const CustomShimmerContainer(
                          height: 15, width: 100, borderRadius: 4);
                    } else if (snapshot.hasData) {
                      return Text('No of books listed : ${snapshot.data}');
                    } else {
                      return const Text('Error loading book count');
                    }
                  }),
              // const Text('No of books listed : XXX'),
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
      ),
    );
  }
}
