import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = TextTheme.of(context);

    TextEditingController controller = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
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
                      Text('مرحبا بعودتك', style: textTheme.bodyLarge),
                      Text(
                        'أدخل رقمك الإحصائي وكلمة المرور لتسجيل الدخول',
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                        key: formKey,
                        child: defaultTextField(
                          lable: 'الرقم الاحصائي',
                          context: context,
                          controller: controller,
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى ادخال الرقم الاحصائي';
                            }

                            final reg = RegExp(r'^[1-9]\d{0,11}$');
                            if (!reg.hasMatch(value)) {
                              return 'الرقم الاحصائي غير صالح';
                            }
                            return null;
                          },
                        ),
                      ),
                      defaultTextField(
                        lable: 'كلمة المرور',
                        context: context,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 40.0),
          child: defaultButton(
            context: context,
            onPressed: () {
              if (formKey.currentState!.validate()) {}
            },
            lable: 'تسجيل الدخول',
          ),
        ),
      ),
    );
  }
}
