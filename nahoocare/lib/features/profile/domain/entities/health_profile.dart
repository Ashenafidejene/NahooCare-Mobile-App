import 'package:equatable/equatable.dart';

class HealthProfile extends Equatable {
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> medicalHistory;

  const HealthProfile({
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.medicalHistory,
  });

  // Add copyWith method for easy updates
  HealthProfile copyWith({
    String? bloodType,
    List<String>? allergies,
    List<String>? chronicConditions,
    List<String>? medicalHistory,
  }) {
    return HealthProfile(
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      medicalHistory: medicalHistory ?? this.medicalHistory,
    );
  }

  @override
  List<Object> get props => [
    bloodType,
    allergies,
    chronicConditions,
    medicalHistory,
  ];
}
