import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:flutter/services.dart' show rootBundle;

class AccessTokenFirebase {
  static const String _accessTokenKey = 'fcm_access_token';
  static const String _accessTokenExpiryKey = 'fcm_access_token_expiry';
  static const String _serviceAccountFilePath =
      'assets/fcm/service_account.json';
  static const String _firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String> getAccessToken() async {
    // Check if the access token and its expiry time are already stored in secure storage
    String? accessToken = await _secureStorage.read(key: _accessTokenKey);
    String? expiryTimeString =
        await _secureStorage.read(key: _accessTokenExpiryKey);

    if (accessToken != null &&
        accessToken.isNotEmpty &&
        expiryTimeString != null) {
      DateTime expiryTime = DateTime.tryParse(expiryTimeString)!;
      final DateTime expiryTimeLocal = expiryTime.toLocal();
      if (expiryTime.isAfter(DateTime.now())) {
        logger.d(
            'Access Token & Expiry Time Fetched!\n DateTime now: ${DateTime.now()}\n Expiry Time (Local): $expiryTimeLocal\n Access token: ${accessToken}');
        return accessToken;
      }
    }

    // If access token is not stored or is expired, generate a new one
    final jsonString = await rootBundle.loadString(_serviceAccountFilePath);
    final serviceAccountCredentials =
        ServiceAccountCredentials.fromJson(json.decode(jsonString));
    final client = await clientViaServiceAccount(
      serviceAccountCredentials,
      [_firebaseMessagingScope],
    );

    accessToken = await client.credentials.accessToken.data;
    final accessTokenExpiry = client.credentials.accessToken.expiry;

    // Store the access token and its expiry time securely
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(
        key: _accessTokenExpiryKey, value: accessTokenExpiry.toIso8601String());
    logger
        .d('Access token & Token expiry saved to secure storage: $accessToken');

    return accessToken;
  }
}
