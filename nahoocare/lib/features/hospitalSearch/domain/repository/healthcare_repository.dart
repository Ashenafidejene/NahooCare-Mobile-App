import 'package:latlong2/latlong.dart';
import '../entities/healthcare_entity.dart';

abstract class HealthcareRepositories {
  Future<List<HealthcareEntity>> getAllHealthcareCenters();
  Future<LatLng> getUserLocation();
  Future<List<String>> getAllSpecialties();
}
