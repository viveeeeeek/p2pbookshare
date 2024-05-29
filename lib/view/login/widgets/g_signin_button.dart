// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/services/authentication/authentication.dart';

class GSignInButton extends StatelessWidget {
  const GSignInButton({
    super.key,
    required this.height,
    required this.width,
    required this.onPressed,
  });

  final double height, width;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorizationService>(builder: (context, authProvider, _) {
      return SizedBox(
        height: height,
        width: width,
        child: FilledButton(
          style: ElevatedButton.styleFrom(backgroundColor: context.secondary),
          onPressed: onPressed,
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
