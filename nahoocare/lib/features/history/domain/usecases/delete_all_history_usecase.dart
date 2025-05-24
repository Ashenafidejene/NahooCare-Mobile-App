import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/search_history_repository.dart';

class DeleteAllHistoryUseCase implements UseCase<void, NoParams> {
  final SearchHistoryRepository repository;

  DeleteAllHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteAllSearchHistory();
  }
}
