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
      userUid: map['useruid'],
      userEmailAddress: map['useremail'],
      userName: map['username'],
      userPhotoUrl: map['userphotourl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'useruid': userUid,
      'useremail': userEmailAddress,
      'username': userName,
      'userphotourl': userPhotoUrl,
    };
  }
}
