import 'package:dio/dio.dart';
import 'package:hr_moi/shared/components/constants.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 3),
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.get(path);
  }

  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? query,
    required Object data,
  }) async {
    return await dio!.post(path, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String path,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.delete(path, queryParameters: query);
  }

  static Future<Response> updateData({
    required String path,
    required Map<String, dynamic> query,
    required Object data,
  }) async {
    return await dio!.put(path, queryParameters: query, data: data);
  }
}
