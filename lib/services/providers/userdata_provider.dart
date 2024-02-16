import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/model/user.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/userdata_sprefs.provider.dart';

class UserDataProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> loadUserDataFromPrefs() async {
    final sharedPrefsProvider = UserDataSharedPrefsServices();
    final user = await sharedPrefsProvider.loadUserFromPrefs();

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
