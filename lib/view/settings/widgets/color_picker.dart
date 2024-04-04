// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/provider/theme/app_theme_service.dart';

Widget colorPicker(BuildContext context, Color containerColor) {
  final themeProvider = Provider.of<AppThemeService>(context);
  final appThemeSharedPrefsProvider = Provider.of<AppThemePrefs>(context);

  return Material(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    //! HERE WE USED INK WITH INKWELL TO GET RID OF DEFAULT SQUARE SHAPED INK SPLASH EEFECT FOR INKWELL WIDGET
    child: Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(60),
      ),
      child: InkWell(
        onTap: () {
          themeProvider.setThemeColor(containerColor);
          appThemeSharedPrefsProvider.saveThemeColor(containerColor);
        },
        borderRadius: BorderRadius.circular(15.0),
        child: SizedBox(
          height: 60,
          width: 60,
          child: Center(
            child: Container(
              width: 45.0, // Adjust the size as needed
              height: 45.0, // Adjust the size as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: containerColor, // Change this color if needed
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
