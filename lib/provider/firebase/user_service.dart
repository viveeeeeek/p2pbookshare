import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:simple_logger/simple_logger.dart';

class FirebaseUserService with ChangeNotifier {
  final logger = SimpleLogger();

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
      logger.info('Error retrieving books from Firestore: $e');
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
      logger.info('Error adding address to user: $e');
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
      logger.info("Error checking user collection: $e");
      return false;
    }
  }

  /// Method to create user collection
  Future<void> createUserCollection(String userUid, UserModel userModel) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userUid).set(
          userModel.toMap()); // Assuming toMap() converts UserModel to a Map
    } catch (e) {
      logger.info('Error creating user collection: $e');
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
      logger.info('Error retrieving user details from Firestore: $e');
      return null;
    }
  }
}
