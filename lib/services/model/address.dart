import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String? street, city, state;
  final GeoPoint? coordinates; // Use GeoPoint for latitude and longitude

  AddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.coordinates,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
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
