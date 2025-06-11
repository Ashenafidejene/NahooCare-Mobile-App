import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/account_model.dart';

abstract class AccountRemoteDataSource {
  Future<AccountResponse> getAccount();
  Future<void> updateAccount(UpdateAccountRequest request);
  Future<void> deleteAccount();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiClient apiClient;
  static const _tag = 'AccountRemoteDataSource';

  AccountRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AccountResponse> getAccount() async {
    try {
      final response = await apiClient.get('/api/account/', requiresAuth: true);
      return AccountResponse.fromJson(response);
    } on ApiException catch (e) {
      _logError('getAccount', e.message, e.statusCode);
      throw ServerFailure('errors.account.fetch_failed'.tr(), e.statusCode);
    } catch (e, stackTrace) {
      _logUnexpectedError('getAccount', e, stackTrace);
      throw ServerFailure('errors.unexpected'.tr(), 500);
    }
  }

  @override
  Future<void> updateAccount(UpdateAccountRequest request) async {
    try {
      // final x = request.toJson();
      // print('UpdateAccountRequest: $x');
      final x = {
        "full_name": request.fullName,
        "phone_number": request.phoneNumber,
        "secret_question": request.secretQuestion,
        "secret_answer": request.secretAnswer,
        "date_of_birth": request.dataOfBirth,
        "photo_url": request.photoUrl,
        "gender": request.gender,
        "password": request.password,
      };
      debugPrint('UpdateAccountRequest: $x');
      // Sending the request to update account details
      await apiClient.put('/api/account/update/', {
        "full_name": request.fullName,
        "phone_number": request.phoneNumber,
        "secret_question": request.secretQuestion,
        "secret_answer": request.secretAnswer,
        "date_of_birth": request.dataOfBirth,
        "photo_url": request.photoUrl,
        "gender": request.gender,
        "password": request.password,
      }, requiresAuth: true);
    } on ApiException catch (e) {
      _logError('updateAccount one', e.message, e.statusCode);
      throw ServerFailure('error ${e.message}', e.statusCode);
    } catch (e, stackTrace) {
      _logUnexpectedError('updateAccount two', e, stackTrace);
      throw ServerFailure('errors.unexpected'.tr(), 500);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await apiClient.delete('/api/account/', requiresAuth: true);
    } on ApiException catch (e) {
      _logError('deleteAccount', e.message, e.statusCode);
      throw ServerFailure('errors.account.delete_failed'.tr(), e.statusCode);
    } catch (e, stackTrace) {
      _logUnexpectedError('deleteAccount', e, stackTrace);
      throw ServerFailure('errors.unexpected'.tr(), 500);
    }
  }

  void _logError(String method, String message, int? statusCode) {
    print('[$_tag] $method failed with status $statusCode: $message');
    // Consider using a proper logging package here
  }

  void _logUnexpectedError(
    String method,
    dynamic error,
    StackTrace stackTrace,
  ) {
    print('[$_tag] Unexpected error in $method: $error');
    print(stackTrace);
    // Consider using a proper logging package here
  }
}
