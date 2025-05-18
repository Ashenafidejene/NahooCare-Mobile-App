import 'package:latlong2/latlong.dart';

class HealthCenter {
  final String centerId;
  final String name;
  final double latitude;
  final double longitude;

  const HealthCenter({
    required this.centerId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthCenter &&
          runtimeType == other.runtimeType &&
          centerId == other.centerId;

  @override
  int get hashCode => centerId.hashCode;

  // Helper method to convert to LatLng for mapping
  LatLng toLatLng() => LatLng(latitude, longitude);
}
