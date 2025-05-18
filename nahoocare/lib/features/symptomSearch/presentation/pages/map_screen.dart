import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/health_center.dart';
import '../widgets/center_marker.dart';
import '../widgets/location_button.dart';

class MapScreen extends StatefulWidget {
  final List<HealthCenter> centers;
  final LatLng userLocation;

  const MapScreen({Key? key, required this.centers, required this.userLocation})
    : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Centers Map')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.userLocation,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.userLocation,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  ...widget.centers.map(
                    (center) => Marker(
                      point: center.toLatLng(),
                      child: CenterMarker(center: center),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: LocationButton(onPressed: _zoomToUserLocation),
          ),
        ],
      ),
    );
  }

  void _zoomToUserLocation() {
    _mapController.move(widget.userLocation, 13.0);
  }
}
