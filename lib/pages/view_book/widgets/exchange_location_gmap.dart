import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2pbookshare/services/model/book.dart';

class BookExchangeLocationCard extends StatelessWidget {
  final double cardWidth;
  const BookExchangeLocationCard({
    super.key,
    required this.bookData,
    required this.cardWidth,
  });

  final Book bookData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(
                bookData.location?.latitude ?? 0.0,
                bookData.location?.longitude ?? 0.0,
              ),
              zoom: 17),
          markers: {
            Marker(
              markerId: const MarkerId('book_location'),
              position: LatLng(
                bookData.location?.latitude ?? 0.0,
                bookData.location?.longitude ?? 0.0,
              ),
            ),
          },
          zoomControlsEnabled: true,
        ),
      ),
    );
  }
}
