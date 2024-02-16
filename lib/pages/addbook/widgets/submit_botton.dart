import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback
      onPressed; // Use VoidCallback for functions with no arguments and no return value
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: FilledButton(
        onPressed: onPressed,
        child: Center(child: child),
      ),
    );
  }
}
