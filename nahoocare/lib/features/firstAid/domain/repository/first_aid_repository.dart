import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../entities/first_aid_entity.dart';

abstract class FirstAidRepository {
  Future<Either<Failure, List<FirstAidEntity>>> getFirstAidGuides(
    BuildContext context,
  );
}
