// biometric_service.dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

 static Future<bool> canAuthenticate() async {
    return await _auth.canCheckBiometrics ||
        await _auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    return await _auth.authenticate(
      localizedReason: 'Authenticate to continue',
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
  }
}
