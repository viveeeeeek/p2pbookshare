import 'package:flutter/material.dart';
import 'package:p2pbookshare/view/address/address_list_view.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AddressListView(
          isAddressSelectionActive: false,
        ),
      ),
    );
  }
}
