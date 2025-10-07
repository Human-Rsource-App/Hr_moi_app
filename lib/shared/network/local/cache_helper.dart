import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static Future<SharedPreferences> init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }
}
