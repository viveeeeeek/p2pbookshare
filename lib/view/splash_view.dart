import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/utils/app_utils.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Utils.progressIndicator(height: 100, width: 100),
      ),
    );
  }
}
