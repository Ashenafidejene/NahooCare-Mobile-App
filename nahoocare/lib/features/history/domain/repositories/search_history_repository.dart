import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/search_history_entity.dart';

abstract class SearchHistoryRepository {
  Future<Either<Failure, List<SearchHistoryEntity>>> getSearchHistory();
  Future<Either<Failure, void>> deleteSearchHistory(String searchId);
  Future<Either<Failure, void>> deleteAllSearchHistory();
}
