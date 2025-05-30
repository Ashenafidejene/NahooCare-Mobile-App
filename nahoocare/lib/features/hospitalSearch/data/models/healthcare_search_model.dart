import '../../domain/entities/healthcare_entity.dart';

class HealthcareModel extends HealthcareEntity {
  HealthcareModel({
    required String centerId,
    required String name,
    required double latitude,
    required double longitude,
    required List<String> specialties,
  }) : super(
         centerId: centerId,
         name: name,
         latitude: latitude,
         longitude: longitude,
         specialties: specialties,
       );

  factory HealthcareModel.fromJson(Map<String, dynamic> json) {
    return HealthcareModel(
      centerId: json['center_id'] as String, // Explicit casting
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      specialties: List<String>.from(
        json['specialists'] as List,
      ), // Explicit casting
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'center_id': centerId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'specialists': specialties,
    };
  }

  HealthcareEntity toEntity() {
    return HealthcareEntity(
      centerId: centerId,
      name: name,
      latitude: latitude,
      longitude: longitude,
      specialties: specialties,
    );
  }
}
