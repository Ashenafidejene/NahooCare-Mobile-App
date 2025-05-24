import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/search_history_entity.dart';
import '../../domain/repositories/search_history_repository.dart';

import '../datasource/remote_search_history_datasource.dart';
import '../models/search_history_model.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final RemoteSearchHistoryDataSource remoteDataSource;

  SearchHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SearchHistoryEntity>>> getSearchHistory() async {
    final result = await remoteDataSource.getRemoteHistory();
    return result.map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistory(String searchId) async {
    return await remoteDataSource.deleteSearchHistory(searchId);
  }

  @override
  Future<Either<Failure, void>> deleteAllSearchHistory() async {
    return await remoteDataSource.deleteAllSearchHistory();
  }
}
