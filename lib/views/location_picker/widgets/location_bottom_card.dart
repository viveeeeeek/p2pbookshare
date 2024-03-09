import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/global/utils/extensions/color_extension.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/view_models/location_picker_viewmodel.dart';
import 'package:p2pbookshare/views/address/widgets/address_completion_bottom_sheet.dart';

class LocationBottomCard extends StatelessWidget {
  const LocationBottomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationPickerViewModel>(
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
                    : const CustomShimmerContainer(
                        height: 25,
                        width: 400,
                        borderRadius: 5,
                      ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(),
                _isAddressAvailable == false
                    ? const CustomShimmerContainer(
                        height: 60,
                        width: 400,
                        borderRadius: 10,
                      )
                    : FilledButton(
                        onPressed: () {
                          addressCompletionBottomSheet(
                              context: context,
                              city: locationService.selectedCity!,
                              state: locationService.selectedState);
                        },
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Icon(
                                MdiIcons.arrowRight,
                                color: context.onPrimary,
                              ),
                              Text(
                                'Continue',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
              ],
            ),
          ),
        );
      },
    );
  }
}
