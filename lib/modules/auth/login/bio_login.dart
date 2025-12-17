import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _secureStorage = FlutterSecureStorage();
  static const _empCodeKey = 'emp_code_key';
  static const _passwordKey = 'password_key';

  // Use a dedicated biometric storage file just to trigger the prompt
  static const _biometricStorageFile = 'hr_moi_biometric_trigger';

  /// Securely stores user credentials for biometric login.
  static Future<void> saveCredentials({
    required String empCode,
    required String password,
  }) async {
    try {

      await _secureStorage.write(key: _empCodeKey, value: empCode);
      await _secureStorage.write(key: _passwordKey, value: password);
     // print(_secureStorage);
      // Also write to the biometric storage to ensure it exists for the read prompt.
      final storage = await BiometricStorage().getStorage(_biometricStorageFile);
      await storage.write('credentials_saved');
    } catch (e) {
     // print("Error saving credentials: $e");
    }
  }

  /// Retrieves credentials after a successful biometric prompt.
  static Future<Map<String, String>?> getCredentials() async {
    try {
      // This read action triggers the biometric prompt.
      final storage = await BiometricStorage().getStorage(_biometricStorageFile);
      final bioData = await storage.read();

      if (bioData != null) {
        // Biometric authentication was successful, now retrieve credentials.
        final empCode = await _secureStorage.read(key: _empCodeKey);
        final password = await _secureStorage.read(key: _passwordKey);

        if (empCode != null && password != null) {
          return {'empCode': empCode, 'password': password};
        }
      }
      return null; // Biometric auth failed or no credentials stored.
    } catch (e) {
     // print("Error getting credentials: $e");
      return null;
    }
  }

  /// Checks if credentials have been saved.
  static Future<bool> hasCredentials() async {
    try {
      final empCode = await _secureStorage.read(key: _empCodeKey);
      return empCode != null;
    } catch (e) {
      //print("Error checking for credentials: $e");
      return false;
    }
  }
}