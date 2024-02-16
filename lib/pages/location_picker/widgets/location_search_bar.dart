import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
          child: SizedBox(
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(75))),
              child: Center(child: Consumer<LocationService>(
                builder: (context, locationService, _) {
                  return TextField(
                    controller: locationService.searchController,
                    onChanged: (String query) {
                      Future.delayed(const Duration(microseconds: 600), () {
                        locationService.searchAddress(query);
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Symbols.search_rounded),
                      suffixIcon:
                          locationService.searchController.text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    locationService.clearSearchResult();
                                  },
                                  child: const Icon(Icons.clear))
                              : const SizedBox(),
                      hintText: 'Search location here',
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                  );
                },
              )),
            ),
          ),
        ),
      ],
    );
  }
}
