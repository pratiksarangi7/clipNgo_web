import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:mapbox_gl/mapbox_gl.dart' hide LatLng;

class MapScreen extends StatefulWidget {
  final Function(latlng.LatLng latlng) onLocationSelected;

  const MapScreen({super.key, required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMapController _mapController;
  late latlng.LatLng _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: MapboxMap(
        initialCameraPosition: CameraPosition(
          target: latlng.LatLng,
          zoom: 10.0,
        ),
        accessToken: '<YOUR_ACCESS_TOKEN>',
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (latlng.LatLng location) {
          setState(() {
            _selectedLocation = location;
          });
        },
        markers: _selectedLocation != null
            ? Set<Marker>.from([
                Marker(
                  markerId: MarkerId('selected_location'),
                  position: _selectedLocation,
                ),
              ])
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedLocation != null) {
            widget.onLocationSelected(_selectedLocation);
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
