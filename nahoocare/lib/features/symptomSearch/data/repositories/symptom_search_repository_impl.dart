import '../../../../core/network/api_client.dart';
import '../../domain/entities/search_response.dart';
import '../../domain/entities/health_center.dart';
import '../../domain/entities/first_aid.dart';
import '../../domain/repositories/symptom_search_repository.dart';
import '../datasources/symptom_search_remote_data_source.dart';
import '../datasources/location_data_source.dart';
import '../models/search_response_model.dart';
import 'package:latlong2/latlong.dart';

class SymptomSearchRepositoryImpl implements SymptomSearchRepository {
  final SymptomSearchRemoteDataSource remoteDataSource;
  final LocationDataSource locationDataSource;

  SymptomSearchRepositoryImpl({
    required this.remoteDataSource,
    required this.locationDataSource,
  });

  @override
  Future<SearchResponse> searchNearbyCenters({
    required String symptoms,
    required double latitude,
    required double longitude,
    double maxDistanceKm = 10,
  }) async {
    try {
      final response = await remoteDataSource.searchNearbyCenters(
        symptoms: symptoms,
        latitude: latitude,
        longitude: longitude,
        maxDistanceKm: maxDistanceKm,
      );

      // Validate the response structure
      if (response is! List || response.isEmpty) {
        throw FormatException(
          'Invalid response format - expected non-empty List',
        );
      }

      final responseModel = SearchResponseModel.fromJson(response);
      final userLocation = LatLng(latitude, longitude);

      return SearchResponse(
        firstAid:
            responseModel.firstAid != null
                ? FirstAid(
                  title: responseModel.firstAid!.title,
                  description: responseModel.firstAid!.description,
                  potentialConditions:
                      responseModel.firstAid!.potentialConditions,
                )
                : FirstAid(
                  title: 'Medical Advice',
                  description:
                      'Consult a healthcare professional for your symptoms',
                  potentialConditions: [],
                ),
        centers:
            responseModel.centers.map((center) {
              return HealthCenter(
                centerId: center.centerId,
                name: center.name,
                latitude: center.latitude,
                longitude: center.longitude,
              );
            }).toList(),
        userLocation: userLocation,
      );
    } on FormatException catch (e) {
      throw ApiException(
        statusCode: 200, // Success code but invalid format
        message: 'Failed to process response: ${e.message}',
      );
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Failed to search nearby centers: ${e.toString()}',
      );
    }
  }

  @override
  Future<LatLng> getCurrentLocation() async {
    try {
      return await locationDataSource.getCurrentLocation();
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Failed to get current location: ${e.toString()}',
      );
    }
  }

  @override
  Future<double> calculateDistance(LatLng start, LatLng end) async {
    try {
      const Distance distance = Distance();
      return distance.as(LengthUnit.Kilometer, start, end);
    } catch (e) {
      throw ApiException(
        statusCode: 500,
        message: 'Failed to calculate distance: ${e.toString()}',
      );
    }
  }
}
