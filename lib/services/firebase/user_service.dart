// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p2pbookshare/core/utils/logging.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/model/user_model.dart';

class FirebaseUserService with ChangeNotifier {
  /// Get the current user's UID
  String? getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      return uid;
    } else {
      return null; // No user is signed in
    }
  }

  Stream<List<Map<String, dynamic>>> fetchUserAddresses(String userUid) {
    try {
      CollectionReference addressesCollection =
          FirebaseFirestore.instance.collection('users/$userUid/addresses');
      Query query = addressesCollection;
      return query.snapshots().map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return [];
        }
        return querySnapshot.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      logger.i('Error retrieving books from Firestore: $e');
      return Stream.value([]);
    }
  }

  Future<void> addAddressToUser(
      String userId, Map<String, dynamic> address) async {
    try {
      CollectionReference userAddressesCollection =
          FirebaseFirestore.instance.collection('users/$userId/addresses');
      // Add a new document with a unique ID
      await userAddressesCollection.add(address);
    } catch (e) {
      logger.i('Error adding address to user: $e');
      // Handle the error as needed
    }
  }

  /// Method to check users collection exists or not
  Future<bool> userCollectionExists(String userUid) async {
    try {
      final userCollection = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      return userCollection.exists;
    } catch (e) {
      logger.i("Error checking user collection: $e");
      return false;
    }
  }

  /// Method to check if device token exists or not in user document
  Future<String?> getUserDeviceToken(
    String userUid,
  ) async {
    try {
      final userCollection = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      final userData = userCollection.data() as Map<String, dynamic>;
      if (userData.containsKey(UserConstants.deviceToken)) {
        logger.d('Device token found: ${userData[UserConstants.deviceToken]}');
        return userData[UserConstants.deviceToken];
      } else {
        return null;
      }
    } catch (e) {
      logger.i("Error checking device token: $e");
      return null;
    }
  }

  /// Method to update device token in user document
  Future<void> updateUserDeviceToken(
    String userUid,
    String deviceToken,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .update({UserConstants.deviceToken: deviceToken});
      logger.i('Device token updated successfully');
    } catch (e) {
      logger.i('Error updating device token: $e');
    }
  }

  /// Method to create user collection
  Future<void> createUserCollection(String userUid, UserModel userModel) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userUid).set(
          userModel.toMap()); // Assuming toMap() converts UserModel to a Map
    } catch (e) {
      logger.i('Error creating user collection: $e');
    }
  }

  /// Method to get user details by user ID
  Future<Map<String, dynamic>?> getUserDetailsById(String userId) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await usersCollection
          .where(UserConstants.userUid, isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // Return null if no matching user is found
      }

      var document = querySnapshot.docs.first;
      var userData = document.data() as Map<String, dynamic>;

      return userData;
    } catch (e) {
      logger.i('Error retrieving user details from Firestore: $e');
      return null;
    }
  }
}
