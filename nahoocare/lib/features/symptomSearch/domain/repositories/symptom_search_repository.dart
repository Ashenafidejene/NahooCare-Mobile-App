import 'package:latlong2/latlong.dart';

import '../entities/search_response.dart';

abstract class SymptomSearchRepository {
  Future<SearchResponse> searchNearbyCenters({
    required String symptoms,
    required double latitude,
    required double longitude,
    double maxDistanceKm = 10, // Default value
  });

  Future<LatLng> getCurrentLocation();

  // Additional helper method
  Future<double> calculateDistance(LatLng start, LatLng end);
}
