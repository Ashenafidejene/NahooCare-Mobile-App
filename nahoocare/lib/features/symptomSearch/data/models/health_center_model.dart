class HealthCenterModel {
  final String centerId;
  final String name;
  final double latitude;
  final double longitude;

  HealthCenterModel({
    required this.centerId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory HealthCenterModel.fromJson(Map<String, dynamic> json) {
    return HealthCenterModel(
      centerId: json['center_id'] as String? ?? 'unknown_id',
      name: json['name'] as String? ?? 'Unknown Center',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'center_id': centerId,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
  };
}
