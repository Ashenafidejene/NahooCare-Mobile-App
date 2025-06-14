import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
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
      final guides =
          (response as List<dynamic>)
              .map(
                (item) =>
                    RemoteFirstAidModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      print(guides[0].emergencyTitle);
      return Right(guides);
    } catch (e) {
      print("error happenned ${e.toString()}");
      return Left(ServerFailure('Failed to fetch remote data', 500));
    }
  }
}
