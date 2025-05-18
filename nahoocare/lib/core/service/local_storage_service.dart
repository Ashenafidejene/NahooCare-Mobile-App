import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  Future<void> saveToken(String token);
  Future<void> saveFullName(String name);
  Future<String?> getFullName();
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveValue(String key, String value);
  Future<String?> getValue(String key);
  Future<void> clearValue(String key);
}

class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences sharedPreferences;

  LocalStorageServiceImpl(this.sharedPreferences);

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('auth_token', token);
  }

  Future<void> saveFullName(String name) async {
    await sharedPreferences.setString('full_name', name);
  }

  Future<String?> getFullName() async {
    return sharedPreferences.getString('full_name');
  }

  Future<String?> getToken() async {
    return sharedPreferences.getString('auth_token');
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove('auth_token');
  }

  @override
  Future<void> saveValue(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getValue(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> clearValue(String key) async {
    await sharedPreferences.remove(key);
  }
}
