import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/landing_page.dart';
import 'package:p2pbookshare/views/login/login_view.dart';
import 'package:p2pbookshare/views/splash_screen.dart';
import 'package:p2pbookshare/providers/theme/app_theme_service.dart';
import 'package:p2pbookshare/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppInitHandler _appInitHandler;
  // late Future _initFuture;

  _initializeApp() async {
    // Initialize AppInitializer
    _appInitHandler = Provider.of<AppInitHandler>(context, listen: false);
    await _appInitHandler.setTheme();
    bool isLoggedIn = await _appInitHandler.checkUserLoggedInStatus();
    return isLoggedIn; // return the result
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppInitHandler, AppThemeService>(
      builder: (context, appInitHandler, themeProvider, child) {
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
              home: FutureBuilder(
                future: _appInitHandler.checkUserLoggedInStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return snapshot.data!
                          ? const LandingPage()
                          : const LoginView();
                    } else {
                      return const SplashScreen();
                    }
                  } else {
                    return const SplashScreen();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
