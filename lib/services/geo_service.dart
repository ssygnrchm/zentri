import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Determines the current position of the user
Future<LatLng> determineUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, throw exception
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are permanently denied
    throw Exception('Location permissions are permanently denied');
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return LatLng(position.latitude, position.longitude);
}

/// Get address from latitude and longitude
Future<String> getAddressFromLatLng(LatLng position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String address = '';

      // Build address string based on available components
      if (place.street != null && place.street!.isNotEmpty) {
        address += place.street!;
      }

      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        if (address.isNotEmpty) address += ', ';
        address += place.subLocality!;
      }

      if (place.locality != null && place.locality!.isNotEmpty) {
        if (address.isNotEmpty) address += ', ';
        address += place.locality!;
      }

      if (place.postalCode != null && place.postalCode!.isNotEmpty) {
        if (address.isNotEmpty) address += ', ';
        address += place.postalCode!;
      }

      if (place.country != null && place.country!.isNotEmpty) {
        if (address.isNotEmpty) address += ', ';
        address += place.country!;
      }

      return address.isNotEmpty ? address : 'Unknown location';
    }
    return 'Address not found';
  } catch (e) {
    print('Error getting address: $e');
    return 'Error getting address';
  }
}
