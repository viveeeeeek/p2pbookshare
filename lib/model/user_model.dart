// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';

/// The UserModel class represents a user with properties such as userUid, userEmail, userName, and
/// userPhotoUrl, and provides methods to convert the object to and from a Map.

class UserModel {
  final String? userUid, emailAddress, displayName, profilePictureUrl, username;

  UserModel(
      {required this.userUid,
      required this.emailAddress,
      required this.displayName,
      required this.profilePictureUrl,
      this.username});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map[UserConstants.username],
      userUid: map[UserConstants.userUid],
      emailAddress: map[UserConstants.emailAddress],
      displayName: map[UserConstants.displayName],
      profilePictureUrl: map[UserConstants.profilePictureUrl],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserConstants.userUid: userUid,
      UserConstants.username: username,
      UserConstants.emailAddress: emailAddress,
      UserConstants.displayName: displayName,
      UserConstants.profilePictureUrl: profilePictureUrl,
    };
  }
}
