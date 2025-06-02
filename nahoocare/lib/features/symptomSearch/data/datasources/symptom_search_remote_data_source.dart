import 'package:flutter/material.dart' show debugPrint;

import '../../../../core/network/api_client.dart';

abstract class SymptomSearchRemoteDataSource {
  Future<List<dynamic>> searchNearbyCenters({
    required String symptoms,
    required double latitude,
    required double longitude,
    double maxDistanceKm = 10,
  });
}

class SymptomSearchRemoteDataSourceImpl
    implements SymptomSearchRemoteDataSource {
  final ApiClient apiClient;
  SymptomSearchRemoteDataSourceImpl({required this.apiClient});

  Object? get laitude => null;

  @override
  Future<List<dynamic>> searchNearbyCenters({
    required String symptoms,
    required double latitude,
    required double longitude,
    double maxDistanceKm = 10,
  }) async {
    print(symptoms);
    print(latitude);
    print(longitude);
    final response = await apiClient.post('/api/endpoint/search', {
      'symptom': symptoms,
      'latitude': latitude,
      'longitude': longitude,
      'max_distance_km': maxDistanceKm,
    }, requiresAuth: true);
    debugPrint("Response: $response");
    return response as List<dynamic>;
  }
}
