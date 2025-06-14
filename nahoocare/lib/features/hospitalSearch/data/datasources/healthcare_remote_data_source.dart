import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/healthcare_search_model.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class HealthcareCenterRemoteDataSources {
  Future<List<HealthcareModel>> getAllHealthcareCenters();
}

class HealthcareCenterRemoteDataSourcesImpl
    implements HealthcareCenterRemoteDataSources {
  final ApiClient apiClient;

  HealthcareCenterRemoteDataSourcesImpl({required this.apiClient});

  @override
  Future<List<HealthcareModel>> getAllHealthcareCenters() async {
    try {
      final response = await apiClient.get(
        '/api/healthcare/user/total_healthcare/',
        requiresAuth: true,
      );

      if (response is! List) {
        // 👇 Cannot use `.tr()` inside const constructor, so move it outside
        throw FormatException('Expected a list from the API'.tr());
      }

      final List<HealthcareModel> centers = response
          .where((item) => item is Map<String, dynamic>)
          .map<HealthcareModel>(
            (item) => HealthcareModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();

      print('Successfully parsed ${centers.length} healthcare centers'.tr());
      return centers;
    } on FormatException catch (e) {
      print('Format error: ${e.message}'.tr());
      throw ServerFailure('Invalid data format from server'.tr(), 500);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, e.statusCode);
    } catch (e) {
      print("Unexpected error: ${e.toString()}".tr());
      throw ServerFailure('An unexpected error occurred'.tr(), 500);
    }
  }
}
