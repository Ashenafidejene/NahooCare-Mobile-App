class FirstAidModel {
  final String title;
  final String description;
  final List<String> potentialConditions;

  FirstAidModel({
    required this.title,
    required this.description,
    required this.potentialConditions,
  });

  factory FirstAidModel.fromJson(Map<String, dynamic> json) {
    return FirstAidModel(
      title: json['title'] as String? ?? 'No title available',
      description: json['description'] as String? ?? 'No description available',
      potentialConditions:
          (json['potential_conditions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'potential_conditions': potentialConditions,
  };
}
