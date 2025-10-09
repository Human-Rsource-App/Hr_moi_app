import 'package:flutter/material.dart';
import 'package:hr_moi/modules/auth/registeration/nfc.dart';
import 'package:hr_moi/shared/style/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HR MOI APP',
      theme: lightTheme,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: NfcReaderScreen(),
      ),
    );
  }
}
