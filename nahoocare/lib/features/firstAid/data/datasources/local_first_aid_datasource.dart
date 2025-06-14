import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/errors/failures.dart';
import '../models/local_first_aid_model.dart';

class LocalFirstAidDataSource {
  final Locale locale;

  LocalFirstAidDataSource({required this.locale});

  Future<Either<Failure, List<LocalFirstAidModel>>> getLocalFirstAid() async {
    try {
      String filePath;

      // Determine file path based on language code
      if (locale.languageCode == 'am') {
        filePath = 'assets/amharic_first_aid.json';
      } else {
        filePath = 'assets/local_first_aid.json';
      }

      final jsonString = await rootBundle.loadString(filePath);
      final jsonList = json.decode(jsonString) as List;

      final guides = jsonList
          .map((e) => LocalFirstAidModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(guides);
    } catch (e, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: stackTrace,
          library: 'LocalFirstAidDataSource',
          context: ErrorDescription('while loading local first aid data'),
        ),
      );

      return Left(CacheFailure('local_first_aid_load_error'.tr()));
    }
  }
}
