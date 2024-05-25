// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataPrefs with ChangeNotifier {
  SharedPreferences? _prefs;
/*
 Instead of initializing SharedPreferences in every method,
 we can create a private field to hold the shared preferences instance once and reuse it.
*/
  Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  //! SAVE USER TO SHARED-PREFERENCES
  Future<void> saveUserToPrefs(User? user) async {
    await initPrefs();
    _prefs!.setString('user_id', user?.uid ?? '');
    _prefs!.setString('user_name', user?.displayName ?? '');
    _prefs!.setString('user_email', user?.email ?? '');
    _prefs!.setString('user_photo_url', user?.photoURL ?? '');
  }

  //! LOADING USER DATA FROM SHARED-PREFERENCES
  Future<User?> loadUserFromPrefs() async {
    await initPrefs();
    final userId = _prefs!.getString('user_id');
    if (userId != null && userId.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      return user;
    }
    return null;
  }

//! REMOVE USER-DATA FROM SHARED-PREFERENCES
  Future<void> clearUserFromPrefs() async {
    await initPrefs();
    _prefs!.remove('user_id');
    _prefs!.remove('user_name');
    _prefs!.remove('user_email');
    logger.i("🗑️user data removed from shared-preferences");
  }
}
