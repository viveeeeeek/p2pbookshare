// Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/provider/shared_prefs/user_data_prefs.dart';
import 'package:p2pbookshare/provider/theme/app_theme_service.dart';

class SettingViewModel {
  AppThemePrefs? _themeSharedPreferences;
  AppThemeService? _themeProvider;

  initProviders(BuildContext context) {
    _themeSharedPreferences =
        Provider.of<AppThemePrefs>(context, listen: false);
    _themeProvider = Provider.of<AppThemeService>(context, listen: false);
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
        Provider.of<AppThemePrefs>(context, listen: false);
    return themeSharedPreferences.isDynamiThemeEnabled;
  }

  setIsDynamicColorEnabled(BuildContext context, bool value) async {
    return _themeSharedPreferences!.saveIsDynamicColorEnabled(value);
  }

//! Main user log-out handling
  Future<void> handleLogOut(BuildContext context) async {
    final userDataSharedPrefsProvider =
        Provider.of<UserDataPrefs>(context, listen: false);
    final authProvider =
        Provider.of<AuthorizationService>(context, listen: false);
    await authProvider.gSignOut(context);
    await authProvider.removeTokenAndData();
// Cancel the subscription
    // try {
    //   await bookRequestService.cancelSubscription();
    // } catch (e) {
    //   logger.warning('Error cancelling subscription: $e');
    // }
    await userDataSharedPrefsProvider.clearUserFromPrefs();
    //HACK: This is how you handle build context across synchronous warning
    if (!context.mounted) return;
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginView()),
    //   (route) => false,
    // );
    context.goNamed('login');
  }
}
