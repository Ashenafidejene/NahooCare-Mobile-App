import 'package:http/http.dart';
import 'package:nahoocare/core/errors/failures.dart';

import '../../../../core/network/api_client.dart';
import '../models/account_model.dart';

abstract class AccountRemoteDataSource {
  Future<AccountResponse> getAccount();
  Future<void> updateAccount(UpdateAccountRequest request);
  Future<void> deleteAccount();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiClient apiClient;
  AccountRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<AccountResponse> getAccount() async {
    try {
      final response = await apiClient.get('/api/account/', requiresAuth: true);
      return AccountResponse.fromJson(response);
    } on ApiException catch (e) {
      // Handle API exception
      print("Error fetching account: ${e.message}");
      throw ServerFailure("server error", e.statusCode);
    }
  }

  @override
  Future<void> updateAccount(UpdateAccountRequest request) async {
    try {
      await apiClient.put(
        '/api/account/',
        request.toJson(),
        requiresAuth: true,
      );
    } on ApiException catch (e) {
      // Handle API exception
      print("Error updating account: ${e.message}");
      throw ServerFailure("server error", e.statusCode);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await apiClient.delete('/api/account/', requiresAuth: true);
    } on ApiException catch (e) {
      // Handle API exception
      print("Error deleting account: ${e.message}");
      throw ServerFailure("server error", e.statusCode);
    }
  }
}
