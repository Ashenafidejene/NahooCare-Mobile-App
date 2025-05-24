import 'package:equatable/equatable.dart';

class SearchHistoryEntity extends Equatable {
  final String searchId;
  final String searchParameters;
  final int resultsCount;
  final Map<String, String> firstAid;
  final List<String> potentialConditions;
  final DateTime createdAt;

  const SearchHistoryEntity({
    required this.searchId,
    required this.searchParameters,
    required this.resultsCount,
    required this.firstAid,
    required this.potentialConditions,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    searchId,
    searchParameters,
    resultsCount,
    firstAid,
    potentialConditions,
    createdAt,
  ];
}
