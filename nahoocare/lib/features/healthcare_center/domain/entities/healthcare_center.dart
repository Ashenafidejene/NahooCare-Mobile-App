class HealthcareCenter {
  final String centerId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> specialists;
  final Map<String, String>? contactInfo;
  final List<String> availableTime;
  final double? averageRating;

  const HealthcareCenter({
    required this.centerId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.specialists,
    this.contactInfo,
    required this.availableTime,
    this.averageRating,
  });
  factory HealthcareCenter.empty() {
    return HealthcareCenter(
      centerId: '',
      name: '',
      address: '',
      latitude: 0.0,
      longitude: 0.0,
      specialists: const [],
      contactInfo: const {},
      availableTime: const [],
      averageRating: 0.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HealthcareCenter &&
        other.centerId == centerId &&
        other.name == name &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.specialists == specialists &&
        other.contactInfo == contactInfo &&
        other.availableTime == availableTime &&
        other.averageRating == averageRating;
  }

  @override
  int get hashCode {
    return centerId.hashCode ^
        name.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        specialists.hashCode ^
        contactInfo.hashCode ^
        availableTime.hashCode ^
        averageRating.hashCode;
  }
}
