import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator(
      {super.key, required this.height, required this.width});

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: const rive.RiveAnimation.asset(
          'assets/rive_assets/materialyou-sphere.riv'),
    );
  }
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar(
      {super.key,
      required this.message,
      required this.actionLabel,
      required this.durationInSecond,
      this.onPressed});

  final String message, actionLabel;
  final int durationInSecond;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onPressed ?? () {},
      ),
    );
  }
}

showCustomSnackBar(BuildContext context, String message, String actionLabel,
    int durationInSecond, Function()? onPressed) {
  // Clear any existing Snackbars
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onPressed ?? () {},
      ),
      //! For some unkown reason duration is not working so we manually dismiss the snackbar
      // duration: const Duration(seconds: 1),
    ),
  );
  // Manually dismiss the Snackbar after a custom duration
  Future.delayed(Duration(seconds: durationInSecond), () {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  });
}

class CustomAlertDialog extends StatelessWidget {
  final Function? onEnableLocationPressed;
  final String title, description, actionButtonText;

  const CustomAlertDialog(
      {super.key,
      this.onEnableLocationPressed,
      required this.title,
      required this.description,
      required this.actionButtonText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(description),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: onEnableLocationPressed as void Function()? ?? () {},
          child: Text(actionButtonText),
        ),
      ],
    );
  }
}

// Inside your StatefulWidget or StatelessWidget
showPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: 'title',
        description: 'description',
        actionButtonText: 'Button',
        onEnableLocationPressed: () {
          // Add code to handle enabling location services here
          // For example, open device settings to enable location services
          // You can use packages like 'url_launcher' to launch settings
          // url_launcher: https://pub.dev/packages/url_launcher
        },
      );
    },
  );
}
