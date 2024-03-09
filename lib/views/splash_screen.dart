import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/utils/app_utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Utils.progressIndicator(height: 100, width: 100),
      ),
    );
  }
}
