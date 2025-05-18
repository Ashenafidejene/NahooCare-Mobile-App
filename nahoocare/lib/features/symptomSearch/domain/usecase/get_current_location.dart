import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/symptom_search_repository.dart';

class GetCurrentLocation implements UseCase<LatLng, NoParams> {
  final SymptomSearchRepository repository;

  const GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, LatLng>> call(NoParams params) async {
    try {
      final location = await repository.getCurrentLocation();
      return Right(location);
    } catch (e) {
     return Left(ServerFailure('Failed to get location: ${e.toString()}',500));
    }
  }
}
