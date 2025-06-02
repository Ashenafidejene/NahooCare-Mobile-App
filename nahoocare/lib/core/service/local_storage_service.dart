import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  Future<void> saveToken(String token);
  Future<void> saveFullName(String name);
  Future<void> profileSave(String photo);
  Future<String?> getProfile();
  Future<String?> getFullName();
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveValue(String key, String value);
  Future<String?> getValue(String key);
  Future<void> clearValue(String key);
}

class LocalStorageServiceImpl implements LocalStorageService {
  final SharedPreferences _sharedPreferences;

  LocalStorageServiceImpl(this._sharedPreferences);

  /// Factory constructor to initialize with SharedPreferences
  static Future<LocalStorageServiceImpl> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageServiceImpl(prefs);
  }

  @override
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString('auth_token', token);
  }

  @override
  Future<void> saveFullName(String name) async {
    await _sharedPreferences.setString('full_name', name);
  }

  @override
  Future<String?> getFullName() async {
    return _sharedPreferences.getString('full_name');
  }

  @override
  Future<String?> getToken() async {
    return _sharedPreferences.getString('auth_token');
  }

  @override
  Future<void> clearToken() async {
    await _sharedPreferences.remove('auth_token');
  }

  @override
  Future<void> saveValue(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getValue(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> clearValue(String key) async {
    await _sharedPreferences.remove(key);
  }

  @override
  Future<void> profileSave(String photo) async {
    await _sharedPreferences.setString("photoUrl", photo);
  }

  @override
  Future<String?> getProfile() async {
    return _sharedPreferences.getString('photoUrl');
  }
}
