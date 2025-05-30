import '../entities/healthcare_entity.dart';

class FilterHealthcareCenter {
  List<HealthcareEntity> call({
    required List<HealthcareEntity> centers,
    String? searchQuery,
    List<String>? selectedSpecialties,
  }) {
    return centers.where((center) {
      // Name matching (case insensitive)
      final nameMatch =
          searchQuery == null ||
          center.name.toLowerCase().contains(searchQuery.toLowerCase());

      // Specialty matching (if any specialties are selected)
      final specialtyMatch =
          selectedSpecialties == null ||
          selectedSpecialties.isEmpty ||
          selectedSpecialties.any(
            (specialty) => center.specialties.any(
              (s) => s.toLowerCase() == specialty.toLowerCase(),
            ),
          );

      return nameMatch && specialtyMatch;
    }).toList();
  }
}
