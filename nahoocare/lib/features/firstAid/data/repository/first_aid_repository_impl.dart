import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/first_aid_entity.dart';
import '../../domain/repository/first_aid_repository.dart';
import '../datasources/local_first_aid_datasource.dart';
import '../datasources/remote_first_aid_datasource.dart';
import '../models/local_first_aid_model.dart';
import '../models/remote_first_aid_model.dart';

class FirstAidRepositoryImpl implements FirstAidRepository {
  final RemoteFirstAidDataSource remoteDataSource;
  final Connectivity connectivity;

  FirstAidRepositoryImpl({
    required this.remoteDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<FirstAidEntity>>> getFirstAidGuides(
    BuildContext context,
  ) async {
    try {
      final isConnected =
          await connectivity.checkConnectivity() != ConnectivityResult.none;

      final localDataSource = LocalFirstAidDataSource(locale: context.locale);
      final localResult = await localDataSource.getLocalFirstAid();

      return localResult.fold((failure) => Left(failure), (localGuides) async {
        if (isConnected) {
          final remoteResult = await remoteDataSource.getRemoteFirstAid();
          return remoteResult.fold(
            (failure) => Right(_mapLocalToEntities(localGuides)),
            (remoteGuides) => Right([
              ..._mapLocalToEntities(localGuides),
              ..._mapRemoteToEntities(remoteGuides),
            ]),
          );
        }
        return Right(_mapLocalToEntities(localGuides));
      });
    } catch (e) {
      return Left(UnknownFailure(message: 'Unknown error occurred'));
    }
  }

  List<FirstAidEntity> _mapLocalToEntities(List<LocalFirstAidModel> models) {
    return models
        .map(
          (model) => FirstAidEntity(
            emergencyTitle: model.emergencyTitle,
            instructions: model.instructions,
            category: model.category,
            image: model.image,
          ),
        )
        .toList();
  }

  List<FirstAidEntity> _mapRemoteToEntities(List<RemoteFirstAidModel> models) {
    return models
        .map(
          (model) => FirstAidEntity(
            emergencyTitle: model.emergencyTitle,
            instructions: model.instructions,
            category: model.category,
            image: model.image,
          ),
        )
        .toList();
  }
}
