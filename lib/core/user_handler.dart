// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';

class UserHandler {
  getUser(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return UserModel(
        userUid: userDataProvider.userModel!.userUid,
        username: userDataProvider.userModel!.username,
        emailAddress: userDataProvider.userModel!.emailAddress,
        displayName: userDataProvider.userModel!.displayName,
        profilePictureUrl: userDataProvider.userModel!.profilePictureUrl);
  }
}
