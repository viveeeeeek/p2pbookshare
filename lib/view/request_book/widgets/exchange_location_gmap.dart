// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Project imports:
import 'package:p2pbookshare/model/book.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exchange location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            width: cardWidth,
            // height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      height: 250,
                      width: cardWidth,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              bookData.location?.latitude ?? 0.0,
                              bookData.location?.longitude ?? 0.0,
                            ),
                            zoom: 16),
                        markers: {
                          Marker(
                            markerId: const MarkerId('book_location'),
                            position: LatLng(
                              bookData.location?.latitude ?? 0.0,
                              bookData.location?.longitude ?? 0.0,
                            ),
                          ),
                        },
                        // zoomControlsEnabled: false,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    bookData.completeAddress,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
