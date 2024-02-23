import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_logger/simple_logger.dart';

class AISummaryPrefs with ChangeNotifier {
  SimpleLogger _logger = SimpleLogger();

  SharedPreferences? _prefs;

  /// The initial response from the Gemini API.
  var _geminiResponse = '';
  String get geminiResponse => _geminiResponse;

  bool _hasSummary = false;
  bool get hasSummary => _hasSummary;

  static final AISummaryPrefs _instance = AISummaryPrefs._internal();

  factory AISummaryPrefs() {
    return _instance;
  }

  AISummaryPrefs._internal();

  Future<String?> fetchSummary(String bookKey) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    try {
      final summariesString = _prefs!.getString('bookSummaries');
      if (summariesString != null) {
        _logger.info('Retrieved summariesString: $summariesString');
        final summariesMap =
            jsonDecode(summariesString) as Map<String, dynamic>;
        _logger.info('Decoded summariesMap: $summariesMap');

        // Check if the key and value types match expectations
        if (summariesMap.containsKey(bookKey)) {
          final summaryString = summariesMap[bookKey];
          _geminiResponse = summaryString;
          _hasSummary = true;
        } else {
          _logger.info('missing key in summariesMap');
          _hasSummary = false;
          return null;
        }

        // Call notifyListeners only once after all data operations

        Future.delayed(Duration.zero, () {
          notifyListeners();
        });
        return _geminiResponse;
      }
      return null;
    } catch (error) {
      _logger.info('Error fetching book summary: $error');
      _hasSummary = false;
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
      return null;
    }
  }

  Future<void> storeSummary(String bookKey, String geminiResponse) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    try {
      final summariesString = _prefs!.getString('bookSummaries');
      final Map<String, dynamic> summariesMap =
          summariesString != null ? jsonDecode(summariesString) : {};

      if (summariesMap.containsKey(bookKey)) {
        // Book summary is already stored, retrieve it
        _geminiResponse = summariesMap[bookKey];
      } else {
        // Store the extracted summary directly in the map
        summariesMap[bookKey] = geminiResponse;
        _geminiResponse = geminiResponse;

        // Encode only the necessary summary string
        final encodedSummaries = jsonEncode(summariesMap);

        // Save the encoded summaries to shared preferences
        await _prefs!.setString('bookSummaries', encodedSummaries);
        _logger.info(
            'AISumamryPrefs (storeSummary): Book summary saved to shared prefs for key: $bookKey');
        _hasSummary = true;
      }

      // Use Future.delayed to ensure notifyListeners is called after the current microtask
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    } catch (error) {
      // Handle specific errors (network, encoding, etc.)
      _logger.info('Error saving book summary: $error');
    }
  }

  Future<void> removeSummary(String bookKey) async {
    try {
      // Ensure _prefs is initialized
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }

      // Retrieve the saved summaries string
      final summariesString = _prefs!.getString('bookSummaries');
      if (summariesString != null) {
        // Decode the summaries map
        final summariesMap =
            jsonDecode(summariesString) as Map<String, dynamic>;

        // Remove the book summary from the map
        summariesMap.remove(bookKey);

        // Encode the updated map back to a string
        final encodedSummaries = jsonEncode(summariesMap);

        // Save the updated summaries string to shared prefs
        await _prefs!.setString('bookSummaries', encodedSummaries);
        _hasSummary = false;
        notifyListeners();
        _logger.info(
            'AISummaryPrefs (removeSummary): Book summary deleted for key: $bookKey');
      } else {
        _logger.info('No book summaries found in shared prefs');
      }
    } catch (error) {
      _logger.info('Error deleting book summary: $error');
    }
  }
}
