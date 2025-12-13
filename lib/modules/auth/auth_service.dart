import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'يرجى المصادقة لتسجيل الدخول',
        persistAcrossBackgrounding: true,
        // options: const AuthenticationOptions(
        //   stickyAuth: true,
        //   biometricOnly: true,
          // useErrorDialogs: true,
        // ),
      );
    } on PlatformException catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
