import 'package:flutter/material.dart';
import 'package:p2pbookshare/app_init_handler.dart';

class AppThemeService extends ChangeNotifier {
  Color _themeColor = Colors.blue;
  // Getter for theme color
  Color get themeColor => _themeColor;
  // Modify setThemeColor to accept a Color argument
  void setThemeColor(Color? color) {
    if (color != null) {
      _themeColor = color;
      notifyListeners();
    }
  }
  //TODO: By default set dynamic theme to off as it will not work on devices below a12

  // Default to follow system theme initially
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get currentThemeMode => _themeMode;
  bool _isDarkThemeEnabled = false;
  bool get isDarkThemeEnabled => _isDarkThemeEnabled;

  void setIsDarkThemeToggled(bool value) {
    _isDarkThemeEnabled = value;
    notifyListeners();
  }

  void toggleThemeMode() {
    if (isDarkThemeEnabled == true) {
      _isDarkThemeEnabled = true;
      _themeMode = ThemeMode.dark;
      logger.info('✅✅Temeprovidr; theme toggled $currentThemeMode');
    } else {
      _isDarkThemeEnabled = false;
      _themeMode = ThemeMode.light;
      logger.info('✅✅Temeprovider; theme toggled $currentThemeMode');
    }
    notifyListeners();
  }
}
