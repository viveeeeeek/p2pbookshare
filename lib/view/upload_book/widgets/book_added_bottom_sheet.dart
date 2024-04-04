import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

//! Book added Bootom Sheet
bookAddedBottomSheet(
    BuildContext context, String? uploadedImgUrl, String? bookName) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 400,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 250,
              width: 250,
              child: rive.RiveAnimation.asset(
                'assets/rive_assets/gpay_check_mark.riv',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '"$bookName" added successfully!',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Continue")),
          ],
        ),
      );
    },
  );
}
