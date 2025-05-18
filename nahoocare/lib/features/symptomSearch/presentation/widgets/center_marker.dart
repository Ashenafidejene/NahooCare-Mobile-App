import 'package:flutter/material.dart';
import '../../../healthcare_center/presentation/pages/healthcare_center_details_page.dart';
import '../../domain/entities/health_center.dart';

class CenterMarker extends StatelessWidget {
  final HealthCenter center;

  const CenterMarker({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCenterOptions(context),
      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
    );
  }

  void _showCenterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(center.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('latitude: ${center.latitude}'),
                const SizedBox(height: 8),
                Text('longitude: ${center.longitude}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  _navigateToCenterDetails(context);
                },
                child: const Text('View Details'),
              ),
            ],
          ),
    );
  }

  void _navigateToCenterDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HealthcareCenterDetailsPage(centerId: center.centerId),
      ),
    );
  }
}
