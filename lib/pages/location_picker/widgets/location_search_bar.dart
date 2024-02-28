import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/services/providers/others/location_service.dart';

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({super.key});

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: context.background,
            borderRadius: const BorderRadius.all(Radius.circular(75))),
        child: Consumer<LocationService>(
          builder: (context, locationService, _) {
            return TextField(
              controller: locationService.searchController,
              onChanged: (String query) {
                Future.delayed(const Duration(microseconds: 600), () {
                  locationService.searchAddress(query);
                });
              },
              decoration: InputDecoration(
                fillColor: context.tertiaryContainer,
                prefixIcon: Icon(MdiIcons.magnify),
                suffixIcon: locationService.searchController.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          locationService.clearSearchResult();
                        },
                        child: const Icon(Icons.clear))
                    : const SizedBox(),
                hintText: 'Search location ',
                border: InputBorder.none,
              ),
            );
          },
        ),
      ),
    );
  }
}
