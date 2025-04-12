// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/app.dart';
import 'package:p2pbookshare/firebase_options.dart';
import 'package:p2pbookshare/services/authentication/authentication.dart';
import 'package:p2pbookshare/services/provider_list.dart';
import 'package:p2pbookshare/services/shared_prefs/app_theme_prefs.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  var logger = Logger();
  bool IsUserLoggedIn = false;
  bool isDarkThemeEnabled = false;
  Color? themeColor;
  bool isDynamicColorEnabled = false;

  // Initialize the app and load the shared preferences values for the app.
  // This will be used to determine the initial state of the app.
  // The app will be initialized with the values from the shared preferences.
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
        IsUserLoggedIn = true;
      } catch (e) {
        logger.i('❌ Error loading user data: $e');
        IsUserLoggedIn = false;
      }
    } else {
      IsUserLoggedIn = false;
    }
    themeColor = isDynamicColorEnabled ? null : (color ?? Colors.blue);
  }

  // Preserves the splash screen until the app is initialized.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initializeApp();
  FlutterNativeSplash.remove();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase and load the environment variables.

  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHnadler); // background message handler

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  ); // Enables offline persistence of Firebase data.

  await dotenv.load(fileName: ".env");
  final appProviderList = createAppProviderList(isDarkThemeEnabled, themeColor);
  runApp(MultiProvider(
      providers: appProviderList,
      child: App(
        isUserLoggedIn: IsUserLoggedIn,
        isDarkThemeEnabled: isDarkThemeEnabled,
      )));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHnadler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // logger.d('Handling a background message: ${message.notification!.title}');
}
