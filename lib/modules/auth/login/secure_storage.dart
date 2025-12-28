// secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _bioEnabledKey = 'bio_enabled';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> enableBiometric() async {
    await _storage.write(key: _bioEnabledKey, value: 'true');
  }

  static Future<bool> isBiometricEnabled() async {
    return (await _storage.read(key: _bioEnabledKey)) == 'true';
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
