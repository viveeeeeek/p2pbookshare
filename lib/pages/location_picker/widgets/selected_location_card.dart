import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';

import 'package:p2pbookshare/global/widgets/shimmer_container.dart';

class BottomCard extends StatelessWidget {
  const BottomCard(
      {super.key,
      required this.markerPosition,
      required this.isAddressAvailable,
      required this.userAddress,
      required this.onContinueFunction});

  final LatLng? markerPosition;
  final bool isAddressAvailable;
  final String? userAddress;
  final dynamic Function()? onContinueFunction;

  @override
  Widget build(BuildContext context) {
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
            isAddressAvailable
                ? Text(userAddress!)
                : const CustomShimmerContainer(
                    height: 25,
                    width: 400,
                    borderRadius: 5,
                  ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
            isAddressAvailable == false
                ? const CustomShimmerContainer(
                    height: 60,
                    width: 400,
                    borderRadius: 10,
                  )
                : FilledButton(
                    onPressed: onContinueFunction,
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
