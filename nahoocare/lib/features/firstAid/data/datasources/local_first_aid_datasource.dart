import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../../../core/errors/failures.dart';
import '../models/local_first_aid_model.dart';

class LocalFirstAidDataSource {
  Future<Either<Failure, List<LocalFirstAidModel>>> getLocalFirstAid() async {
    try {
      print("test one two three 4");
      final jsonString = await rootBundle.loadString(
        'assets/local_first_aid.json',
      );

      final jsonList = json.decode(jsonString) as List;
      print(jsonList);
      final guides =
          jsonList
              .map(
                (e) => LocalFirstAidModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();

      return Right(guides);
    } catch (e) {
      return Left(CacheFailure('Failed to load local first aid data'));
    }
  }
}
