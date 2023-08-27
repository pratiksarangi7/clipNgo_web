import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key, required this.myLatitude, required this.myLongitude});
  final double myLatitude;
  final double myLongitude;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  var _finalLatitude;
  var _finalLongitude;

  void handleTap(LatLng latLng) {
    setState(
      () {
        _selectedLocation = latLng;
        _finalLatitude = _selectedLocation!.latitude;
        _finalLongitude = _selectedLocation!.longitude;
        print("The latitude is: $_finalLatitude");
        print("The longitude is: $_finalLongitude");
      },
    );
  }

  @override
  void initState() {
    _finalLatitude = widget.myLatitude;
    _finalLongitude = widget.myLongitude;
    print("The latitude is: $_finalLatitude");
    print("The longitude is: $_finalLongitude");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: FlutterMap(
        options: MapOptions(
          // center: LatLng(widget.myLatitude, widget.myLongitude),
          center: LatLng(widget.myLatitude, widget.myLongitude),
          zoom: 16,
          maxZoom: 18,
          onTap: (_, LatLng latLng) {
            handleTap(latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/bytebuilders/clllthx6501f601phhv8s1f2w/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYnl0ZWJ1aWxkZXJzIiwiYSI6ImNsbGtwdDI4cTB5c2czZnBheWRvc21yczEifQ.fbPEIx1XlNGrznz-pC6wng',
            userAgentPackageName: 'com.example.app',
            additionalOptions: const {
              'accessToken':
                  'pk.eyJ1IjoiYnl0ZWJ1aWxkZXJzIiwiYSI6ImNsbGtwdDI4cTB5c2czZnBheWRvc21yczEifQ.fbPEIx1XlNGrznz-pC6wng',
              'id': 'mapbox.mapbox-streets-v8',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: (_selectedLocation == null)
                    ? LatLng(widget.myLatitude, widget.myLongitude)
                    : _selectedLocation!,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
