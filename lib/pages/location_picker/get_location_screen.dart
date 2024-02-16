import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:pixel_perfect/pixel_perfect.dart';

import 'package:p2pbookshare/pages/location_picker/location_handler.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';

import 'widgets/widgets.dart';

class GetLocationScreen extends StatefulWidget {
  const GetLocationScreen({super.key});

  @override
  State<GetLocationScreen> createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  final logger = SimpleLogger();
  GetLocationHandler locationHandler = GetLocationHandler();

  @override
  void initState() {
    super.initState();
    locationHandler.handleLocationInitialization(context);
  }

  @override
  Widget build(BuildContext context) {
    return PixelPerfect(
      // assetPath: 'assets/reference/maps_screen.jpg', // path to your asset image
      // scale: 1.75, // scale value (optional)
      // initBottom: 20, //  default bottom distance (optional)
      // offset: Offset.zero, // default image offset (optional)
      // initOpacity: 1, // init opacity value (optional)
      child: Scaffold(
        floatingActionButton: buildFloatingMenu(),
        resizeToAvoidBottomInset: false,
        body: Consumer<LocationService>(
          builder: (context, locationService, _) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      const CustomGoogleMap(),
                      const Positioned(
                        top: 25,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            LocationSearchBar(),
                            SizedBox(
                              height: 15,
                            ),
                            SearchResult()
                          ],
                        ),
                      ),
                      locationService.isLoading == true
                          ? const SizedBox()
                          : Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              //TODO: remove this data passing to the bottomform instead e can directly use consummer there itself
                              child: BottomCard(
                                markerPosition: locationService.destination,
                                isAddressAvailable:
                                    locationService.address == null
                                        ? false
                                        : true,
                                userAddress: locationService.address,
                                onContinueFunction: () {
                                  //TODO: implment ne complete address inputform like number name street. baki locality cityand all to map sepick kar hi lenge
                                  // locationService.setDestination(
                                  //     locationService.destination);
                                  addressCompletionBottomSheet(
                                      context: context,
                                      city: locationService.selectedCity!,
                                      state: locationService.selectedState);
                                },
                              ),
                            )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
