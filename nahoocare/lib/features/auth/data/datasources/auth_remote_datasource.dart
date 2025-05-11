abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String phoneNumber, String password);
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String secretQuestion,
    required String secretAnswer,
  });
  Future<String> getSecretQuestion(String phoneNumber);
  Future<Map<String, dynamic>> resetPassword({
    required String phoneNumber,
    required String secretAnswer,
    required String newPassword,
  });
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
}
