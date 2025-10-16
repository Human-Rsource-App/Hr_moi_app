import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hr_moi/modules/auth/registeration/mrz_screen.dart';
import 'package:hr_moi/shared/style/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(camera: cameras.first));
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
        child: CameraScreen(camera: camera),
      ),
    );
  }
}
