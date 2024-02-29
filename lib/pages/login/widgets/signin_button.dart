import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
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
    final _signInHandler = SignInhandler();
    return Consumer<AuthorizationService>(builder: (context, authProvider, _) {
      return SizedBox(
        height: height,
        width: width,
        child: FilledButton(
          style: ElevatedButton.styleFrom(backgroundColor: context.secondary),
          onPressed: () {
            _signInHandler.handleSignIn(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              authProvider.getIsSigningIn
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : SvgPicture.asset('assets/icons/ic_google.svg',
                      colorFilter:
                          ColorFilter.mode(context.onPrimary, BlendMode.srcIn),
                      width: 33,
                      height: 33),
              const Text(
                "Sign in with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
