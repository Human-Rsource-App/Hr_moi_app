import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_moi/shared/style/color.dart';
import '../../../generated/assets.dart';
import '../../../shared/components/components.dart';
import 'package:hr_moi/modules/auth/auth_service.dart';
import 'package:hr_moi/modules/home_screen/home_screen.dart';

class BiometricActivationScreen extends StatelessWidget {
  final String empCode;
  final String password;

  const BiometricActivationScreen({
    super.key,
    required this.empCode,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    void navigateToHome() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }

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
                        SizedBox(height: size.height * 0.1),
                        Image.asset(Assets.iconsBiometric, width: 200.0, height: 200.0),
                        const SizedBox(height: 24),
                        Text(
                          'تفعيل المعرفات الحيوية',
                          style: textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'مع المعرفات الحيوية، لن تحتاج إلى إدخال كلمة المرور في كل مرة. هذا يساعد على جعل التطبيق أكثر أماناً',
                          style: textTheme.bodyMedium!.copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: defaultButton(
                        context: context,
                        lable: 'تفعيل',
                        onPressed: () async {
                          try {
                            await AuthService.saveCredentials(
                              empCode: empCode,
                              password: password,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم تفعيل المعرفات الحيوية بنجاح')),
                              );
                              navigateToHome();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('فشل تفعيل المعرفات الحيوية'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: defaultButton(
                        context: context,
                        onPressed: navigateToHome, // Simply navigate without enrolling
                        lable: 'لاحقاً',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
