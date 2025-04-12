// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/services/others/location_service.dart';
import 'widgets.dart';

Widget buildFloatingMenu() {
  return Consumer<LocationService>(builder: (context, locationProvider, child) {
    return Stack(
      children: [
        Positioned(
          bottom: 270,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Theme.of(context).cardColor,
              color: Colors.black.withValues(alpha: 0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(
                      0, 3), // Adjust the offset to control shadow direction
                ),
              ],
            ),
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  locationProvider.getUserLocation();
                },
                borderRadius: BorderRadius.circular(30.0),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.location_searching_sharp),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: 0,
          child: FloatingActionButton(
            // mini: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            onPressed: () {
              //Open map type picker bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return const MapTypeSelector();
                },
              );
            },
            tooltip: 'FAB 1',
            child: const Icon(Icons.layers),
          ),
        ),
      ],
    );
  });
}
