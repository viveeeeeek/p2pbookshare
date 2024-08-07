// ignore_for_file: use_build_context_synchronously

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/services/shared_prefs/user_data_prefs.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';

class AuthorizationService with ChangeNotifier {
  User? user;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  final UserDataPrefs sharedPrefsProvider = UserDataPrefs();
  GoogleSignInAuthentication? googleAuth;
  GoogleSignInAccount? googleUser;
  bool _isSigningIn = false;
  bool get getIsSigningIn => _isSigningIn;
  setIsSigningIn(bool value) {
    _isSigningIn = value;
    notifyListeners();
  }

  bool isInternetAvlbl = false;
  // ignore: unused_field
  bool _isDomainValid = false;
  bool get isDomainValid => _isDomainValid;
  final String _userid = '';
  String get getUserUid => _userid;
  final String _useremail = '';
  String get getUserEmail => _useremail;
  final String _userdisplayname = '';
  String get getUserDisplayName => _userdisplayname;
  final String _userphotourl = '';
  String get getUserPhotoUrl => _userphotourl;

  Future<void> loadUserData(BuildContext context) async {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    userDataProvider.loadUserDataFromPrefs();
  }

  isUserSignedIn() {
    // Check if the user is already authenticated
    if (user != null) {
      // User is already signed in,  You can handle this case or show a message to the user
      return;
    }
    _isSigningIn = true;
    notifyListeners();
  }

  /// Method to validate domain organization
  /// If the user's email contains the allowed domain, proceed with sign-in
  /// Else, show a message or take action to inform the user they're not allowed to sign up
  /// Reset GoogleSignIn instance and state after domain restriction
  //FIXME: Instead of showing snackbar here use isDomainValid flag and show snackbar in loginHandler
  // bool validateDomainForSignIn() {
  //   if (!googleUser!.email.endsWith('@dypvp.edu.in')) {
  // Show a message or take action to inform the user they're not allowed to sign up
  // if (context.mounted) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Sign-up not allowed with this email domain'),
  //     ),
  //   );
  // }

  //     _isSigningIn = false;
  //     _isDomainValid = true;
  //     logger.i('Set domain validation: $_isDomainValid');
  //     googleUser?.clearAuthCache();
  //     // Reset GoogleSignIn instance and state after domain restriction
  //     googleSignIn.disconnect();
  //     googleSignIn.signOut();
  //     notifyListeners();
  //     return false; // Domain is not valid
  //   } else {
  //     _isDomainValid = true;
  //     return true; // Domain is valid
  //   }
  // }

  Future<void> gSignIn(BuildContext context) async {
    try {
      await isUserSignedIn();

      googleUser = await googleSignIn.signIn();

      // If user cancels Google Sign-In, reset state and return early
      if (googleUser == null) {
        _resetSignInState();
        return;
      }

      googleAuth = await googleUser?.authentication;

      // Validate domain organization
      // _isDomainValid = await validateDomainForSignIn();
      notifyListeners();
      logger.i('Domain validation: $_isDomainValid');

      // If the user's email contains the allowed domain, proceed with sign-in
      // if (_isDomainValid) {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = userCredential.user;
      notifyListeners();

      if (user != null) {
        _isSigningIn = false;
        _isUserLoggedIn = true;
        await _storeUserData(context, user!, userCredential);
      } else {
        logger.e("Sign-in failed");
      }
      // } else {}
    } catch (e) {
      logger.e("Error during sign-in: $e");
      _resetSignInState();
    }
  }

  void _resetSignInState() async {
    _isSigningIn = false;
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    notifyListeners();
  }

  Future<void> _storeUserData(
      BuildContext context, User user, UserCredential userCredential) async {
    // Store user data to shared preferences for later use
    await sharedPrefsProvider.saveUserToPrefs(user);

    // Store user credentials in flutter secure storage to check user login status in next app launch
    await storeTokenAndData(userCredential);

    // Load user data
    await loadUserData(context);
  }

//! G-SIGN-OUT METHOD
  /// Method to sign out from google and firebase Also clearing user data from shared preferences and flutter secured storage
  Future<void> gSignOut(context) async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    user = null;
    // Set user login status to false
    _isUserLoggedIn = false;
    logger.i('🥲User Signed out ');
    // Navigating to homepage once successfully logged in
    notifyListeners();
  }

//! Storing user token & data in flutter secured storage
  /// to check user login status in next app launch and to keep user logged in
  final storage = const FlutterSecureStorage();
  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

//!Clearing user token & data from flutter secured storage
  Future<void> removeTokenAndData() async {
    await storage.delete(key: "token");
    await storage.delete(key: "userCredential");
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn => _isUserLoggedIn;

  void updateUserLoginStatus(bool isLoggedIn) {
    _isUserLoggedIn = isLoggedIn;
    notifyListeners();
  }
}
