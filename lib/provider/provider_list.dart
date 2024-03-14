import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view_model/request_book_viewmodel.dart';
import 'package:p2pbookshare/view_model/search_viewmodel.dart';
import 'package:p2pbookshare/view/upload_book/upload_book_viewmodel.dart';
import 'package:p2pbookshare/provider/authentication/authentication.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/provider/firebase/book_listing_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/provider/others/connectivity_service.dart';
import 'package:p2pbookshare/provider/others/gemini_service.dart';
import 'package:p2pbookshare/view_model/location_picker_viewmodel.dart';
import 'package:p2pbookshare/provider/others/permission_service.dart';
import 'package:p2pbookshare/provider/shared_prefs/ai_summary_prefs.dart';
import 'package:p2pbookshare/provider/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/provider/shared_prefs/user_data_prefs.dart';
import 'package:p2pbookshare/provider/theme/app_theme_service.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:provider/provider.dart';

final List<ChangeNotifierProvider> appProviderList = [
  // Authorization Service Provider
  ChangeNotifierProvider<AuthorizationService>(
      create: (_) => AuthorizationService()),
  // App Theme Shared Preferences Provider
  ChangeNotifierProvider<AppThemePrefs>(create: (_) => AppThemePrefs()),
  // Firebase User Related Services Provider
  ChangeNotifierProvider<FirebaseUserService>(
      create: (_) => FirebaseUserService()),
  // Firebase Book Request Services Provider
  ChangeNotifierProvider<BookBorrowRequestService>(
      create: (_) => BookBorrowRequestService()),
  // Firebase Book Upload Services Provider
  ChangeNotifierProvider<BookListingService>(
      create: (_) => BookListingService()),
  // User Data Provider Provider
  ChangeNotifierProvider<UserDataProvider>(create: (_) => UserDataProvider()),
  // Book Fetch Services Provider
  ChangeNotifierProvider<BookFetchService>(create: (_) => BookFetchService()),
  // User Data Shared Preferences Provider
  ChangeNotifierProvider<UserDataPrefs>(create: (_) => UserDataPrefs()),
  // App Theme Service Provider
  ChangeNotifierProvider<AppThemeService>(create: (_) => AppThemeService()),
  // Connectivity Provider
  ChangeNotifierProvider<ConnectivityService>(
      create: (_) => ConnectivityService()),
  // Location Service Provider
  ChangeNotifierProvider<LocationPickerViewModel>(
    create: (context) => LocationPickerViewModel(),
  ),
  // Permission Service Provider
  ChangeNotifierProvider<PermissionService>(
    create: (context) => PermissionService(),
  ),
  // Gemini Service Provider
  ChangeNotifierProvider<GeminiService>(
    create: (context) {
      return GeminiService();
    },
  ),
  // AI Summary Shared Preferences Provider
  ChangeNotifierProvider<AISummaryPrefs>(
    create: (context) => AISummaryPrefs(),
  ),
  // Search View Model Provider
  ChangeNotifierProvider<SearchViewModel>(
    create: (context) => SearchViewModel(),
  ),
  // Add Book Handler Provider
  ChangeNotifierProvider<UploadBookViewModel>(
    create: (context) {
      final fbBookServices =
          Provider.of<BookListingService>(context, listen: false);
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      return UploadBookViewModel(fbBookServices, userDataProvider);
    },
  ),
  // App Initialization Handler Provider
  ChangeNotifierProvider<AppInitHandler>(
    create: (context) {
      final authProvider =
          Provider.of<AuthorizationService>(context, listen: false);
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final appThemeSharedPrefsServices =
          Provider.of<AppThemePrefs>(context, listen: false);
      final themeProvider =
          Provider.of<AppThemeService>(context, listen: false);
      return AppInitHandler(authProvider, userDataProvider,
          appThemeSharedPrefsServices, themeProvider);
    },
  ),
  // RequestBook ViewMdoel
  ChangeNotifierProvider<RequestBookViewModel>(
    create: (context) {
      return RequestBookViewModel();
    },
  ),
];
