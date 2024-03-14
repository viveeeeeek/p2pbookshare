// Create a function to handle sign-in and user creation
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:p2pbookshare/view/landing_view.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';

class LoginViewModel {
  Future<void> handleSignIn(BuildContext context) async {
    final authProvider =
        Provider.of<AuthorizationService>(context, listen: false);
    final fbUserOperations =
        Provider.of<FirebaseUserService>(context, listen: false);
    final logger = SimpleLogger();

    try {
      await authProvider.gSignIn(context);
      final user = authProvider.user;
      if (user != null) {
        UserModel userModel = UserModel(
          userUid: user.uid,
          userEmailAddress: user.email,
          userName: user.displayName,
          userPhotoUrl: user.photoURL,
        );
        final collectionExists =
            await fbUserOperations.userCollectionExists(user.uid);
        if (!collectionExists) {
          await fbUserOperations.createUserCollection(user.uid, userModel);
          logger.info("✅collection creation is complete");
        }

        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LandingView()));
      }
    } catch (e) {
      logger.warning("❌Error during sign-in or user creation: $e");
    }
  }

  // isSigningIn<bool>(BuildContext context) {
  //   final authProvider =
  //       Provider.of<AuthorizationService>(context, listen: false);
  //   if (authProvider.getIsSigningIn) {
  //     logger.info('✅Is signingIn TRUE');
  //     return true;
  //   } else {
  //     logger.info('❌Is signingIn FALSE');
  //     return false;
  //   }
  // }
}

//TODO: Instead of creating new method for cheking is signedin directly check from authentication providers bool value righ into above function