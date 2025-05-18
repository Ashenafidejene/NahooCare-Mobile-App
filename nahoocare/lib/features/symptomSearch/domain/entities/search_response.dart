import 'package:latlong2/latlong.dart';
import 'first_aid.dart';
import 'health_center.dart';

class SearchResponse {
  final FirstAid? firstAid; // Made nullable if not always available
  final List<HealthCenter> centers;
  final LatLng userLocation;

  const SearchResponse({
    this.firstAid,
    required this.centers,
    required this.userLocation,
  });
}
