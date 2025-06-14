import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/search_history_model.dart';

abstract class RemoteSearchHistoryDataSource {
  Future<Either<Failure, List<SearchHistoryModel>>> getRemoteHistory();
  Future<Either<Failure, void>> deleteSearchHistory(String searchId);
  Future<Either<Failure, void>> deleteAllSearchHistory();
}

class RemoteSearchHistoryDataSourceImpl
    implements RemoteSearchHistoryDataSource {
  final ApiClient apiClient;
  static const _tag = 'RemoteSearchHistoryDS';

  RemoteSearchHistoryDataSourceImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<SearchHistoryModel>>> getRemoteHistory() async {
    try {
      final result = await apiClient.get(
        '/api/saved-searches/history/',
        requiresAuth: true,
      );

      try {
        final history =
            (result as List).map((e) => SearchHistoryModel.fromMap(e)).toList();
        return Right(history);
      } catch (e, stackTrace) {
        _logError(
          'getRemoteHistory',
          'Failed to parse history: $e',
          stackTrace,
        );
        return Left(ServerFailure('Failed to load search history', 422));
      }
    } on ApiException catch (e) {
      // Handle API exception
      print("Error deleting account: ${e.message}");
      return Left(ServerFailure("server error", e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllSearchHistory() async {
    try {
      await apiClient.delete(
        '/api/saved-searches/delete-all-history',
        requiresAuth: true,
      );
      return Right("succes fully deleted");
    } on ApiException catch (e) {
      // Handle API exception
      print("Error deleting History: ${e.message}");
      return Left(ServerFailure("server error", e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistory(String searchId) async {
    try {
      await apiClient.delete(
        '/api/saved-searches/delete-history/$searchId',
        requiresAuth: true,
      );
      return Right("succes fully deleted");
    } on ApiException catch (e) {
      // Handle API exception
      print("Error deleting history: ${e.message}");
      return Left(ServerFailure("server error", e.statusCode));
    }
  }

  void _logError(String method, dynamic error, [dynamic extra]) {
    print('[$_tag] $method error: $error');
    if (extra is StackTrace) {
      print(extra);
    } else if (extra != null) {
      print('Additional info: $extra');
    }
    // In production, use a proper logging service
  }
}
