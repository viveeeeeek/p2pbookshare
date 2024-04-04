import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_logger/simple_logger.dart';

class AppThemePrefs with ChangeNotifier {
  final logger = SimpleLogger();
  SharedPreferences? _prefs;
  //TODO: Change to final and create getters
  bool isDynamiThemeEnabled = false;
  bool isThemeToggled = false;

  /// We can create a private field to create and hold the shared preferences instance and reuse it.
  Future<void> initSharedPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveIsDarkThemeEnabled(bool value) async {
    try {
      await initSharedPrefs();
      await _prefs!.setBool('isLightThemeToggled', value);
      isThemeToggled = value;
      notifyListeners();
      logger.info(
          'AppThemePrefs (saveIsDarkThemeEnabled): dark theme status saved to shared prefs $isThemeToggled');
    } catch (e) {
      logger.info('Error saving dynamic color: $e');
    }
  }

  Future<bool> loadIsDarkThemeEnabled() async {
    try {
      await initSharedPrefs();
      isThemeToggled = _prefs!.getBool('isLightThemeToggled') ?? true;
      notifyListeners();
      logger.info(
          'AppThemePrefs (loadIsDarkThemeEnabled): dark theme status fetched from shared prefs $isThemeToggled');
      return isThemeToggled;
    } catch (e) {
      isThemeToggled = true;
      notifyListeners();
      logger.info('Error loading theme mode: $e');
      return isThemeToggled;
    }
  }

  // Future<void> loadIsDynamicColorEnabled() async {
  //   try {
  //     await initSharedPrefs();
  //     isDynamiThemeEnabled = _prefs!.getBool('isDynamicColorSelected') ?? true;
  //     notifyListeners();
  //     logger.info(
  //         'AppThemePrefs (loadIsDynamicColorEnabled): dynamic color status fetched from shared prefs $isThemeToggled');
  //   } catch (e) {
  //     logger.info('Error loading dynamic color: $e');
  //   }
  // }

  Future<bool> loadIsDynamicColorEnabled() async {
    try {
      await initSharedPrefs();
      isDynamiThemeEnabled = _prefs!.getBool('isDynamicColorSelected') ?? true;
      notifyListeners();
      logger.info(
          'AppThemePrefs (loadIsDynamicColorEnabled): dynamic color status fetched from shared prefs $isThemeToggled');
      return isDynamiThemeEnabled;
    } catch (e) {
      logger.info('Error loading dynamic color: $e');
      return true; // Return true on error
    }
  }

  Future<void> saveIsDynamicColorEnabled(bool value) async {
    try {
      await initSharedPrefs();
      await _prefs!.setBool('isDynamicColorSelected', value);
      isDynamiThemeEnabled = value;
      notifyListeners();
      logger.info(
          'AppThemePrefs (saveIsDynamicColorEnabled): dynamic color status saved in shared prefs $isThemeToggled');
    } catch (e) {
      logger.info('Error saving dynamic color: $e');
    }
  }

  Future<void> saveThemeColor(Color color) async {
    try {
      await initSharedPrefs();
      _prefs!.setInt('red', color.red);
      _prefs!.setInt('green', color.green);
      _prefs!.setInt('blue', color.blue);
      _prefs!.setInt('alpha', color.alpha);
      logger.info(
          'AppThemePrefs (saveThemeColor): custom theme color saved in shared prefs $isThemeToggled');
    } catch (e) {
      logger.info('Error saving theme color: $e');
    }
  }

  Future<Color?> loadThemeColor() async {
    try {
      await initSharedPrefs();
      final red = _prefs!.getInt('red');
      final green = _prefs!.getInt('green');
      final blue = _prefs!.getInt('blue');
      final alpha = _prefs!.getInt('alpha');
      if (red != null && green != null && blue != null && alpha != null) {
        logger.info(
            'AppThemePrefs (loadThemeColor): custom theme color feched from shared prefs $isThemeToggled');
        return Color.fromARGB(alpha, red, green, blue);
      } else {
        return null;
      }
    } catch (e) {
      logger.info('Error loading theme color: $e');
      return null;
    }
  }
}
