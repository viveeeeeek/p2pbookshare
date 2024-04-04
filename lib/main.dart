// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/app.dart';
import 'package:p2pbookshare/firebase_options.dart';
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/provider_list.dart';
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  var logger = Logger();
  bool IsUserLoggedIn = false;
  bool isDarkThemeEnabled = false;
  Color? themeColor;
  bool isDynamicColorEnabled = false;

  /// Initialize the app and load the shared preferences values for the app.
  /// This will be used to determine the initial state of the app.
  /// The app will be initialized with the values from the shared preferences.
  initializeApp() async {
    final AuthorizationService _authService = AuthorizationService();

    final AppThemePrefs appThemeSharedPrefsServices = AppThemePrefs();
    isDarkThemeEnabled =
        await appThemeSharedPrefsServices.loadIsDarkThemeEnabled();
    final color = await appThemeSharedPrefsServices.loadThemeColor();
    isDynamicColorEnabled =
        await appThemeSharedPrefsServices.loadIsDynamicColorEnabled();

    // Check if the user is logged in and set the value of IsUserLoggedIn
    String? token = await _authService.getToken();
    if (token != null) {
      try {
        // _userDataProvider.loadUserDataFromPrefs();
        IsUserLoggedIn = true;
      } catch (e) {
        logger.i('❌ Error loading user data: $e');
        IsUserLoggedIn = false;
      }
    } else {
      IsUserLoggedIn = false;
    }
    themeColor = isDynamicColorEnabled ? null : (color ?? Colors.blue);
    logger.d(
        'active splash state | isDynamicColor $isDynamicColorEnabled |isuserLoggedIn $IsUserLoggedIn | isDarkThemeEnabled: $isDarkThemeEnabled | themeColor: $color');
  }

  /// Preserves the splash screen until the app is initialized.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initializeApp();
  FlutterNativeSplash.remove();

  /// Initialize Firebase and load the environment variables.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enables offline persistence of Firebase data.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await FlutterConfig.loadEnvVariables();
  final appProviderList = createAppProviderList(isDarkThemeEnabled, themeColor);
  runApp(MultiProvider(
      providers: appProviderList,
      child: App(
        isUserLoggedIn: IsUserLoggedIn,
        isDarkThemeEnabled: isDarkThemeEnabled,
      )));
}
