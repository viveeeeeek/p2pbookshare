import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/pages/login/login_screen.dart';
import 'package:p2pbookshare/services/providers/authentication/authentication.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/apptheme_sprefs.provider.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/userdata_sprefs.provider.dart';
import 'package:p2pbookshare/services/providers/theme/app_theme.provider.dart';

class SettingsHandler {
  ThemeSharedPreferences? _themeSharedPreferences;
  ThemeProvider? _themeProvider;

  initProviders(BuildContext context) {
    _themeSharedPreferences =
        Provider.of<ThemeSharedPreferences>(context, listen: false);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  bool get isThemeToggled => _themeSharedPreferences!.isThemeToggled;

  set isThemeToggled(bool value) {
    _themeSharedPreferences!.isThemeToggled = value;
    _themeSharedPreferences!.saveIsDarkThemeEnabled(value);
  }

  themeToggleEvent(BuildContext context, bool value) async {
    await initProviders(context);
    _themeProvider!.setIsDarkThemeToggled(value);
    _themeProvider!.toggleThemeMode();
    _themeSharedPreferences!.saveIsDarkThemeEnabled(value);
  }

  bool get isDynamicColorEnabled =>
      _themeSharedPreferences!.isDynamiThemeEnabled;

  set isDynamicColorEnabled(bool value) {
    _themeSharedPreferences!.isDynamiThemeEnabled = value;
    _themeSharedPreferences!.saveIsDynamicColorEnabled(value);
  }

  getIsDynamicColorOn(BuildContext context) async {
    final themeSharedPreferences =
        Provider.of<ThemeSharedPreferences>(context, listen: false);
    return themeSharedPreferences.isDynamiThemeEnabled;
  }

  setIsDynamicColorEnabled(BuildContext context, bool value) async {
    return _themeSharedPreferences!.saveIsDynamicColorEnabled(value);
  }

//! Main user log-out handling
  Future<void> handleLogOut(BuildContext context) async {
    final userDataSharedPrefsProvider =
        Provider.of<UserDataSharedPrefsServices>(context, listen: false);
    final authProvider =
        Provider.of<AuthorizationService>(context, listen: false);
    await authProvider.gSignOut(context);
    await authProvider.removeTokenAndData();
    await userDataSharedPrefsProvider.clearUserFromPrefs();
    //HACK this is how you handle build context across synchronous warning
    if (!context.mounted) return;
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen()));
  }
}
