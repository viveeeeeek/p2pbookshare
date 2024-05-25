// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:p2pbookshare/core/route/router.dart';
import 'package:p2pbookshare/services/authentication/authentication.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/theme/app_theme.dart';
import 'package:p2pbookshare/services/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/services/theme/app_theme_service.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';

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
  late AuthorizationService _authorizationService;
  late GoRouter _appRouter;

  void initializeApp() async {
    _userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    appThemeSharedPrefsServices =
        Provider.of<AppThemePrefs>(context, listen: false);

    _userDataProvider.loadUserDataFromPrefs();
    appThemeSharedPrefsServices.loadIsDynamicColorEnabled();
    _authorizationService.updateUserLoginStatus(widget.isUserLoggedIn);
    // Listen to changes in authentication status and update the AuthProvider

    logger.d('_authServices: ${_authorizationService.isUserLoggedIn}');
  }

  // Helper method to create and return the appropriate app router instance
  GoRouter _getAppRouter(bool isUserLoggedIn) {
    return AppRouter.returnRouter(isUserLoggedIn);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeApp();
      _appRouter = _getAppRouter(widget.isUserLoggedIn);
    });

    // Listen to changes in the user's login status and update the app router accordingly
    // This is necessary to ensure that the app router is updated when the user logs in or logs out
    _authorizationService =
        Provider.of<AuthorizationService>(context, listen: false);
    _appRouter = AppRouter.returnRouter(_authorizationService.isUserLoggedIn);
    _listenToAuthenticationChanges();
  }

  void _listenToAuthenticationChanges() {
    _authorizationService.addListener(() {
      setState(() {
        _appRouter =
            AppRouter.returnRouter(_authorizationService.isUserLoggedIn);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeService>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final lightColorScheme = getLightColorScheme(context, lightDynamic);
            final darkColorScheme = getDarkColorScheme(context, darkDynamic);

            return MaterialApp.router(
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
              routerConfig: _appRouter,
            );
          },
        );
      },
    );
  }
}
