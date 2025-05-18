import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/search_response.dart';
import '../repositories/symptom_search_repository.dart';

class SearchNearbyCenters implements UseCase<SearchResponse, SearchParams> {
  final SymptomSearchRepository repository;

  const SearchNearbyCenters(this.repository);

  @override
  Future<Either<Failure, SearchResponse>> call(SearchParams params) async {
    try {
      final result = await repository.searchNearbyCenters(
        symptoms: params.symptoms,
        latitude: params.latitude,
        longitude: params.longitude,
        maxDistanceKm: params.maxDistanceKm,
      );
      return Right(result);
    } catch (e) {
      // You may want to provide a more specific Failure type
      return Left(
        ServerFailure('Failed to get nearby centers: ${e.toString()}', 500),
      );
    }
  }
}

class SearchParams {
  final String symptoms;
  final double latitude;
  final double longitude;
  final double maxDistanceKm;

  const SearchParams({
    required this.symptoms,
    required this.latitude,
    required this.longitude,
    this.maxDistanceKm = 10, // Default 10km radius
  });
}
