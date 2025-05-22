// data/models/remote_first_aid_model.dart
class RemoteFirstAidModel {
  final String emergencyTitle;
  final List<String> instructions;
  final String category;
  final String image;

  RemoteFirstAidModel({
    required this.emergencyTitle,
    required this.instructions,
    required this.category,
    required this.image,
  });

  factory RemoteFirstAidModel.fromJson(Map<String, dynamic> json) {
    return RemoteFirstAidModel(
      emergencyTitle: json['emergency_title'] as String,
      instructions: List<String>.from(json['instructions'] as List),
      category: json['category'] as String,
      image: json['image_url'] as String,
    );
  }
}
