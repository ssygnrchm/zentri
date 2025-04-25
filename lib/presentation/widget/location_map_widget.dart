import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zentri/services/geo_service.dart';

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
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final position = await determineUserLocation();

      setState(() {
        _currentPosition = position;
        _updateMarker(position);
        _isLoading = false;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position, zoom: 15),
          ),
        );
      }

      // Get address from coordinates and notify parent
      _getAddressFromLatLng(position);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error getting current location: $e');
    }
  }

  void _updateMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: position,
        infoWindow: const InfoWindow(title: 'Current Location'),
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
            zoom: 15,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
          },
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            child: const Icon(Icons.my_location),
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
