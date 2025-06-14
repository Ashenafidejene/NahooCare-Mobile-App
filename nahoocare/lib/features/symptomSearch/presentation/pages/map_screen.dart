import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../healthcare_center/presentation/pages/healthcare_center_details_page.dart';
import '../../domain/entities/health_center.dart';
import '../widgets/center_marker.dart';
import '../widgets/location_button.dart';

class MapScreen extends StatefulWidget {
  final List<HealthCenter> centers;
  final LatLng userLocation;

  const MapScreen({Key? key, required this.centers, required this.userLocation})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  final Distance _distance = const Distance();

  late final List<Marker> _centerMarkers;

  @override
  void initState() {
    super.initState();

    _centerMarkers = widget.centers.map((center) {
      return Marker(
        width: 60,
        height: 60,
        point: center.toLatLng(),
        child: CustomMarker(imagePath: 'assets/images/logo (2).png'),
        key: ValueKey(center.centerId),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.blueAccent,
          ), // Larger back icon
          onPressed: () => Navigator.maybePop(context), // Safer pop
        ),
        title: Text('nearby_health_centers'.tr()),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.userLocation,
              initialZoom: 13,
              onTap: (_, __) => _popupController.hideAllPopups(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50,
                    height: 50,
                    point: widget.userLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                  ),
                ],
              ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  popupController: _popupController,
                  markers: _centerMarkers,
                  markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext context, Marker marker) {
                      final HealthCenter center = widget.centers.firstWhere(
                        (c) =>
                            (c.latitude - marker.point.latitude).abs() < 1e-6 &&
                            (c.longitude - marker.point.longitude).abs() < 1e-6,
                      );

                      final distanceInKm = _distance
                          .as(
                            LengthUnit.Kilometer,
                            widget.userLocation,
                            center.toLatLng(),
                          )
                          .toStringAsFixed(2);

                      return Card(
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                center.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('distance_label'.tr(args: [distanceInKm])),
                              const SizedBox(height: 6),
                              Text(
                                'lat_long_label'
                                    .tr(args: [center.latitude.toString(), center.longitude.toString()]),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HealthcareCenterDetailsPage(centerId: center.centerId),
                                    ),
                                  );
                                },
                                child: Text('view_details'.tr()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: LocationButton(onPressed: _zoomToUserLocation),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _zoomToUserLocation() {
    _mapController.move(widget.userLocation, 13.0);
  }
}
