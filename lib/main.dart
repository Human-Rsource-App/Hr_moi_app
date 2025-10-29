import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hr_moi/modules/auth/registeration/hr_number.dart';
import 'package:hr_moi/shared/network/local/cache_helper.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';
import 'package:hr_moi/shared/style/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  CacheHelper.init();
  final cameras = await availableCameras();
  runApp(MyApp(camera: cameras.last));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({required this.camera, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HR MOI APP',
      theme: lightTheme,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child:
            HrNumber(), // FaceDetectionScreen(camera: camera,), //PinCodeVerificationScreen(), //CameraScreen(camera: camera),
      ),
    );
  }
}
