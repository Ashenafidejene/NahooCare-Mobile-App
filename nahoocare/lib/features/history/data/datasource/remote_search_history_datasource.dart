import 'package:dartz/dartz.dart';
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
      _logError('getRemoteHistory', e.message, e.statusCode);
      return Left(_handleApiException(e));
    } catch (e, stackTrace) {
      _logError('getRemoteHistory', 'Unexpected error: $e', stackTrace);
      return Left(ServerFailure('Failed to load search history', 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllSearchHistory() async {
    try {
      await apiClient.delete(
        '/api/saved-searches/delete-all-history',
        requiresAuth: true,
      );
      return const Right(null);
    } on ApiException catch (e) {
      _logError('deleteAllSearchHistory', e.message, e.statusCode);
      return Left(_handleApiException(e));
    } catch (e, stackTrace) {
      _logError('deleteAllSearchHistory', 'Unexpected error: $e', stackTrace);
      return Left(ServerFailure('Failed to delete search history', 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistory(String searchId) async {
    try {
      await apiClient.delete(
        '/api/saved-searches/delete-history/$searchId',
        requiresAuth: true,
      );
      return const Right(null);
    } on ApiException catch (e) {
      _logError('deleteSearchHistory', e.message, e.statusCode);
      return Left(_handleApiException(e));
    } catch (e, stackTrace) {
      _logError('deleteSearchHistory', 'Unexpected error: $e', stackTrace);
      return Left(ServerFailure('Failed to delete search item', 500));
    }
  }

  Failure _handleApiException(ApiException e) {
    switch (e.statusCode) {
      case 401:
        return UnauthorizedFailure('Please login to access search history');
      case 404:
        return NotFoundFailure('Search history not found');
      case 500:
      case 502:
      case 503:
        return ServerFailure(
          'Server error, please try again later',
          e.statusCode,
        );
      default:
        return ServerFailure('Failed to complete request', e.statusCode);
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
