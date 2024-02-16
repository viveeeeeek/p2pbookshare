import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/dashboard.dart';
import 'package:p2pbookshare/pages/login/login_screen.dart';
import 'package:p2pbookshare/pages/splash/splash_view.dart';
import 'package:p2pbookshare/services/providers/theme/app_theme.provider.dart';
import 'package:p2pbookshare/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppInitHandler _appInitHandler;

  Future<void> _initializeApp() async {
    // Initialize AppInitializer
    _appInitHandler = Provider.of<AppInitHandler>(context, listen: false);
    await _appInitHandler.setAppThemeMode();
    // Initialize the app: set theme color
    await _appInitHandler.setThemeColor();
    // Check logged-in status after initializing the app
    await _appInitHandler.isUserLoggedIn();
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final appInitHandler = Provider.of<AppInitHandler>(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            final lightColorScheme = getLightColorScheme(context, lightDynamic);
            final darkColorScheme = getDarkColorScheme(context, darkDynamic);
            return MaterialApp(
                title: 'p2pbookshare',
                debugShowCheckedModeBanner: true,
                theme: ThemeData(
                  colorScheme: lightColorScheme,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  textTheme: buildDarkTextTheme(),
                  colorScheme: darkColorScheme,
                  useMaterial3: true,
                ),
                themeMode: themeProvider.isDarkThemeEnabled == false
                    ? ThemeMode.light
                    : ThemeMode.dark,
                home: FutureBuilder<bool>(
                  future: appInitHandler.isUserLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return snapshot.data!
                            ? const Dashboard()
                            : const LoginScreen();
                      } else {
                        return const SplashScreen();
                      }
                    } else {
                      return const SplashScreen();
                    }
                  },
                ));
          },
        );
      },
    );
  }
}
