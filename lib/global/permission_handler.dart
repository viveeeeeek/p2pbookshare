import 'package:flutter/material.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';
import 'package:p2pbookshare/services/providers/others/permission_service.dart';
import 'package:provider/provider.dart';

class PermissionHandler {
  checkPermission(BuildContext context) async {
    PermissionService permissionService =
        Provider.of<PermissionService>(context, listen: false);
    LocationService locationService =
        Provider.of<LocationService>(context, listen: false);
    bool permissionAvailable = await permissionService.isPermissionAvailable();
    if (permissionAvailable == false) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    } else {
      locationService.getUserLocation();
    }
  }
}
