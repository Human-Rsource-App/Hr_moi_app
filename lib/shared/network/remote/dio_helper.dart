import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:flutter/services.dart';

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

  // // إعداد شهادة الـ CA لضمان HTTPS موثوق
  // static Future<void> initSecurity() async {
  //   // تحميل الشهادة من الـ assets
  //   ByteData data = await rootBundle.load('assets/ca/root_ca.pem');
  //   SecurityContext context = SecurityContext.defaultContext;
  //   context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  //
  //   dio?.httpClientAdapter = IOHttpClientAdapter(
  //     createHttpClient: () {
  //       final client = HttpClient(context: context);
  //       // منع الاتصال بأي سيرفر غير موثوق من الـ CA الخاص بك
  //       client.badCertificateCallback = (cert, host, port) => false;
  //       return client;
  //     },
  //   );
  // }



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
