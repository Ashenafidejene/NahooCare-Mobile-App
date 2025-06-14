// data/models/remote_first_aid_model.dart
import 'package:easy_localization/easy_localization.dart';

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
      emergencyTitle: json['emergency_title'.tr()] as String,
      instructions: List<String>.from(json['instructions'.tr()] as List),
      category: json['category'.tr()] as String,
      image: json['image_url'.tr()] as String,
    );
  }
}
