import '../../domain/entities/healthcare_center.dart';

class HealthcareCenterModel extends HealthcareCenter {
  const HealthcareCenterModel({
    required String centerId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required List<String> specialists,
    Map<String, String>? contactInfo,
    required List<String> availableTime,
    double? averageRating,
  }) : super(
         centerId: centerId,
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         specialists: specialists,
         contactInfo: contactInfo,
         availableTime: availableTime,
         averageRating: averageRating,
       );

  factory HealthcareCenterModel.fromJson(Map<String, dynamic> json) {
    // Handle null values for all list fields
    List<String> safeListConvert(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      return [];
    }

    Map<String, String>? safeMapConvert(dynamic value) {
      if (value == null) return null;
      if (value is Map) return Map<String, String>.from(value);
      return null;
    }

    return HealthcareCenterModel(
      centerId: json['center_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      address: json['address'] ?? 'Not available',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      specialists: safeListConvert(json['specialties'] ?? json['specialists']),
      contactInfo: safeMapConvert(json['contact_info']),
      availableTime: safeListConvert(
        json['available_time'] ?? json['operating_hours'],
      ),
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': centerId,
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'specialties': specialists,
    'contact_info': contactInfo,
    'available_time': availableTime,
    'average_rating': averageRating,
  };
}
