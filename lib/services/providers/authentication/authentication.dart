// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/user_data_prefs.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';

class AuthorizationService with ChangeNotifier {
  User? user;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  final UserDataPrefs sharedPrefsProvider = UserDataPrefs();
  final logger = SimpleLogger();

  GoogleSignInAuthentication? googleAuth;
  GoogleSignInAccount? googleUser;
  bool _isSigningIn = false;
  bool get getIsSigningIn => _isSigningIn;
  bool isInternetAvlbl = false;
  bool _isDomainValid = false;
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
    //// Check if the user is already authenticated
    if (user != null) {
      //// User is already signed in,  You can handle this case or show a message to the user
      return;
    }
    _isSigningIn = true;
    notifyListeners();
  }

  isInternetConnection(context) async {
    //// Checks fi internet connection is available
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _isSigningIn = false; //// No internet - isSigning false
      isInternetAvlbl = false;
      notifyListeners();

      Utils.snackBar(
          context: context,
          message: 'No internet connection available :/',
          actionLabel: 'Ok',
          durationInSecond: 2,
          onPressed: () => {});
    } else {
      isInternetAvlbl = true;
      notifyListeners();
    }
  }

  validateDomainForSignIn(context) async {
    if (!googleUser!.email.endsWith('@dypvp.edu.in')) {
      // Show a message or take action to inform the user they're not allowed to sign up
      googleUser?.clearAuthCache();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-up not allowed with this email domain'),
        ),
      );
      _isSigningIn = false;
      // Reset GoogleSignIn instance and state after domain restriction
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      notifyListeners();
      //// Domain is not valid
    } else {
      _isDomainValid = true;
    }
  }

  //! SIGN-IN-WITH-GOOGLE
  Future<void> gSignIn(BuildContext context) async {
    try {
      await isInternetConnection(context);
      await isUserSignedIn();
      //// If internet is available then only prompt to choose google accont
      isInternetAvlbl ? googleUser = await googleSignIn.signIn() : Null;
      //// Handle exception if user cancels G-Sign-In and return early
      if (googleUser == null) {
        // Reset _isSigningIn state on cancellation
        _isSigningIn = false;
        // Reset GoogleSignIn instance on cancellation
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
        notifyListeners();
        return;
      }
      googleAuth = await googleUser?.authentication;
      //// validate domain organization
      await validateDomainForSignIn(context);
      // // Extracting the email from the user's profile
      // // Check if the user's email contains the allowed domain
      if (_isDomainValid) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        user = userCredential.user;
        notifyListeners();
        if (user != null) {
          //// Setting to false to clear circularloading indicator on gsignin button
          _isSigningIn = false;
          //// Storing user data to shared_preferencesfor later use
          await sharedPrefsProvider.saveUserToPrefs(user);
          ///// Storing user credentials in flutter_secure_storage to check user login status in next app launch
          await storeTokenAndData(userCredential);
          ////
          await loadUserData(context);
          //// Navigating to home
        } else {
          logger.warning("❌Sign-in failed");
        }
      }
    } catch (e) {
      logger.warning("❌Error during sign-in: $e");
      _isSigningIn = false;
      notifyListeners();
    }
  }

//! G-SIGN-OUT METHOD
  Future<void> gSignOut(context) async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    sharedPrefsProvider.clearUserFromPrefs();
    user = null;

    logger.info('🥲User Signed out ');
    //// Navigating to homepage once successfully logged in
    notifyListeners();
  }

//! Storing user token & data in flutter secured storage
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
}
