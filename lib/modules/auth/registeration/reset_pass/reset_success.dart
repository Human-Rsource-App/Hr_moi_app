import 'package:flutter/material.dart';
import 'package:hr_moi/generated/assets.dart';
import 'package:hr_moi/shared/components/components.dart';

import '../../../../shared/style/color.dart';
import '../../../home_screen/home_screen.dart';

class RegistrationSuccessScreen extends StatelessWidget
{
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    TextTheme font = TextTheme.of(context);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: backGrColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Image.asset(Assets.iconsDone, width: 150.0, height: 150.0),
                          const SizedBox(height: 20),
                          Text(
                              '!تم التسجيل بنجاح', style: font.bodyMedium!.copyWith(color: Colors.lightGreen), textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 8),
                          Text(
                              'تهانينا، لقد قمت بالتسجيل بنجاح في تطبيق الموارد البشرية',
                              textAlign: TextAlign.center,
                              style: font.bodyMedium
                          ),
                          const Spacer(),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: defaultButton(
                                  context: context,
                                  lable: 'الانتقال إلى لوحة التحكم',
                                  onPressed: ()
                                  {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()
                                        )
                                    );
                                  }
                              )
                          ),
                          const SizedBox(height: 30)
                        ]
                    )
                )
            )
        )
    );
  }
}
