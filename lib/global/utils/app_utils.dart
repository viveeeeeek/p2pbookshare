import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class Utils {
  static snackBar(
      {required BuildContext context,
      required String message,
      required String actionLabel,
      required int durationInSecond,
      required Function()? onPressed}) {
    //FIXME For some unkown reason duration is not working so we manually dismiss the snackbar for now
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: Duration(seconds: durationInSecond),
        action: SnackBarAction(
          label: actionLabel,
          onPressed: onPressed ?? () {},
        ),
      ),
    );
    Future.delayed(Duration(seconds: durationInSecond), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  static alertDialog(
      {required BuildContext context,
      required String title,
      required description,
      required actionButtonText,
      required void Function()? onTapActionButton}) {
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
          onPressed: onTapActionButton ?? () {},
          child: Text(actionButtonText),
        ),
      ],
    );
  }

  static progressIndicator({required double height, required double width}) {
    return SizedBox(
      height: height,
      width: width,
      child: const rive.RiveAnimation.asset(
          'assets/rive_assets/materialyou-sphere.riv'),
    );
  }
}
