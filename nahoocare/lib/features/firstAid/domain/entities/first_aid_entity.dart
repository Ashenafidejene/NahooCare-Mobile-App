// domain/entities/first_aid_entity.dart
class FirstAidEntity {
  final String emergencyTitle;
  final List<String> instructions;
  final String category;
  final String image;

  FirstAidEntity({
    required this.emergencyTitle,
    required this.instructions,
    required this.category,
    required this.image,
  });
}
