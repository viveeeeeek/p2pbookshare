// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/utils/logging.dart';
import 'package:p2pbookshare/services/others/location_service.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String resultAddress = '';
    return Consumer<LocationService>(
      builder: (context, locationHandler, child) {
        return Visibility(
          visible: locationHandler.searchResults.isEmpty ? false : true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: ListView.builder(
                itemCount: locationHandler.searchResults.length,
                itemBuilder: (context, index) {
                  Placemark placemark = locationHandler.searchResults[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${placemark.name ?? ''}, ${placemark.locality ?? ''}, ${placemark.street ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        onTap: () async {
                          //TODO: Add to location picker handler
                          logger.i('✅searchQuery clicked');

                          List<Location> locations = await locationFromAddress(
                            '${placemark.name ?? ''}, ${placemark.locality ?? ''}, ${placemark.street ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}',
                          );
                          logger.i(
                              "✅💥 searchResult location clicked $placemark");
                          if (locations.isNotEmpty) {
                            Location location = locations.first;
                            LatLng destination =
                                LatLng(location.latitude, location.longitude);
                            await locationHandler.setDestination(destination);
                            logger.i('💥💥destintion $destination');
                            resultAddress =
                                '${placemark.name}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
                            locationHandler.setAddress(resultAddress);
                            locationHandler.searchResults.clear();
                            locationHandler.clearSearchResult();
                            //TO unfocus current keyboard
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                      ),
                      const Divider(
                        height: 2,
                        indent: 15,
                        endIndent: 15,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
