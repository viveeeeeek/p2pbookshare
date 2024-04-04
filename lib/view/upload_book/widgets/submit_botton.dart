import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.height,
    required this.width,
  });

  final VoidCallback
      onPressed; // Use VoidCallback for functions with no arguments and no return value
  final Widget child;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          height: height,
          width: width,
          child: FilledButton(
            onPressed: onPressed,
            child: Center(
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
