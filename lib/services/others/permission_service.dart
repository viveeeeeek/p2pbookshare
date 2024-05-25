// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';

// Project imports:
import 'package:p2pbookshare/core/utils/logging.dart';

class PermissionService with ChangeNotifier {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Future<bool> isServiceEnabled() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     logger.e('❌ Location service is not enabled');
  //     return false;
  //   }
  //   logger.i('✅ Location service is  enabled');
  //   return true; // Add this line for the case when service is enabled
  // }

  Future<bool> isLocationPermissionAvailable() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        logger.i('❌ Permission denied permanently');
        return false;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          logger.i('❌ Permission denied');
          return false;
        }
      }
      logger.i('✅ Permission granted');
      return true; // Return true if permission is granted
    } catch (e) {
      logger.e('Error occurred: $e');
      // Handle exceptions or errors here
      return false; // Return false in case of any error
    }
  }

  bool _isNotificationPermissionAvailable = false;
  bool get isNotificationPermissionAvailable =>
      _isNotificationPermissionAvailable;

  /// bool setter
  setIsNotificationPermissionAvailable(bool value) {
    _isNotificationPermissionAvailable = value;
    notifyListeners();
  }

  /// Request permission for notification
  void requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setIsNotificationPermissionAvailable(true);
      logger.d('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      setIsNotificationPermissionAvailable(false);
      logger.d('User declined or has not accepted permission');
      // if usert has declined the permission set isNotificationPermissionAvailable to false
    } else {
      logger.d('User declined or has not accepted permission');
      setIsNotificationPermissionAvailable(false);
    }
  }
}
