import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/pages/addbook/addbook_handler.dart';
import 'package:p2pbookshare/services/providers/gemini_service.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';
import 'package:p2pbookshare/services/providers/others/connectivity_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_upload_service.dart';
import 'package:p2pbookshare/services/providers/others/permission_service.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/apptheme_sprefs.provider.dart';
import 'package:p2pbookshare/services/providers/theme/app_theme.provider.dart';
import 'package:p2pbookshare/services/providers/authentication/authentication.dart';
import 'package:p2pbookshare/services/providers/shared_prefs/userdata_sprefs.provider.dart';
import 'package:p2pbookshare/services/providers/firebase/user_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> appProviders = [
  ChangeNotifierProvider<AuthorizationService>(
      create: (_) => AuthorizationService()),
  ChangeNotifierProvider<ThemeSharedPreferences>(
      create: (_) => ThemeSharedPreferences()),
  ChangeNotifierProvider<FirebaseUserService>(
      create: (_) => FirebaseUserService()),
  ChangeNotifierProvider<BookRequestService>(
      create: (_) => BookRequestService()),
  ChangeNotifierProvider<BookUploadService>(create: (_) => BookUploadService()),
  ChangeNotifierProvider<UserDataProvider>(create: (_) => UserDataProvider()),
  ChangeNotifierProvider<BookFetchService>(create: (_) => BookFetchService()),
  ChangeNotifierProvider<UserDataSharedPrefsServices>(
      create: (_) => UserDataSharedPrefsServices()),
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ChangeNotifierProvider<ConnectivityProvider>(
      create: (_) => ConnectivityProvider()),
  ChangeNotifierProvider<LocationService>(
    create: (context) => LocationService(),
  ),
  ChangeNotifierProvider<PermissionService>(
    create: (context) => PermissionService(),
  ),
  ChangeNotifierProvider<GeminiService>(
    create: (context) {
      return GeminiService();
    },
  ),
  // ChangeNotifierProvider<AISummarySharedPrefs>(
  //   create: (context) => AISummarySharedPrefs(),
  // ),
  ChangeNotifierProvider<AddbookHandler>(
    create: (context) {
      final fbBookServices =
          Provider.of<BookUploadService>(context, listen: false);
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      return AddbookHandler(fbBookServices, userDataProvider);
    },
  ),
  ChangeNotifierProvider<AppInitHandler>(
    create: (context) {
      final authProvider =
          Provider.of<AuthorizationService>(context, listen: false);
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final appThemeSharedPrefsServices =
          Provider.of<ThemeSharedPreferences>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      return AppInitHandler(authProvider, userDataProvider,
          appThemeSharedPrefsServices, themeProvider);
    },
  ),
];
