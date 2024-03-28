import 'package:p2pbookshare/core/constants/model_constants.dart';

/// The UserModel class represents a user with properties such as userUid, userEmail, userName, and
/// userPhotoUrl, and provides methods to convert the object to and from a Map.

class UserModel {
  final String? userUid, userEmailAddress, userName, userPhotoUrl;

  UserModel({
    required this.userUid,
    required this.userEmailAddress,
    required this.userName,
    required this.userPhotoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userUid: map[UserConstants.userUid],
      userEmailAddress: map[UserConstants.userEmailAddress],
      userName: map[UserConstants.userName],
      userPhotoUrl: map[UserConstants.userPhotoUrl],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserConstants.userUid: userUid,
      UserConstants.userEmailAddress: userEmailAddress,
      UserConstants.userName: userName,
      UserConstants.userPhotoUrl: userPhotoUrl,
    };
  }
}
