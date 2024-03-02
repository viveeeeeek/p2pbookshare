import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/services/model/address.dart';
import 'package:p2pbookshare/services/providers/firebase/user_service.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';
import 'package:p2pbookshare/services/providers/others/permission_service.dart';
import 'package:provider/provider.dart';

import '../address/address_selection_bottom_sheet.dart';

class GetLocationHandler {
  static void handleAddressCompletionContinue({
    required BuildContext context,
    required TextEditingController streetController,
    required TextEditingController cityController,
    required TextEditingController stateController,
  }) {
    LocationService locationService =
        Provider.of<LocationService>(context, listen: false);
    FirebaseUserService firebaseUserService =
        Provider.of<FirebaseUserService>(context, listen: false);

    if (streetController.text.isEmpty) {
      Navigator.pop(context);
      //FIXME: Snackbar does not work when dismissing the bottomsheet
      // showCustomSnackBar(
      //   context,
      //   'Street address is empty',
      //   'Ok',
      //   3,
      //   () => null
      // );
    } else {
      AddressModel addressDetails = AddressModel(
        street: streetController.text,
        city: cityController.text,
        state: stateController.text,
        coordinates: GeoPoint(
          locationService.destination!.latitude,
          locationService.destination!.longitude,
        ), // Replace with actual latitude and longitude
      );

      Map<String, dynamic> addressMap = addressDetails.toMap();

      try {
        // Adding new address to the addresses collection of respective user
        firebaseUserService.addAddressToUser(
          firebaseUserService.getCurrentUserUid()!,
          addressMap,
        );
        // Dissmissing the bottom sheet
        Navigator.pop(context);
        // Navigating to address screen
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const AddressPickerBottomSheet();
          },
        );
      } catch (e) {
        logger.warning(e);
      }
    }
  }

  Future<void> handleLocationInitialization(BuildContext context) async {
    PermissionService permissionService =
        Provider.of<PermissionService>(context, listen: false);
    LocationService locationService =
        Provider.of<LocationService>(context, listen: false);

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
