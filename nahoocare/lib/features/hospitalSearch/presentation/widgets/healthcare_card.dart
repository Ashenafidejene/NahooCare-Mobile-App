import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/healthcare_entity.dart';

class HealthcareCard extends StatelessWidget {
  final HealthcareEntity healthcare;
  final LatLng? currentLocation; // Make nullable

  const HealthcareCard({
    Key? key,
    required this.healthcare,
    this.currentLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? distance;

    if (currentLocation != null) {
      distance = _calculateDistance(
        currentLocation!.latitude,
        currentLocation!.longitude,
        healthcare.latitude,
        healthcare.longitude,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              healthcare.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (distance != null)
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${distance.toStringAsFixed(1)} km'),
                ],
              ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Simple distance calculation (replace with Haversine formula for accuracy)
    return ((lat1 - lat2).abs() + (lon1 - lon2).abs()) * 111; // Approximate km
  }
}
