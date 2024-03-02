// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/providers/authentication/authentication.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/services/providers/theme/app_theme_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:simple_logger/simple_logger.dart';

SimpleLogger logger = SimpleLogger();

class AppInitHandler with ChangeNotifier {
  late final AuthorizationService _authProvider;
  late final UserDataProvider _userDataProvider;
  late final AppThemePrefs _appThemeSharedPrefsServices;
  late final AppThemeService _themeProvider;

  AppInitHandler(this._authProvider, this._userDataProvider,
      this._appThemeSharedPrefsServices, this._themeProvider);
  //! Checks if user is signed-in or not
  Future<bool> checkUserLoggedInStatus() async {
    String? token = await _authProvider.getToken();
    if (token != null) {
      try {
        await initializeUserData();
        return true;
      } catch (e) {
        logger.info('❌ Error loading user data: $e');
        return false;
      }
    } else {
      return false;
    }
  }

  //! Sets app theme
  Future<void> setThemeColor() async {
    final color = await _appThemeSharedPrefsServices.loadThemeColor();
    final retrieveThemeColorFromFres = color;
    _appThemeSharedPrefsServices.loadIsDynamicColorEnabled();
    _themeProvider.setThemeColor(retrieveThemeColorFromFres);
  }

  //! sets app theme mode
  Future<void> setAppThemeMode() async {
    final appDefaultThemeMode =
        await _appThemeSharedPrefsServices.loadIsDarkThemeEnabled();
    _themeProvider.setIsDarkThemeToggled(appDefaultThemeMode);
  }

  //! Initializes userdata if user is already signed-in
  Future<void> initializeUserData() async {
    await _userDataProvider.loadUserDataFromPrefs();
  }
}
