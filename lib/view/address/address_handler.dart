import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/core/app_init_handler.dart';
import 'package:p2pbookshare/core/utils/app_utils.dart';
import 'package:p2pbookshare/model/address.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/view/address/address_list_view.dart';
import 'package:p2pbookshare/view_model/location_picker_viewmodel.dart';

class AddressHandler {
  static void handleAddressCompletionContinue({
    required BuildContext context,
    required TextEditingController streetController,
    required TextEditingController cityController,
    required TextEditingController stateController,
  }) {
    LocationPickerViewModel locationService =
        Provider.of<LocationPickerViewModel>(context, listen: false);
    FirebaseUserService firebaseUserService =
        Provider.of<FirebaseUserService>(context, listen: false);

    if (streetController.text.isEmpty) {
      Navigator.pop(context);
      //FIXME: Snackbar displays but is hidden behind bottom card
      Utils.snackBar(
        context: context,
        message: 'Street address is empty',
        actionLabel: 'Ok',
        durationInSecond: 2,
      );
    } else {
      Address addressDetails = Address(
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
            return const AddressListView();
          },
        );
      } catch (e) {
        logger.e(e);
      }
    }
  }
}
