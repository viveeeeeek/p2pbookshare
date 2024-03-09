import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';

import 'package:p2pbookshare/providers/others/permission_service.dart';
import 'package:p2pbookshare/view_models/location_picker_viewmodel.dart';

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
