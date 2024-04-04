// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:simple_logger/simple_logger.dart';

//! Gemini api and shared prefs inside single class not good
/// A service class for interacting with the Gemini API.
class GeminiService with ChangeNotifier {
  SimpleLogger logger = SimpleLogger();

  /// Get the Gemini Pro API key from FlutterConfig.
  final geminiAPIKey = FlutterConfig.get('GEMINI_PRO_API_KEY');

  /// API endpoint for generating text-to-text using Gemini.
  String get apiEndPoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$geminiAPIKey';

  /// The initial response from the Gemini API.
  var _geminiResponse = '';
  String get geminiResponse => _geminiResponse;

  /// Flag indicating whether content generation is in progress.
  bool _isGeneratingSummary = false;
  bool get isGeneratingSummary => _isGeneratingSummary;

  /// Map to store generated summaries for each book.

  /// Generate the book summary using prompt (text-to-text generation).
  /// Generate the book summary using prompt (text-to-text generation).
  Future<String> summarizeBookWithGeminiAI(
      {required String bookName,
      required String authorName,
      required String bookKey}) async {
    // Set the flag to indicate that summary generation is in progress.
    _isGeneratingSummary = true;
    notifyListeners();

    // Proceed with the generation of the book summary using HTTP POST method to the Gemini API.
    // Prepare the request body with book information and configuration settings.
    var body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text": '''
For  "${bookName}"  by $authorName: Create a concise and captivating 1-paragraph description in clear English. Summarize the plot, highlight key characters and their motivations, specify genre and tone, and mention unique elements. Use newline characters (\n) for clarity. Focus on factual information and avoid speculation.'''
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

    if (responseBody.containsKey('candidates') &&
        responseBody['candidates'].isNotEmpty &&
        responseBody['candidates'][0].containsKey('content') &&
        responseBody['candidates'][0]['content'].containsKey('parts') &&
        responseBody['candidates'][0]['content']['parts'].isNotEmpty &&
        responseBody['candidates'][0]['content']['parts'][0]
            .containsKey('text')) {
      _geminiResponse =
          responseBody['candidates'][0]['content']['parts'][0]['text'];
    } else {
      _geminiResponse = '';
      logger.warning('Unexpected response body: $responseBody');
    }
    _isGeneratingSummary = false;
    notifyListeners();
    logger.info(
        "GeminiService (summarizeBookWithGeminiAI): Summary generated: ${response.body}");

    return _geminiResponse;
  }
}
