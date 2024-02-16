import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_logger/simple_logger.dart';

class ThemeSharedPreferences with ChangeNotifier {
  final logger = SimpleLogger();
  SharedPreferences? _prefs;
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
      logger.info('✅saveIslighte=temeenabl from shared prefs $isThemeToggled');
    } catch (e) {
      logger.info('Error saving dynamic color: $e');
    }
  }

  Future<bool> loadIsDarkThemeEnabled() async {
    try {
      await initSharedPrefs();
      isThemeToggled = _prefs!.getBool('isLightThemeToggled') ?? true;
      logger.info('✅loadIsLightThemeToggled from shared prefs $isThemeToggled');

      notifyListeners();
      return isThemeToggled;
    } catch (e) {
      isThemeToggled = true;
      notifyListeners();
      logger.info('Error loading theme mode: $e');
      return isThemeToggled;
    }
  }

  Future<void> loadIsDynamicColorEnabled() async {
    try {
      await initSharedPrefs();
      isDynamiThemeEnabled = _prefs!.getBool('isDynamicColorSelected') ?? true;
      notifyListeners();
    } catch (e) {
      logger.info('Error loading dynamic color: $e');
    }
  }

  Future<void> saveIsDynamicColorEnabled(bool value) async {
    try {
      await initSharedPrefs();
      await _prefs!.setBool('isDynamicColorSelected', value);
      isDynamiThemeEnabled = value;
      notifyListeners();
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
//TODO: there is repeated initilization of shareprefs instances. minimze it as shown in pooja bhaumik's linkedin learning course Chpter 7 Static initializers