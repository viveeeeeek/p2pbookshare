import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_logger/simple_logger.dart';

/// A service class for managing location-related functionalities.
class LocationService with ChangeNotifier {
  final logger = SimpleLogger();

  /// Initial latitude & longitude
  Position? _currentPosition;

  /// Initial address text
  String? _address;
  String? get address => _address;

  /// Sets the address.
  setAddress(String? newAddress) {
    _address = newAddress;
    notifyListeners();
  }

  ///Initial latitude & longitude
  LatLng _destination = const LatLng(19.002531669935014, 72.82365940744195);
  LatLng? get destination => _destination;

  /// Sets the destination location.
  ///
  /// Updates the address, animates the camera position, and notifies listeners.
  setDestination(LatLng? newDestination) async {
    _destination = newDestination!;
    final address = await decodeAddress(newDestination);
    setAddress(address);
    animateCameraPosition();
    logger.info('✅setDestination✅ $newDestination $address');
    notifyListeners();
  }

  /// Loading status (default: false)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Sets the loading state.
  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Search result status (default: true)
  bool _searchResultAvailable = false;
  bool get searchResultAvailable => _searchResultAvailable;

  /// Sets the search result availability state.
  setIsSearchAvailable(bool value) {
    _searchResultAvailable = value;
    notifyListeners();
  }

  /// Search text field controller
  TextEditingController searchController = TextEditingController();

  /// Clears the search results and resets the search-related states.
  clearSearchResult() {
    _searchResultAvailable = false;
    searchController.clear();
    searchResults.clear();
    notifyListeners();
  }

  ///Map type (default: MapType.normal)
  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  /// Sets the map type.
  setMapType(MapType newMapType) {
    _mapType = newMapType;
    notifyListeners();
  }

  /// Map controller for movement & zoom.
  GoogleMapController? _mapController;
  Completer<GoogleMapController>? _completer;
  GoogleMapController? get mapController => _mapController;

  /// Retrieves the map controller's future.
  Future<GoogleMapController> get mapControllerFuture {
    _completer = Completer<GoogleMapController>();
    return _completer!.future;
  }

  /// Sets the map controller.
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(controller);
    }
    notifyListeners();
  }

  ///Animates camera position to new location.
  animateCameraPosition() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_destination, 16),
      );
    } else {
      logger.info('marker null hai isiliye animate nahi kiya bhai');
    }
  }

  /// Updates the location based on the new coordinates.
  Future<void> updateLocation(LatLng newLocation) async {
    setDestination(newLocation);
    String newAddress = await decodeAddress(newLocation);
    setAddress(newAddress);
    notifyListeners();
  }

  /// List of Placemarks to store search results.
  List<Placemark> searchResults = [];

  /// Searches for addresses based on the provided query.
  ///
  /// - Sets the loading state to true before starting the search.
  /// - Takes the first location and retrieves the associated placemarks.
  /// - Sets the loading state to false after successfully retrieving data.
  /// - Sets the loading state to false when no locations are found.
  /// - Sets the loading state to false when an error occurs.
  ///
  /// Returns a list of [Placemark]s corresponding to the search results.
  Future<List<Placemark>> searchAddress(String query) async {
    try {
      setIsSearchAvailable(true);
      List<Location> locations = await locationFromAddress(query);
      logger.info('locationFromAddress completed');
      if (locations.isNotEmpty) {
        List<Placemark> placemarks =
            await getPlacemarksFromLocation(locations.first);

        setIsSearchAvailable(false);
        searchResults = placemarks;
        return searchResults;
      } else {
        setIsSearchAvailable(false);
        searchResults = [];
        return searchResults;
      }
    } catch (e) {
      setIsSearchAvailable(false);
      handleSearchError(e);
      return [];
    }
  }

  /// Retrieves placemarks from the specified location.
  Future<List<Placemark>> getPlacemarksFromLocation(Location location) async {
    return await placemarkFromCoordinates(
        location.latitude, location.longitude);
  }

  /// Handles search errors and logs the appropriate warning message.
  void handleSearchError(dynamic error) {
    if (error is PlatformException) {
      logger.warning('Error searching for address: ${error.message}');
    } else {
      logger.warning('Error searching for address: $error');
    }
  }

  /// Decodes the address based on the provided coordinates.
  ///
  /// Returns the complete address as a [String].
  Future<String> decodeAddress(LatLng coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String completeAddress = buildCompleteAddress(placemark);
        setAddress(completeAddress);
        notifyListeners();
        return completeAddress;
      }
    } catch (e) {
      handleAddressRetrievalError(e);
    }
    return ''; // Return an empty string in case of failure
  }

  /// Initial address text
  String? _selectedCity;
  String? get selectedCity => _selectedCity;
  String? _selectedState;
  String? get selectedState => _selectedState;

  /// Builds the complete address from the provided placemark.
  ///
  /// Returns the complete address as a [String].
  String buildCompleteAddress(Placemark placemark) {
    String street = placemark.street ?? '';

    String country = placemark.country ?? '';
    _selectedCity = placemark.locality ?? '';
    _selectedState = placemark.administrativeArea ?? '';
    notifyListeners();
    logger.info(
        'street:$street, locality:$_selectedCity, administrativeArea:$_selectedState, country:$country');
    String completeAddress =
        ' $street, $_selectedCity, $_selectedState, $country'
            .replaceAll(', ,', ',')
            .trim();
    return completeAddress;
  }

  /// Handles address retrieval errors and logs the appropriate warning message.
  void handleAddressRetrievalError(dynamic error) {
    if (error is PlatformException) {
      logger.warning('Error retrieving address: ${error.message}');
    } else {
      logger.warning('Error retrieving address: $error');
    }
  }

  /// Fetches the user's current location.
  ///
  /// Tries to get the current location and handles exceptions accordingly.
  ///
  /// Returns the user's location as [LatLng].
  Future<LatLng?> getUserLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (_currentPosition != null) {
        setIsLoading(false);
        await setDestination(LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ));
        return LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } on LocationServiceDisabledException catch (e) {
      setIsLoading(false);
      logger.info('❌ Location services are disabled: $e');
      await Geolocator.openLocationSettings();
    } on GeolocatorPlatform catch (e) {
      setIsLoading(false);
      logger.info('❌ Geolocator platform exception: $e');
    } catch (e) {
      setIsLoading(false);
      logger.info('❌ Error fetching location: $e');
    }
    // Return a default value in case of errors or no location found
    return null;
  }
}
