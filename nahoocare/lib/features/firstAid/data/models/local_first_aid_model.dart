// data/models/local_first_aid_model.dart
import 'package:easy_localization/easy_localization.dart';

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
      emergencyTitle: json['emergency_title'.tr()] as String,
      instructions: List<String>.from(json['instructions'.tr()] as List),
      category: json['category'.tr()] as String,
      image: json['image'.tr()] as String,
    );
  }
}
