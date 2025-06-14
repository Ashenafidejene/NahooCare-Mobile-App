import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../entities/first_aid_entity.dart';
import '../repository/first_aid_repository.dart';

class GetFirstAidGuides {
  final FirstAidRepository repository;

  GetFirstAidGuides(this.repository);

  Future<Either<Failure, List<FirstAidEntity>>> call(BuildContext context) {
    return repository.getFirstAidGuides(context);
  }
}
