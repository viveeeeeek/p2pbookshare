// Flutter imports:
import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/utils/logging.dart';

// Project imports:
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/services/shared_prefs/user_data_prefs.dart';

class UserDataProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> loadUserDataFromPrefs() async {
    final userDataPrefs = UserDataPrefs();
    final user = await userDataPrefs.loadUserFromPrefs();

    if (user != null) {
      _userModel = UserModel(
        userUid: user.uid,
        emailAddress: user.email,
        displayName: user.displayName,
        profilePictureUrl: user.photoURL,
      );
      setUserModel(_userModel!);
      // print('💥Userdatamodel set from setter inside userdata_provider');
    }

    notifyListeners();
  }

  /// clear the usermodel
  void clearUserData() {
    _userModel = null;
    logger.i('Userdata cleared');
    notifyListeners();
  }

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
