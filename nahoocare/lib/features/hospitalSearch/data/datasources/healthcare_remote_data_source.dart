import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/healthcare_entity.dart';
import '../models/healthcare_search_model.dart';

abstract class HealthcareRemoteDataSources {
  Future<Either<Failure, List<HealthcareEntity>>> searchHealthcare({
    String? name,
    List<String>? specialties,
    double? latitude,
    double? longitude,
    int maxDistanceKm = 10,
  });
}

class HealthcareRemoteDataSourcesImpl implements HealthcareRemoteDataSources {
  final ApiClient apiClient; // Your HTTP client (Dio, http, etc.)

  HealthcareRemoteDataSourcesImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<HealthcareEntity>>> searchHealthcare({
    String? name,
    List<String>? specialties,
    double? latitude,
    double? longitude,
    int maxDistanceKm = 10,
  }) async {
    try {
      // Create request model
      final request = HealthcareSearchModel(
        name: name ?? '',
        specialties: specialties ?? [],
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
        maxDistanceKm: maxDistanceKm,
      );
      print(request.toJson());
      // Make API call (adapt to your actual API)
      final response = await apiClient.post(
        '/api/healthcaresearch/specification/',
        request.toJson(),
        requiresAuth: true,
      );
      print(response);
      // Parse response
      final List<HealthcareEntity> results =
          (response as List)
              .map(
                (item) => HealthcareEntity(
                  centerId: item['center_id'],
                  name: item['name'],
                  latitude: item['latitude'],
                  longitude: item['longitude'],
                ),
              )
              .toList();

      return Right(results);
    } on ServerException {
      return Left(ServerFailure('Server error', 500));
    } on NetworkException {
      return Left(NetworkFailure('Network error'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}', 500));
    }
  }
}
