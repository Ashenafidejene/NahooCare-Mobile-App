import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/healthcare_search_model.dart';

abstract class HealthcareCenterRemoteDataSources {
  Future<List<HealthcareModel>> getAllHealthcareCenters();
}

class HealthcareCenterRemoteDataSourcesImpl
    implements HealthcareCenterRemoteDataSources {
  final ApiClient apiClient; // Your HTTP client (Dio, http, etc.)

  HealthcareCenterRemoteDataSourcesImpl({required this.apiClient});

  @override
  Future<List<HealthcareModel>> getAllHealthcareCenters() async {
    try {
      final response = await apiClient.get(
        '/api/healthcare/user/total_healthcare/',
        requiresAuth: true,
      );

      // Add type checking for the response
      if (response is! List) {
        throw const FormatException('Expected a list from the API');
      }

      // Explicitly cast each item to Map<String, dynamic>
      final List<HealthcareModel> centers =
          response
              .where(
                (item) => item is Map<String, dynamic>,
              ) // Filter valid items
              .map<HealthcareModel>(
                (item) =>
                    HealthcareModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();

      print('Successfully parsed ${centers.length} healthcare centers');
      return centers;
    } on FormatException catch (e) {
      print('Format error: ${e.message}');
      throw ServerFailure('Invalid data format from server', 500);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, e.statusCode);
    } catch (e) {
      print("Unexpected error: ${e.toString()}");
      throw ServerFailure('An unexpected error occurred', 500);
    }
  }
}
