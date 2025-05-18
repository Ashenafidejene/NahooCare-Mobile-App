import 'package:equatable/equatable.dart';

import '../../domain/entities/health_profile.dart';

class HealthProfileModel extends Equatable {
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> medicalHistory;

  const HealthProfileModel({
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.medicalHistory,
  });

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) {
    return HealthProfileModel(
      bloodType: json['blood_type'],
      allergies: List<String>.from(json['allergies']),
      chronicConditions: List<String>.from(json['chronic_conditions']),
      medicalHistory: List<String>.from(json['medical_history']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blood_type': bloodType,
      'allergies': allergies,
      'chronic_conditions': chronicConditions,
      'medical_history': medicalHistory,
    };
  }

  // Convert model to entity
  HealthProfile toEntity() {
    return HealthProfile(
      bloodType: bloodType,
      allergies: allergies,
      chronicConditions: chronicConditions,
      medicalHistory: medicalHistory,
    );
  }

  // Convert entity to model
  factory HealthProfileModel.fromEntity(HealthProfile entity) {
    return HealthProfileModel(
      bloodType: entity.bloodType,
      allergies: entity.allergies,
      chronicConditions: entity.chronicConditions,
      medicalHistory: entity.medicalHistory,
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
