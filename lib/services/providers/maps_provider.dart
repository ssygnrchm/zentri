import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zentri/services/geo/geo_service.dart';

class MapsProvider with ChangeNotifier {
  bool _isLoading = false;
  String _currentAddress = "Unknown";
  String _currentAddress2 = "Unknown";
  String _currentLatLong = "Unknown";
  double _currentLat = 0;
  double _currentLong = 0;

  String _jalan = "";
  String _kelurahan = "";
  String _kecamatan = "";
  String _kota = "";
  String _provinsi = "";
  String _negara = "";
  String _kodePos = "";

  String get jalan => _jalan;
  String get kelurahan => _kelurahan;
  String get kecamatan => _kecamatan;
  String get kota => _kota;
  String get provinsi => _provinsi;
  String get negara => _negara;
  String get kodePos => _kodePos;

  bool get isLoading => _isLoading;
  String get currentAddress => _currentAddress;
  String get currentAddress2 => _currentAddress2;
  String get currentLatLong => _currentLatLong;
  double get currentLat => _currentLat;
  double get currentLong => _currentLong;

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();
    try {
      LatLng userLocation = await GeoService().determineUserLocation();
      await _getAddressFromLatLng(userLocation);
    } catch (e) {
      print("Error fetching location: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}, ${place.country}, ${place.isoCountryCode}";

        _jalan = place.street!;
        _kelurahan = place.subLocality!;
        _kecamatan = place.locality!;
        _kota = place.subAdministrativeArea!;
        _provinsi = place.administrativeArea!;
        _negara = "${place.country}, ${place.isoCountryCode}";
        _kodePos = place.postalCode!;

        _currentLatLong = "${position.latitude}, ${position.longitude}";
        _currentLat = position.latitude;
        _currentLong = position.longitude;
        print(_currentLatLong);

        notifyListeners();
      }
    } catch (e) {
      print("Error reverse geocoding: $e");
    }
  }
}
