import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:p2pbookshare/app_init_handler.dart';

class PermissionService with ChangeNotifier {
  Future<bool> isServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.warning('❌ Location service is not enabled');
      return false;
    }
    logger.info('✅ Location service is  enabled');
    return true; // Add this line for the case when service is enabled
  }

  Future<bool> isPermissionAvailable() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        logger.info('❌ Permission denied permanently');
        return false;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          logger.info('❌ Permission denied');
          return false;
        }
      }
      logger.info('✅ Permission granted');
      return true; // Return true if permission is granted
    } catch (e) {
      logger.warning('Error occurred: $e');
      // Handle exceptions or errors here
      return false; // Return false in case of any error
    }
  }
}
