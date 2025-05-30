import 'package:latlong2/latlong.dart';
import '../entities/healthcare_entity.dart';

class SortHealthcareCenter {
  static final Distance _distanceCalculator = const Distance();

  List<HealthcareEntity> call({
    required List<HealthcareEntity> centers,
    required LatLng userLocation,
  }) {
    // Create a copy of the list to avoid modifying the original
    final sortedCenters = List<HealthcareEntity>.from(centers);

    sortedCenters.sort((a, b) {
      final distanceA = _calculateDistance(userLocation, a);
      final distanceB = _calculateDistance(userLocation, b);
      return distanceA.compareTo(distanceB);
    });

    return sortedCenters;
  }

  double _calculateDistance(LatLng userLocation, HealthcareEntity center) {
    return _distanceCalculator.as(
      LengthUnit.Kilometer,
      userLocation,
      LatLng(center.latitude, center.longitude),
    );
  }
}
