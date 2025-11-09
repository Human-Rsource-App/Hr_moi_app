import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = TextTheme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/moi.png'),
                    const SizedBox(height: 10.0),
                    Text(
                      'مرحبا بعودتك',
                      style: TextStyle(fontSize: size.width * 0.25),
                    ),
                    Text(
                      'أدخل رقمك الإحصائي وكلمة المرور لتسجيل الدخول',
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 20.0),
                    defaultTextField(
                      lable: 'الرقم الاحصائي',
                      context: context,
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                    defaultTextField(
                      lable: 'كلمة المرور',
                      context: context,
                      keyboardType: TextInputType.numberWithOptions(),
                      suffixIcon: Icons.remove_red_eye_outlined,
                      onPressed: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'نسيت كلمة السر ؟',
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    defaultButton(
                      context: context,
                      onPressed: () {},
                      lable: 'تسجيل الدخول',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
