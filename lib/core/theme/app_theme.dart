/// IMPLEMENTED DYNAMICOLOUR SWITCH WITH PROVIDER (CURRENTLY ONLY FOR DARK DYNAMIC THEME)

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/provider/theme/app_theme_service.dart';

ColorScheme getLightColorScheme(
    BuildContext context, ColorScheme? lightDynamic) {
  final themeProvider = Provider.of<AppThemeService>(context);
  final appThemeSharedPrefsProvider = Provider.of<AppThemePrefs>(context);

  bool isDynamic = appThemeSharedPrefsProvider.isDynamiThemeEnabled;

  try {
    if (lightDynamic != null && isDynamic == true) {
      return lightDynamic.harmonized();
    } else {
      return ColorScheme.fromSeed(
        seedColor: themeProvider.themeColor,
        brightness: Brightness.light,
      );
    }
  } catch (e) {
    // print('Error getting light color scheme: $e');
    return const ColorScheme.light(); // Return a default color scheme on error
  }
}

ColorScheme getDarkColorScheme(BuildContext context, ColorScheme? darkDynamic) {
  final themeProvider = Provider.of<AppThemeService>(context);
  final themeSharedPreferences = Provider.of<AppThemePrefs>(context);
  bool isDynamicEnabled = themeSharedPreferences.isDynamiThemeEnabled;

  try {
    if (darkDynamic != null && isDynamicEnabled == true) {
      return darkDynamic.harmonized();
    } else {
      return ColorScheme.fromSeed(
        seedColor: themeProvider.themeColor,
        brightness: Brightness.dark,
      );
    }
  } catch (e) {
    // print('Error getting dark color scheme: $e');
    return const ColorScheme.dark(); // Return a default color scheme on error
  }
}

TextTheme buildDarkTextTheme() {
  return GoogleFonts.outfitTextTheme().apply(
    bodyColor: Colors.white, // Set the text color for dark theme
    displayColor: Colors.white, // Set the text color for dark theme
  );
}

TextTheme buildLightTextTheme() {
  return GoogleFonts.outfitTextTheme().apply(
    bodyColor: Colors.black, // Set the text color for dark theme
    displayColor: Colors.black, // Set the text color for dark theme
  );
}
