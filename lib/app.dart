// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dynamic_color/dynamic_color.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/theme/app_theme.dart';
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/provider/theme/app_theme_service.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:p2pbookshare/view/landing_view.dart';
import 'package:p2pbookshare/view/login/login_view.dart';

class App extends StatefulWidget {
  const App(
      {super.key,
      required this.isDarkThemeEnabled,
      required this.isUserLoggedIn});
  final bool isDarkThemeEnabled;
  final bool isUserLoggedIn;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late UserDataProvider _userDataProvider;
  late AppThemePrefs appThemeSharedPrefsServices;
  final logger = Logger();
  bool loginStatus = false;

  initializeApp() async {
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    appThemeSharedPrefsServices =
        Provider.of<AppThemePrefs>(context, listen: false);

    _userDataProvider.loadUserDataFromPrefs();
    appThemeSharedPrefsServices.loadIsDynamicColorEnabled();
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeService>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final lightColorScheme = getLightColorScheme(context, lightDynamic);
            final darkColorScheme = getDarkColorScheme(context, darkDynamic);
            return MaterialApp(
              title: 'p2pbookshare',
              debugShowCheckedModeBanner: true,
              theme: ThemeData(
                textTheme: buildLightTextTheme(),
                colorScheme: lightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                textTheme: buildDarkTextTheme(),
                colorScheme: darkColorScheme,
                useMaterial3: true,
              ),
              themeMode: themeProvider.isDarkThemeEnabled
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: widget.isUserLoggedIn
                  ? const LandingView()
                  : const LoginView(),
            );
          },
        );
      },
    );
  }
}
