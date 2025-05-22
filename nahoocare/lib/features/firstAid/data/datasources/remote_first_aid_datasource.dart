import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/remote_first_aid_model.dart';

class RemoteFirstAidDataSource {
  final ApiClient client;

  RemoteFirstAidDataSource({required this.client});

  Future<Either<Failure, List<RemoteFirstAidModel>>> getRemoteFirstAid() async {
    try {
      print("test one two three");
      final response = await client.get(
        '/api/first-aid-guide/all',
        requiresAuth: false,
      );
      print(response);
      final guides =
          response.map((item) => RemoteFirstAidModel.fromJson(item)).toList();
      print(guides[0].emergencyTitle);
      return Right(guides);
    } catch (e) {
      print("error happenned");
      return Left(ServerFailure('Failed to fetch remote data', 500));
    }
  }
}
