// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/provider/theme/app_theme_service.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';

var logger = Logger();

class AppInitHandler with ChangeNotifier {
  late final AuthorizationService _authProvider;
  late final UserDataProvider _userDataProvider;
  late final AppThemePrefs _appThemeSharedPrefsServices;
  late final AppThemeService _themeProvider;

  AppInitHandler(this._authProvider, this._userDataProvider,
      this._appThemeSharedPrefsServices, this._themeProvider);

  Future<bool> checkUserLogInStatus() async {
    String? token = await _authProvider.getToken();
    if (token != null) {
      try {
        await _userDataProvider.loadUserDataFromPrefs();
        return true;
      } catch (e) {
        logger.i('❌ Error loading user data: $e');
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
