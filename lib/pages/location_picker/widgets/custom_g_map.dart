import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2pbookshare/app_init_handler.dart';
import 'package:p2pbookshare/services/providers/others/location_service.dart';
import 'package:provider/provider.dart';

class CustomGoogleMap extends StatelessWidget {
  const CustomGoogleMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (context, locationService, _) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: locationService.destination!,
            zoom: 15,
          ),
          onTap: (LatLng position) async {
            await locationService.setDestination(position);
            // Access the mapController through the future using mapControllerFuture
            await locationService.mapControllerFuture;
            locationService.decodeAddress(locationService.destination!);
          },
          onMapCreated: (GoogleMapController controller) {
            locationService.setMapController(controller);
            logger.info('han bhai marker cleare hhogya ab $controller');
          },
          markers: <Marker>{
            if (locationService.destination != null)
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: locationService.destination!,
                icon: BitmapDescriptor.defaultMarker,
              ),
          },
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapType: locationService.mapType,
        );
      },
    );
  }
}
