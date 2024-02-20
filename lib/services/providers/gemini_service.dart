import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_config/flutter_config.dart';
import 'package:simple_logger/simple_logger.dart';

/// A service class for interacting with the Gemini API.
class GeminiService with ChangeNotifier {
  SimpleLogger logger = SimpleLogger();

  /// Get the Gemini Pro API key from FlutterConfig.
  final apiKey = FlutterConfig.get('GEMINI_PRO_API_KEY');

  /// API endpoint for generating text-to-text using Gemini.
  String get apiEndPoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$apiKey';

  /// The initial response from the Gemini API.
  var _geminiResponse = '';
  String get geminiResponse => _geminiResponse;

  /// Flag indicating whether content generation is in progress.
  bool _isGeneratingSummary = false;
  bool get isGeneratingSummary => _isGeneratingSummary;

  /// The progress percentage of the content generation process.
  double _progressPercentage = 0.0;
  double get progressPercentage => _progressPercentage;

  /// Map to store generated summaries for each book.
  final Map<String, String> _bookSummaries = {};

  /// Get the book summary based on the book key.
  String? getBookSummary(String bookKey) {
    return _bookSummaries[bookKey];
  }

  /// Clear the book summary for the specified book key.
  void clearBookSummary(String bookKey) {
    _bookSummaries.remove(bookKey);
    notifyListeners();
  }

  /// Generate the book summary using prompt (text-to-text generation).
  Future<String> generateGeminiText({
    required String bookName,
    required String authorName,
  }) async {
    final bookKey = '$bookName-$authorName';

    // Set the flag to indicate that summary generation is in progress.
    _isGeneratingSummary = true;
    notifyListeners();

    // Check if the summary for the book is already generated.
    if (_bookSummaries.containsKey(bookKey)) {
      // Retrieve the cached summary.
      _geminiResponse = _bookSummaries[bookKey]!;
      // Clear the generation flag and notify listeners.
      _isGeneratingSummary = false;
      notifyListeners();
      return _geminiResponse;
    } else {
      // Proceed with the generation of the book summary using HTTP POST method to the Gemini API.

      // Prepare the request body with book information and configuration settings.
      var body = jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text": '''
For  "${bookName}"  by $authorName: If you don t have enough information, say  Sorry, I m not familiar with this book.  Otherwise, create a concise and captivating 1-paragraph description in clear English. Summarize the plot, highlight key characters and their motivations, specify genre and tone, and mention unique elements. Use newline characters (\n) for clarity. Focus on factual information and avoid speculation.'''
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.9,
          "topK": 1,
          "topP": 1,
          "maxOutputTokens": 2048,
          "stopSequences": []
        },
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      });
      // Send a POST request to the Gemini API endpoint.
      var response = await http.post(
        Uri.parse(apiEndPoint),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      // Parse the API response.
      var responseBody = jsonDecode(response.body);

      logger.info("✅API Response (Raw) ${response.body}");

      try {
        // Extract the generated summary from the API response.
        _geminiResponse =
            responseBody['candidates'][0]['content']['parts'][0]['text'];

        logger.info("✅API Response (Formatted) $_geminiResponse");

        // Store the generated summary for the specific book.
        _bookSummaries[bookKey] = _geminiResponse;

        // Clear the generation flag and notify listeners.
        _isGeneratingSummary = false;
        notifyListeners();

        return _geminiResponse;
      } catch (e) {
        // Clear the generation flag and notify listeners in case of unexpected response format.
        _isGeneratingSummary = false;
        notifyListeners();
        return 'Unexpected response format';
      }
    }
  }
}
