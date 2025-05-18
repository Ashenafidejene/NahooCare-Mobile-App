import 'first_aid_model.dart';
import 'health_center_model.dart';

class SearchResponseModel {
  final FirstAidModel firstAid;
  final List<HealthCenterModel> centers;

  SearchResponseModel({required this.firstAid, required this.centers});

  factory SearchResponseModel.fromJson(List<dynamic> json) {
    // Parse first aid data (first element in the list)
    final firstAidJson = json[0] as Map<String, dynamic>? ?? {};
    final firstAid = FirstAidModel.fromJson({
      'title': firstAidJson['first_aid']?['title'],
      'description': firstAidJson['first_aid']?['description'],
      'potential_conditions': firstAidJson['potential_conditions'],
    });

    // Parse centers data (second element in the list)
    final centersJson = json[1] as List<dynamic>? ?? [];
    final centers =
        centersJson
            .map(
              (centerJson) => HealthCenterModel.fromJson(
                centerJson as Map<String, dynamic>? ?? {},
              ),
            )
            .toList();

    return SearchResponseModel(firstAid: firstAid, centers: centers);
  }

  Map<String, dynamic> toJson() => {
    'first_aid': firstAid.toJson(),
    'centers': centers.map((center) => center.toJson()).toList(),
  };
}
