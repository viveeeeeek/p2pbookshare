// Create a function to handle sign-in and user creation
// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Package imports:
import 'package:logger/logger.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';

class LoginViewModel {
  late AuthorizationService _authService;
  late FirebaseUserService _fbUserService;
  late UserDataProvider _userDataProvider;
  Future<void> handleSignIn(BuildContext context) async {
    _authService = Provider.of<AuthorizationService>(context, listen: false);
    _fbUserService = Provider.of<FirebaseUserService>(context, listen: false);
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    var logger = Logger();

    /// method to generate random 6-7 letter meaningful word from given string
    /// and use it as a username
    String generateUserName(String email) {
      String username = email.split('@')[0];
      String randomString = '';
      for (int i = 0; i < 8; i++) {
        randomString += username[i];
      }

      // Generate a random string
      const _randomChars =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      const _randStringLength = 5; // number of characters to generate
      Random _rnd = Random();

      for (int i = 0; i < _randStringLength; i++) {
        randomString += _randomChars[_rnd.nextInt(_randomChars.length)];
      }

      return randomString;
    }

    try {
      await _authService.gSignIn(context);
      final user = _authService.user;
      if (user != null) {
        final _username = await generateUserName(user.email!);
        logger.i('newly generated username is $_username');
        UserModel userModel = UserModel(
          userUid: user.uid,
          username: _username,
          emailAddress: user.email,
          displayName: user.displayName,
          profilePictureUrl: user.photoURL,
        );

        /// Onece user logs in, the user data is loadsed in provider to be used in app
        _userDataProvider.setUserModel(userModel);
        final collectionExists =
            await _fbUserService.userCollectionExists(user.uid);
        if (!collectionExists) {
          final _username = await generateUserName(user.email!);
          logger.i('newly generated username is $_username');
          await _fbUserService.createUserCollection(user.uid, userModel);
          logger.i("✅collection creation is complete");
        } else {
          final existingUserModel =
              await _fbUserService.getUserDetailsById(user.uid);

          /// create usermodel using Future<Map<String, dynamic>?> returned by getuserdetailsbyId
          /// if usermodel is not null, use it, else use the newly created usermodel
          /// if usermodel is null, it means the user is logging in for the first time
          if (existingUserModel != null) {
            _userDataProvider
                .setUserModel(UserModel.fromMap(existingUserModel));
          } else {
            await _fbUserService.createUserCollection(user.uid, userModel);
          }
        }

        if (context.mounted) {
          context.goNamed(AppRouterConstants.landingView);
        }
      }
    } catch (e) {
      logger.e("❌Error during sign-in or user creation: $e");
    }
  }
}
