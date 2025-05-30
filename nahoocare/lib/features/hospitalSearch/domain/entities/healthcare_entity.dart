import 'package:flutter/foundation.dart';

class HealthcareEntity {
  final String centerId;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> specialties;

  HealthcareEntity({
    required this.centerId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.specialties,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthcareEntity &&
        other.centerId == centerId &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        listEquals(other.specialties, specialties);
  }

  @override
  int get hashCode {
    return centerId.hashCode ^
        name.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        specialties.hashCode;
  }
}
