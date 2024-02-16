import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p2pbookshare/pages/login/login_handler.dart';
import 'package:p2pbookshare/services/providers/authentication/authentication.dart';
import 'package:provider/provider.dart';

class GSignInButton extends StatelessWidget {
  const GSignInButton({
    super.key,
    required this.height,
    required this.width,
  });

  final double height, width;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorizationService>(builder: (context, authProvider, _) {
      return SizedBox(
          height: height,
          width: width,
          child: ElevatedButton(
            onPressed: () {
              SignInhandler().handleSignIn(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  Theme.of(context).buttonTheme.colorScheme?.primary ??
                      Colors.amber,
              foregroundColor:
                  Theme.of(context).buttonTheme.colorScheme?.onPrimary ??
                      Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                authProvider.getIsSigningIn
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : SvgPicture.asset('assets/icons/ic_google.svg',
                        width: 33, height: 33),
                const Text(
                  "Sign in with Google",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ));
    });
  }
}
