class HealthcareSearchModel {
  final String? name;
  final List<String>? specialties;
  final double? latitude;
  final double? longitude;
  final int maxDistanceKm;

  HealthcareSearchModel({
    this.name,
    this.specialties,
    this.latitude,
    this.longitude,
    this.maxDistanceKm = 10,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (specialties != null) 'specialty': specialties,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    'max_distance_km': maxDistanceKm,
  };

  // Add fromJson if needed
}
