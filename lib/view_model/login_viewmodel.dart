// Create a function to handle sign-in and user creation
// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Package imports:
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:p2pbookshare/core/utils/app_utils.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/services/fcm/notification_service.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/services/authentication/authentication.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';

class LoginViewModel {
  late AuthorizationService _authService;
  late FirebaseUserService _fbUserService;
  late UserDataProvider _userDataProvider;

  /// method to generate random 6-7 letter meaningful word from given string nd use it as a username
  String generateUserName(String email) {
    String username = email.split('@')[0];
    String randomString = username.substring(0, min(8, username.length));

    const _randomChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _randStringLength = 5;
    Random _rnd = Random();

    return randomString +
        String.fromCharCodes(Iterable.generate(_randStringLength,
            (_) => _randomChars.codeUnitAt(_rnd.nextInt(_randomChars.length))));
  }

  Future<bool> isInternetConnection(context) async {
    final authService =
        Provider.of<AuthorizationService>(context, listen: false);
    // Checks if internet connection is available
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Utils.snackBar(
          context: context,
          message: 'No internet connection available :/',
          actionLabel: 'Ok',
          durationInSecond: 2,
          onPressed: () => {});
      authService.setIsSigningIn(false);
      return false;
    } else {
      authService.setIsSigningIn(true);
      return true;
    }
  }

  Future<void> handleSignIn(BuildContext context) async {
    _authService = Provider.of<AuthorizationService>(context, listen: false);
    _fbUserService = Provider.of<FirebaseUserService>(context, listen: false);
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);

    if (!await isInternetConnection(context)) {
      return;
    }

    try {
      await _authService.gSignIn(context);

      final user = _authService.user;
      if (user != null) {
        await _handleUserLogin(context, user);
      }
    } catch (e) {
      logger.e("❌Error during sign-in or user creation: $e");
    }
  }

  Future<void> _handleUserLogin(BuildContext context, User user) async {
    final _username = await generateUserName(user.email!);
    logger.i('newly generated username is $_username');

    NotificationService _notificationService = NotificationService();
    var deviceToken = await _notificationService.getDeviceToken();
    logger.d('Device Token: $deviceToken');

    UserModel userModel = UserModel(
      userUid: user.uid,
      username: _username,
      emailAddress: user.email,
      displayName: user.displayName,
      profilePictureUrl: user.photoURL,
      deviceToken: deviceToken.isNotEmpty ? deviceToken : null,
    );

    _userDataProvider.setUserModel(userModel);
    final collectionExists =
        await _fbUserService.userCollectionExists(user.uid);
    if (!collectionExists) {
      await _fbUserService.createUserCollection(user.uid, userModel);
      logger.i("✅collection creation is complete");
    } else {
      final existingUserModel =
          await _fbUserService.getUserDetailsById(user.uid);
      if (existingUserModel != null) {
        _userDataProvider.setUserModel(UserModel.fromMap(existingUserModel));
      } else {
        await _fbUserService.createUserCollection(user.uid, userModel);
      }
    }

    if (context.mounted) {
      context.goNamed(AppRouterConstants.landingView);
    }
  }
}

// void _showInvalidDomainSnackBar(BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text('Sign-up not allowed with this email domain'),
//     ),
//   );
// }
