import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/service/local_storage_service.dart';
import 'auth_remote_datasource.dart';
import 'package:flutter/foundation.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.localStorageService,
  });

  final ApiClient apiClient;
  final LocalStorageService localStorageService;

  @override
  Future<void> cacheToken(String token) async {
    try {
      await localStorageService.saveToken(token);
    } catch (e) {
      throw CacheException('Failed to cache token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await localStorageService.clearToken();
    } catch (e) {
      throw CacheException('Failed to clear token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return await localStorageService.getToken();
    } catch (e) {
      throw CacheException('Failed to get cached token: ${e.toString()}');
    }
  }

  @override
  Future<String> getSecretQuestion(String phoneNumber) async {
    try {
      final response = await apiClient.get(
        '/api/account/getSecretQuestion/$phoneNumber',
        requiresAuth: false,
      );

      // Ensure the response contains the secret question

      return response['question'];
    } on ApiException catch (e) {
      throw ServerException(e.message, e.statusCode);
    } catch (e) {
      throw ServerException(
        'Failed to get secret question: ${e.toString()}',
        500,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      print(phoneNumber);
      final response = await apiClient.post('/api/account/login', {
        'phone_number': phoneNumber,
        'password': password,
      }, requiresAuth: false);
      await localStorageService.saveFullName(response['full_name']);
      await localStorageService.saveToken(response['access_token']);
      await localStorageService.profileSave(response['image_url']);
      final value = await localStorageService.getToken();
      debugPrint("Login successful sharedPreferences , token: $value");
      debugPrint("$value");
      return response;
    } on ApiException catch (e) {
      throw ServerException(e.message, e.statusCode);
    } catch (e) {
      throw ServerException('Failed to login: ${e.toString()}', 500);
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String secretQuestion,
    required String secretAnswer,
    required String photoUrl,
    required String dataOfBirth,
    required String gender,
  }) async {
    debugPrint("Attempting to register user: $phoneNumber");
    try {
      final response = await apiClient.post('/api/account/register', {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
        'secret_question': secretQuestion,
        'secret_answer': secretAnswer,
        'photo_url': photoUrl,
        'date_of_birth': dataOfBirth,
        'gender': gender,
      }, requiresAuth: false);

      // Validate response contains required fields
      // if (response['user_id'] == null || response['access_token'] == null) {
      //   throw ServerException('Invalid registration response format', 500);
      // }

      // await localStorageService.saveToken(response['access_token'] as String);
      // await localStorageService.saveFullName(fullName);

      // debugPrint("Registration successful for user: ${response['user_id']}");
      final x = await this.login(phoneNumber, password);
      return response;
    } on ApiException catch (e) {
      throw ServerException(e.message, e.statusCode);
    } catch (e) {
      throw ServerException('Failed to register: ${e.toString()}', 500);
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String phoneNumber,
    required String secretAnswer,
    required String newPassword,
  }) async {
    final response = await apiClient.post('/api/account/reset-password', {
      'phone_number': phoneNumber,
      'secret_answer': secretAnswer,
      'new_password': newPassword,
    }, requiresAuth: false);
    return response;
  }
}
