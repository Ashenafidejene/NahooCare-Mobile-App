import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../healthcare_center/presentation/pages/healthcare_center_details_page.dart';
import '../../domain/entities/health_center.dart';

class HealthCenterList extends StatelessWidget {
  final List<HealthCenter> centers;
  final LatLng userLocation;

  const HealthCenterList({
    Key? key,
    required this.centers,
    required this.userLocation,
  }) : super(key: key);

  double _calculateDistance(LatLng start, double latitude, double longitude) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      latitude,
      longitude,
    );
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: centers.length,
      shrinkWrap: true, // <--- Important
      physics: const NeverScrollableScrollPhysics(), // <--- Important
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final center = centers[index];
        final distanceMeters = _calculateDistance(
          userLocation,
          center.latitude,
          center.longitude,
        );
        final distanceKm = (distanceMeters / 1000).toStringAsFixed(2);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.white10,
              child: Icon(Icons.local_hospital, color: Colors.blueAccent),
            ),
            title: Text(
              center.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '$distanceKm km away',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.blueAccent,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => HealthcareCenterDetailsPage(
                        centerId: center.centerId,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
