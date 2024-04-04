// Create a function to handle sign-in and user creation
// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view/landing_view.dart';

class LoginViewModel {
  Future<void> handleSignIn(BuildContext context) async {
    final authProvider =
        Provider.of<AuthorizationService>(context, listen: false);
    final fbUserOperations =
        Provider.of<FirebaseUserService>(context, listen: false);
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
      await authProvider.gSignIn(context);
      final user = authProvider.user;
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
        final collectionExists =
            await fbUserOperations.userCollectionExists(user.uid);
        if (!collectionExists) {
          await fbUserOperations.createUserCollection(user.uid, userModel);
          logger.i("✅collection creation is complete");
        }

        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LandingView()));
      }
    } catch (e) {
      logger.e("❌Error during sign-in or user creation: $e");
    }
  }
}
