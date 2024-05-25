// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/view/address/widgets/address_completion_bottom_sheet.dart';
import 'package:p2pbookshare/services/others/location_service.dart';

class LocationBottomCard extends StatelessWidget {
  const LocationBottomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, child) {
        final _isAddressAvailable =
            locationService.address == null ? false : true;
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected location',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 14,
                ),
                _isAddressAvailable
                    ? Text(locationService.address!)
                    : const P2PBookShareShimmerContainer(
                        height: 25,
                        width: 400,
                        borderRadius: 5,
                      ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(),
                _isAddressAvailable == false
                    ? const P2PBookShareShimmerContainer(
                        height: 60,
                        width: 400,
                        borderRadius: 10,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: FilledButton(
                                onPressed: () {
                                  addressCompletionBottomSheet(
                                      context: context,
                                      city: locationService.selectedCity!,
                                      state: locationService.selectedState);
                                },
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
