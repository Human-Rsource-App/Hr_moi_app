import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

import '../../../generated/assets.dart';
import '../../../shared/style/color.dart';
import '../../home_screen/home_screen.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: backGrColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                        ), // Adjust spacing from top
                        Image.asset(
                          Assets.iconRegisterSuccess,
                          width: 200.0,
                          height: 200.0,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'تم التسجيل بنجاح!',
                          style: textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'تهانينا، لقد قمت بالتسجيل بنجاح في تطبيق الموارد البشرية',
                          style: textTheme.bodyMedium!.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                defaultButton(
                  context: context,
                  lable: 'الانتقال إلى لوحة التحكم',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
