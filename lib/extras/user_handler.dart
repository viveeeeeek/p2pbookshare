import 'package:flutter/material.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class UserHandler {
  getUser(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return UserModel(
        userUid: userDataProvider.userModel!.userUid,
        userEmailAddress: userDataProvider.userModel!.userEmailAddress,
        userName: userDataProvider.userModel!.userName,
        userPhotoUrl: userDataProvider.userModel!.userPhotoUrl);
  }
}
