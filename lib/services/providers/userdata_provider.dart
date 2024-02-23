import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/user.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/user_data_prefs.dart';

class UserDataProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> loadUserDataFromPrefs() async {
    final userDataPrefs = UserDataPrefs();
    final user = await userDataPrefs.loadUserFromPrefs();

    if (user != null) {
      _userModel = UserModel(
        userUid: user.uid,
        userEmailAddress: user.email,
        userName: user.displayName,
        userPhotoUrl: user.photoURL,
      );
      setUserModel(_userModel!);
      // print('💥Userdatamodel set from setter inside userdata_provider');
    }

    notifyListeners();
  }

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
