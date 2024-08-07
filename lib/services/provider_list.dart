// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/services/authentication/authentication.dart';
import 'package:p2pbookshare/services/chat/chat_service.dart';
import 'package:p2pbookshare/services/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/services/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/firebase/book_listing_service.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';
import 'package:p2pbookshare/services/others/connectivity_service.dart';
import 'package:p2pbookshare/services/others/gemini_service.dart';
import 'package:p2pbookshare/services/others/permission_service.dart';
import 'package:p2pbookshare/services/shared_prefs/ai_summary_prefs.dart';
import 'package:p2pbookshare/services/shared_prefs/app_theme_prefs.dart';
import 'package:p2pbookshare/services/shared_prefs/user_data_prefs.dart';
import 'package:p2pbookshare/services/theme/app_theme_service.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';
import 'package:p2pbookshare/view/upload_book/upload_book_viewmodel.dart';
import 'package:p2pbookshare/services/others/location_service.dart';
import 'package:p2pbookshare/view_model/request_book_viewmodel.dart';
import 'package:p2pbookshare/view_model/search_viewmodel.dart';

List<ChangeNotifierProvider> createAppProviderList(
    bool isDarkThemeEnabled, Color? themeColor) {
  return [
    // Authorization Service Provider
    ChangeNotifierProvider<AuthorizationService>(
        create: (_) => AuthorizationService()),
    // App Theme Shared Preferences Provider
    ChangeNotifierProvider<AppThemePrefs>(create: (_) => AppThemePrefs()),
    // Firebase User Related Services Provider
    ChangeNotifierProvider<FirebaseUserService>(
        create: (_) => FirebaseUserService()),
    // Firebase Book Request Services Provider
    ChangeNotifierProvider<BookRequestService>(
        create: (_) => BookRequestService()),
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
    ChangeNotifierProvider<AppThemeService>(
        create: (_) => AppThemeService(isDarkThemeEnabled, themeColor)),
    // Connectivity Provider
    ChangeNotifierProvider<ConnectivityService>(
        create: (_) => ConnectivityService()),
    // Location Service Provider
    ChangeNotifierProvider<LocationService>(
      create: (context) => LocationService(),
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
    // ChangeNotifierProvider<AppInitHandler>(
    //   create: (context) {
    //     return AppInitHandler();
    //   },
    // ),
    // RequestBook ViewMdoel
    ChangeNotifierProvider<RequestBookViewModel>(
      create: (context) {
        return RequestBookViewModel();
      },
    ),
    // Gemini Service Provider
    ChangeNotifierProvider<ChatService>(
      create: (context) {
        return ChatService();
      },
    ),
  ];
}
