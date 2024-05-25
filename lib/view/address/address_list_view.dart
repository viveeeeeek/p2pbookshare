// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/services/firebase/user_service.dart';
import 'package:p2pbookshare/view/location_picker/location_picker_view.dart';
import 'package:p2pbookshare/view/upload_book/upload_book_viewmodel.dart';
import 'widgets/address_card.dart';

class AddressListView extends StatelessWidget {
  const AddressListView({super.key, required this.isAddressSelectionActive});

  final bool isAddressSelectionActive;

  @override
  Widget build(BuildContext context) {
    final addbookHandler = Provider.of<UploadBookViewModel>(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Container(
            //     height: 5,
            //     width: 45,
            //     decoration: const BoxDecoration(
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.all(Radius.circular(15)),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your addresses',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                // Add new address button
                FilledButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LocationPickerView();
                    }));
                  },
                  child: const Text(
                    'New address',
                    style: TextStyle(),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                child: Consumer<FirebaseUserService>(
                  builder: (context, firebaseUser, child) {
                    return StreamBuilder<List<Map<String, dynamic>>>(
                      stream: firebaseUser.fetchUserAddresses(
                        firebaseUser.getCurrentUserUid()!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Return a loading indicator if data is still loading
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator()),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          // Handle the error case
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          // Handle the case when there is no data yet
                          return const Text('No data available');
                        } else {
                          List<Map<String, dynamic>> userAddressList =
                              snapshot.data!;

                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: userAddressList.length,
                            itemBuilder: (context, index) {
                              return AddressCard(
                                  street: userAddressList[index]['street'],
                                  city: userAddressList[index]['city'],
                                  state: userAddressList[index]['state'],
                                  onTap: isAddressSelectionActive
                                      ? () {
                                          addbookHandler.handleAddressSelection(
                                            context: context,
                                            address:
                                                '${userAddressList[index]['street']} ${userAddressList[index]['city']} ${userAddressList[index]['state']}',
                                            addressLatLng: LatLng(
                                              userAddressList[index]
                                                  ['coordinates']['latitude'],
                                              userAddressList[index]
                                                  ['coordinates']['longitude'],
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      : () {});
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
