// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class AISummarySharedPrefs {
//   final Map<String, String> _bookSummaries = {};
//   late final SharedPreferences _prefs;

//   /// We can create a private field to create and hold the shared preferences instance and reuse it.
//   Future<void> initSharedPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   Future<void> _loadPreferences() async {
//     await initSharedPrefs();
//     final savedData = _prefs.getString('bookSummaries');
//     if (savedData != null) {
//       try {
//         final decodedData = json.decode(savedData);
//         if (decodedData is Map<String, dynamic>) {
//           _bookSummaries.clear();
//           decodedData.forEach((key, value) {
//             _bookSummaries[key] = value.toString();
//           });
//         } else if (decodedData is Map<String, String>) {
//           _bookSummaries.clear();
//           _bookSummaries.addAll(decodedData);
//         }
//         // notifyListeners();
//       } catch (e) {
//         print('Error decoding SharedPreferences data: $e');
//       }
//     }
//   }

//   Future<String?> getBookSummary(String bookKey) async {
//     await initSharedPrefs();
//     final savedData = _prefs.getString('bookSummaries');
//     if (savedData != null) {
//       try {
//         final decodedData = json.decode(savedData);
//         if (decodedData is Map<String, dynamic>) {
//           _bookSummaries.clear();
//           decodedData.forEach((key, value) {
//             _bookSummaries[key] = value.toString();
//           });
//         } else if (decodedData is Map<String, String>) {
//           _bookSummaries.clear();
//           _bookSummaries.addAll(decodedData);
//         }
//         // notifyListeners();
//       } catch (e) {
//         print('Error decoding SharedPreferences data: $e');
//       }
//     }

//     print('✅[getBookSummary]  ${_bookSummaries[bookKey]})');
//     return _bookSummaries[bookKey];
//   }

//   Future<void> clearBookSummary(String bookKey) async {
//     _bookSummaries.remove(bookKey);
//     _savePreferences();
//   }

//   Future<void> saveBookSummary(
//       {required String bookKey, required String bookSummary}) async {
//     await initSharedPrefs();
//     _bookSummaries[bookKey] = bookSummary;
//     print(
//         '✅ [saveBookSummary] (Book summary saved in shared prefs ${_bookSummaries[bookKey]})');
//     _savePreferences();
//   }

//   void _savePreferences() {
//     final Map<String, String> stringValues = _bookSummaries
//         .map((key, value) => MapEntry<String, String>(key, value.toString()));
//     _prefs.setString('bookSummaries', json.encode(stringValues));
//     // notifyListeners();
//   }
// }
