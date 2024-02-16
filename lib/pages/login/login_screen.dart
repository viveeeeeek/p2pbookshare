import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/login/widgets/signin_button.dart';
import 'package:rive/rive.dart' as rive;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          backgroundColor: Colors.black87,
          body: Stack(
            children: [
              const Positioned(
                left: -375,
                top: -5,
                child: SizedBox(
                    height: 600,
                    width: 600,
                    child: rive.RiveAnimation.asset(
                        'assets/rive_assets/materialyou-sphere.riv')),
              ),
              const Positioned(
                top: 25,
                right: -100,
                child: SizedBox(
                    height: 300,
                    width: 300,
                    child: rive.RiveAnimation.asset(
                        'assets/rive_assets/materialyou-sphere.riv',
                        fit: BoxFit.contain)),
              ),
              const Positioned(
                top: 350,
                right: -120,
                child: SizedBox(
                    height: 330,
                    width: 330,
                    child: rive.RiveAnimation.asset(
                        'assets/rive_assets/materialyou-sphere.riv',
                        fit: BoxFit.contain)),
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      tileMode:
                          TileMode.clamp, // Use TileMode.clamp for dithering
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.75),
                        Colors.black.withOpacity(0.5),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 150,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GSignInButton(
                        height: constraints.maxHeight * 0.08,
                        width: constraints.maxWidth * 0.7,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
