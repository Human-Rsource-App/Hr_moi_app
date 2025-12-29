import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'token';
  static const _bioKey = 'bio_enabled';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> enableBio() async {
    await _storage.write(key: _bioKey, value: 'true');
  }

  static Future<bool> isBioEnabled() async {
    return (await _storage.read(key: _bioKey)) == 'true';
  }
  static Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _bioKey);
  }
}
