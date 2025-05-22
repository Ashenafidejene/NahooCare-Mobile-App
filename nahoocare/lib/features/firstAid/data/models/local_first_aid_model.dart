// data/models/local_first_aid_model.dart
class LocalFirstAidModel {
  final String emergencyTitle;
  final List<String> instructions;
  final String category;
  final String image;

  LocalFirstAidModel({
    required this.emergencyTitle,
    required this.instructions,
    required this.category,
    required this.image,
  });

  factory LocalFirstAidModel.fromJson(Map<String, dynamic> json) {
    return LocalFirstAidModel(
      emergencyTitle: json['emergency_title'] as String,
      instructions: List<String>.from(json['instructions'] as List),
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}
