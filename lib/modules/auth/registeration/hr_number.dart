import 'package:flutter/material.dart';

class HrNumber extends StatelessWidget {
  const HrNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'أدخل التفاصيل',
            style: TextStyle(fontFamily: 'Amiri-Italic.ttf'),
          ),
        ],
      ),
    );
  }
}
