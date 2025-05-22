import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/first_aid_entity.dart';
import '../repository/first_aid_repository.dart';

class GetFirstAidGuides {
  final FirstAidRepository repository;

  GetFirstAidGuides(this.repository);

  Future<Either<Failure, List<FirstAidEntity>>> call() async {
    return await repository.getFirstAidGuides();
  }
}
