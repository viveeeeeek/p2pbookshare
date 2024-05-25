// Flutter imports:
import 'package:flutter/material.dart';
import 'package:p2pbookshare/core/utils/logging.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/services/others/permission_service.dart';
import 'package:p2pbookshare/services/others/location_service.dart';

class LocationPickerViewModel {
  Future<void> handleLocationInitialization(BuildContext context) async {
    PermissionService permissionService =
        Provider.of<PermissionService>(context, listen: false);
    LocationService locationService =
        Provider.of<LocationService>(context, listen: false);

    try {
      bool permissionAvailable =
          await permissionService.isLocationPermissionAvailable();
      if (permissionAvailable == true) {
        await locationService.getUserLocation();
      }
    } catch (e) {
      logger.e('❌handleLocationInitialization error: $e');
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    }
  }
}
