import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zentri/services/geo_service.dart';
import 'package:geolocator/geolocator.dart'; // Make sure this is imported

class LocationMapWidget extends StatefulWidget {
  final Function(String) onAddressChanged;

  const LocationMapWidget({Key? key, required this.onAddressChanged})
    : super(key: key);

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(
    -6.1753924,
    106.8271528,
  ); // Default position
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle denied permission
        widget.onAddressChanged('Location permission denied');
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permanently denied
      widget.onAddressChanged('Location permission permanently denied');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Permission granted, get location
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      LatLng latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = latLng;
        _updateMarker(latLng);
        _isLoading = false;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 16),
          ),
        );
      }

      // Get address from coordinates and notify parent
      _getAddressFromLatLng(latLng);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error getting current location: $e');
      widget.onAddressChanged('Error getting location: $e');
    }
  }

  void _updateMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: position,
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 16, // Higher zoom for more precision
          ),
          markers: _markers,
          myLocationEnabled: true, // Shows blue dot for current location
          myLocationButtonEnabled:
              true, // Shows button to center on current location
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
          compassEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
            // Once map is created, move to current position
            if (!_isLoading) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentPosition, zoom: 16),
                ),
              );
            }
          },
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: "locationButton",
            backgroundColor: const Color(0xFF3B82F6),
            child: const Icon(Icons.my_location, color: Colors.white),
            onPressed: _getCurrentLocation,
          ),
        ),
      ],
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final address = await getAddressFromLatLng(position);
      widget.onAddressChanged(address);
    } catch (e) {
      print('Error getting address: $e');
      widget.onAddressChanged('Unable to get address');
    }
  }
}
