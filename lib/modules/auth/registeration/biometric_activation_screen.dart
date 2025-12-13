import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_moi/shared/network/local/cache_helper.dart';
import 'package:hr_moi/shared/style/color.dart';
import '../../../generated/assets.dart';
import '../../../shared/components/components.dart';
import 'package:hr_moi/modules/auth/auth_service.dart';
import 'package:hr_moi/modules/home_screen/home_screen.dart';

import 'package:hr_moi/modules/auth/login/login.dart';

class BiometricActivationScreen extends StatefulWidget {
  const BiometricActivationScreen({super.key});
  @override
  State<BiometricActivationScreen> createState() =>
      _BiometricActivationScreenState();
}

class _BiometricActivationScreenState extends State<BiometricActivationScreen> {
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
                          Assets.iconsBiometric,
                          width: 200.0,
                          height: 200.0,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'تفعيل المعرفات الحيوية',
                          style: textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'مع المعرفات الحيوية، لن تحتاج إلى إدخال كلمة المرور في كل مرة. هذا يساعد على جعل التطبيق أكثر أماناً',
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
                Row(
                  children: [
                    Expanded(
                      child: defaultButton(
                        context: context,
                        lable: 'تفعيل',
                        onPressed: () async {
                          bool authenticated = await AuthService.authenticate();
                          if (authenticated) {
                            await CacheHelper.saveData(
                              key: 'biometric_enabled',
                              value: true,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تم تفعيل المعرفات الحيوية بنجاح',
                                ),
                              ),
                            );
                            await Future.delayed(const Duration(seconds: 1));
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    // const HomeScreen(),
                                    const Login(),
                              ),
                              (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إلغاء عملية التفعيل'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: defaultButton(
                        context: context,
                        onPressed: () async {
                          await CacheHelper.saveData(
                            key: 'biometric_enabled',
                            value: false,
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  // const HomeScreen(),
                                  const Login(),
                            ),
                            (route) => false,
                          );
                        },
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
