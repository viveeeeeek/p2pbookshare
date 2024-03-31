import 'package:flutter/material.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:provider/provider.dart';

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
