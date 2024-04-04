// ignore_for_file: use_build_context_synchronously

// Package imports:
import 'package:logger/logger.dart';

var logger = Logger();

// class AppInitHandler with ChangeNotifier {
//   AuthorizationService _authProvider = AuthorizationService();
//   Future<bool> checkUserLogInStatus() async {
//     String? token = await _authProvider.getToken();
//     if (token != null) {
//       try {
//         // _userDataProvider.loadUserDataFromPrefs();
//         return true;
//       } catch (e) {
//         logger.i('❌ Error loading user data: $e');
//         return false;
//       }
//     } else {
//       return false;
//     }
//   }
// }
