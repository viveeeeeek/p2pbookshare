import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/utils/extensions/color_extension.dart';
import 'package:p2pbookshare/views/login/widgets/g_signin_button.dart';
import 'package:rive/rive.dart' as rive;
//FIXME: Cancelling google-sign-in abruptly stops app. handle sign-in cancelled case

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: -150,
              top: -50,
              child: SizedBox(
                height: 450,
                width: 450,
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(context.secondary, BlendMode.srcIn),
                  child: const rive.RiveAnimation.asset(
                      'assets/rive_assets/materialyou-sphere.riv'),
                ),
              ),
            ),
            Positioned(
              right: -75,
              top: 225,
              child: SizedBox(
                height: 225,
                width: 225,
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(context.secondary, BlendMode.srcIn),
                  child: const rive.RiveAnimation.asset(
                      'assets/rive_assets/materialyou-shape2.riv'),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "P2P BookShare:\nShare, Borrow, Learn - Your Campus Book Exchange",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Unlock Affordable Learning, Foster Community, and Share Knowledge!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Dive into P2P BookShare: affordable learning, convenience, and collaborative sharing with fellow students. Unite textbooks and community spirit by signing in now! Let's make education budget-friendly and connected.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 40.0),
                  Center(
                    child: GSignInButton(
                      height: constraints.maxHeight * 0.08,
                      width: constraints.maxWidth * 0.8,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
