import 'package:flutter/material.dart';

import 'package:p2pbookshare/core/app_init_handler.dart';

class AppThemeService extends ChangeNotifier {
  Color _themeColor;
  bool _isDarkThemeEnabled;

  AppThemeService(this._isDarkThemeEnabled, Color? themeColor)
      : _themeColor = themeColor ?? Colors.blue;

  // Getter for theme color
  Color get themeColor => _themeColor;

  // Modify setThemeColor to accept a Color argument
  void setThemeColor(Color? color) {
    if (color != null) {
      _themeColor = color;
      notifyListeners();
    }
  }

  // Default to follow system theme initially
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get currentThemeMode => _themeMode;

  bool get isDarkThemeEnabled => _isDarkThemeEnabled;

  void setIsDarkThemeToggled(bool value) {
    _isDarkThemeEnabled = value;
    notifyListeners();
  }

  void toggleThemeMode() {
    if (isDarkThemeEnabled == true) {
      _isDarkThemeEnabled = true;
      _themeMode = ThemeMode.dark;
      logger.i('✅✅Temeprovidr; theme toggled $currentThemeMode');
    } else {
      _isDarkThemeEnabled = false;
      _themeMode = ThemeMode.light;
      logger.i('✅✅Temeprovider; theme toggled $currentThemeMode');
    }
    notifyListeners();
  }
}
