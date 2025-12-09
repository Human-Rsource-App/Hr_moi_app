import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

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
              gradient: LinearGradient(colors: backGrColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 7),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with rings
                  _buildLogo(),
                  const SizedBox(height: 24),
                  // English title
                  Text(  'تم التسجيل بنجاح!',
                      style: textTheme.bodyMedium!.copyWith(color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(  'تهانينا، لقد قمت بالتسجيل بنجاح في تطبيق الموارد البشرية',
                      style: textTheme.bodySmall!.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
          bottomNavigationBar: Container(
              padding: EdgeInsets.all(20.0),

              decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 5, color: mainColor,
                  offset: Offset(0, 0))],

                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: backGrColor
                  )
              ),
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
          )

      ),
    );

  }

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: mainColor.withOpacity(0.5),width: 7.0,style: BorderStyle.solid ),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 5,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),

              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // Placeholder for the actual logo
                    image: DecorationImage(
                      image: AssetImage('assets/icons/checked.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );

  }
}
