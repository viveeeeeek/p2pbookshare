// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String? street, city, state;
  final GeoPoint? coordinates; // Use GeoPoint for latitude and longitude

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.coordinates,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      coordinates: map['coordinates'] != null
          ? GeoPoint(
              map['coordinates']['latitude'], map['coordinates']['longitude'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'coordinates': coordinates != null
          ? {
              'latitude': coordinates!.latitude,
              'longitude': coordinates!.longitude
            }
          : null,
    };
  }
}
