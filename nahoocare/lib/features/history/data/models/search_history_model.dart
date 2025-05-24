import '../../domain/entities/search_history_entity.dart';

class SearchHistoryModel {
  final String searchId;
  final String searchParameters;
  final int resultsCount;
  final Map<String, String> firstAid;
  final List<String> potentialConditions;
  final String createdAt;

  SearchHistoryModel({
    required this.searchId,
    required this.searchParameters,
    required this.resultsCount,
    required this.firstAid,
    required this.potentialConditions,
    required this.createdAt,
  });

  // Convert model to entity
  SearchHistoryEntity toEntity() => SearchHistoryEntity(
    searchId: searchId,
    searchParameters: searchParameters,
    resultsCount: resultsCount,
    firstAid: firstAid,
    potentialConditions: potentialConditions,
    createdAt: DateTime.parse(createdAt),
  );

  // Convert entity to model
  factory SearchHistoryModel.fromEntity(SearchHistoryEntity entity) =>
      SearchHistoryModel(
        searchId: entity.searchId,
        searchParameters: entity.searchParameters,
        resultsCount: entity.resultsCount,
        firstAid: entity.firstAid,
        potentialConditions: entity.potentialConditions,
        createdAt: entity.createdAt.toIso8601String(),
      );

  // Convert model to Map
  Map<String, dynamic> toMap() => {
    'searchId': searchId,
    'searchParameters': searchParameters,
    'resultsCount': resultsCount,
    'firstAid': firstAid,
    'potentialConditions': potentialConditions,
    'createdAt': createdAt,
  };

  // Convert Map to model
  factory SearchHistoryModel.fromMap(Map<String, dynamic> map) =>
      SearchHistoryModel(
        searchId: map['search_id'],
        searchParameters: map['search_parameters'],
        resultsCount: map['results_count'],
        firstAid: Map<String, String>.from(map['first_aid']),
        potentialConditions: List<String>.from(map['potential_conditions']),
        createdAt: map['created_at'],
      );
}
