// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';

// Project imports:
import 'package:p2pbookshare/provider/others/permission_service.dart';
import 'package:p2pbookshare/view_model/location_picker_viewmodel.dart';

class LocationPickerHandler {
  SimpleLogger logger = SimpleLogger();

  Future<void> handleLocationInitialization(BuildContext context) async {
    PermissionService permissionService =
        Provider.of<PermissionService>(context, listen: false);
    LocationPickerViewModel locationService =
        Provider.of<LocationPickerViewModel>(context, listen: false);

    try {
      bool permissionAvailable =
          await permissionService.isPermissionAvailable();
      if (permissionAvailable == true) {
        await locationService.getUserLocation();
      }
    } catch (e) {
      logger.shout('❌handleLocationInitialization error: $e');
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    }
  }
}
