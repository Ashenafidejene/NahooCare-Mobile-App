import 'package:latlong2/latlong.dart';

import '../../../symptomSearch/data/datasources/location_data_source.dart';
import '../../domain/entities/healthcare_entity.dart';
import '../../domain/repository/healthcare_repository.dart';
import '../datasources/healthcare_remote_data_source.dart';
import '../models/healthcare_search_model.dart';

class HealthcareRepositoriesImpl implements HealthcareRepositories {
  final HealthcareCenterRemoteDataSources remoteDataSource;
  final LocationDataSource locationService;

  HealthcareRepositoriesImpl({
    required this.remoteDataSource,
    required this.locationService,
  });

  @override
  Future<List<HealthcareEntity>> getAllHealthcareCenters() async {
    final models = await remoteDataSource.getAllHealthcareCenters();
    print('Fetched ${models.length} healthcare centers');
    if (models.isEmpty) {
      throw Exception('No healthcare centers found');
    }
    final x = models.map((model) => model.toEntity()).toList();
    print('Converted to entities: ${x.length} centers');
    return x;
  }

  @override
  Future<LatLng> getUserLocation() async {
    return await locationService.getCurrentLocation();
  }

  @override
  Future<List<String>> getAllSpecialties() async {
    final centers = await getAllHealthcareCenters();
    final specialties =
        centers.expand((center) => center.specialties).toSet().toList();
    return specialties;
  }
}
