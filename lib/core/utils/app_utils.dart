// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rive/rive.dart' as rive;

class Utils {
  /// Custom snackbar
  static snackBar(
      {required BuildContext context,
      required String message,
      required String actionLabel,
      required int durationInSecond,
      Function()? onPressed}) {
    //HACK: For some unkown reason duration is not working so we manually dismiss the snackbar for now
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

  /// Custom rive progress indicator
  static progressIndicator({required double height, required double width}) {
    return SizedBox(
      height: height,
      width: width,
      child: const rive.RiveAnimation.asset(
          'assets/rive_assets/materialyou-sphere.riv'),
    );
  }

  /// Custom dialog
  static showCustomDialog(
      {required BuildContext context,
      required String title,
      required String cancelButtonText,
      required String confirmButtonText,
      required VoidCallback onCancel,
      required VoidCallback onConfirm,
      required List<Widget> children,
      required EdgeInsetsGeometry padding}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: IntrinsicHeight(
            child: Padding(
              padding: padding,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onCancel,
              child: Text(cancelButtonText),
            ),
            FilledButton(
              onPressed: onConfirm,
              child: Text(confirmButtonText),
            ),
          ],
        );
      },
    );
  }

  static alertDialog({
    required BuildContext context,
    required String title,
    required String description,
    required void Function() onConfirm,
    required String actionText,
    bool? cancelButton = false,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            cancelButton == true
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  )
                : const SizedBox(),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   child: const Text("Cancel"),
            // ),
            FilledButton(
              onPressed: onConfirm,
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }
}
