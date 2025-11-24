import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/modules/splash_screen/splash.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/network/local/cache_helper.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';
import 'package:hr_moi/shared/style/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  CacheHelper.init();
  cameras = await availableCameras();
  runApp(MyApp(camera: cameras!.last));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({required this.camera, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HrMoiCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HR MOI APP',
        themeMode: ThemeMode.dark,
        theme: lightTheme,
        home: MoiView(),
      ),
    );
  }
}
