import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CustomProgressIndicator(
        height: 150,
        width: 150,
      )),
    );
  }
}
