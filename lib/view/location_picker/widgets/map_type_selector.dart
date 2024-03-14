import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/view_model/location_picker_viewmodel.dart';

class MapTypeSelector extends StatelessWidget {
  const MapTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Consumer<LocationPickerViewModel>(
          builder: (context, locationProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: SizedBox(
                    height: 5,
                    width: 45,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ..._mapTypeOptions
                    .map(
                      (mapType) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(mapType.name),
                          onTap: () {
                            locationProvider.setMapType(mapType.type);
                            Navigator.pop(context);
                          },
                          trailing: Image.asset(mapType.icon),
                        ),
                      ),
                    )
                    .toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

const _mapTypeOptions = [
  MapTypeOption(MapType.normal, 'assets/icons/ic_default_colors.png', 'Normal'),
  MapTypeOption(
      MapType.satellite, 'assets/icons/ic_satellite.png', 'Satellite'),
  MapTypeOption(MapType.terrain, 'assets/icons/ic_terrain.png', 'Terrain'),
];

class MapTypeOption {
  final MapType type;
  final String icon;
  final String name;

  const MapTypeOption(this.type, this.icon, this.name);
}
