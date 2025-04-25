import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

Future<LatLng> determineUserLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    print('Error determining user location: $e');
    return const LatLng(-6.1753924, 106.8271528); // Default to Jakarta
  }
}

Future<String> getAddressFromLatLng(LatLng position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    }
    return 'Unknown location';
  } catch (e) {
    print('Error getting address: $e');
    return 'Unable to get address';
  }
}
