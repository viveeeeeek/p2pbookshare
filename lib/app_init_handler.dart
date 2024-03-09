// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:simple_logger/simple_logger.dart';

import 'package:p2pbookshare/providers/authentication/authentication.dart';
import 'package:p2pbookshare/providers/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/providers/theme/app_theme_service.dart';
import 'package:p2pbookshare/providers/userdata_provider.dart';

SimpleLogger logger = SimpleLogger();

class AppInitHandler with ChangeNotifier {
  late final AuthorizationService _authProvider;
  late final UserDataProvider _userDataProvider;
  late final AppThemePrefs _appThemeSharedPrefsServices;
  late final AppThemeService _themeProvider;

  AppInitHandler(this._authProvider, this._userDataProvider,
      this._appThemeSharedPrefsServices, this._themeProvider);

  Future<bool> checkUserLoggedInStatus() async {
    String? token = await _authProvider.getToken();
    if (token != null) {
      try {
        await _userDataProvider.loadUserDataFromPrefs();
        return true;
      } catch (e) {
        logger.info('❌ Error loading user data: $e');
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> setTheme() async {
    final appDefaultThemeMode =
        await _appThemeSharedPrefsServices.loadIsDarkThemeEnabled();
    _themeProvider.setIsDarkThemeToggled(appDefaultThemeMode);
    final color = await _appThemeSharedPrefsServices.loadThemeColor();
    _appThemeSharedPrefsServices.loadIsDynamicColorEnabled();
    _themeProvider.setThemeColor(color);
  }
}
