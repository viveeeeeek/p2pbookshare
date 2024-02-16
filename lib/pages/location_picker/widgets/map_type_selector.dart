import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';
import 'package:provider/provider.dart';

class MapTypeSelector extends StatelessWidget {
  const MapTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Consumer<LocationService>(
          builder: (context, locationProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 45,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text('Normal'),
                  onTap: () {
                    locationProvider.setMapType(MapType.normal);
                    Navigator.pop(context);
                  },
                  trailing: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/ic_default_colors.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Satellite'),
                  onTap: () {
                    locationProvider.setMapType(MapType.satellite);
                    Navigator.pop(context);
                  },
                  trailing: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/ic_satellite.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Terrain'),
                  onTap: () {
                    locationProvider.setMapType(MapType.terrain);
                    Navigator.pop(context);
                  },
                  trailing: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/ic_terrain.png',
                      fit: BoxFit.contain,
                    ),
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
