import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/modules/auth/registeration/hr_number.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/style/color.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController empCode = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = TextTheme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<HrMoiCubit, HrMoiStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = HrMoiCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
             gradient: LinearGradient(colors: backGrColor,
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
             )
              ),
              width: size.width,
              height: size.height,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        spacing: 20.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/moi.png'),
                          Text('مرحبا بعودتك', style: textTheme.labelLarge),
                          Text(
                            'أدخل رقمك الإحصائي وكلمة المرور لتسجيل الدخول',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5.0),
                          defaultTextField(
                            lable: 'الرقم الاحصائي',
                            context: context,
                            controller: empCode,
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
                
                          defaultTextField(
                            controller: password,
                            obscureText: _isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى ادخال كلمة المرور';
                              }
                              return null;
                            },
                            lable: 'كلمة المرور',
                            context: context,
                            suffixIcon: _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixIconPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          //login button
                          defaultButton(
                            context: context,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.loginData(
                                  url: '$baseUrl$loginUrl',
                                  empCode: empCode.text.toString(),
                                  password: password.text.toString(),
                                  context: context,
                                );
                              }
                            },
                            lable: 'تسجيل الدخول',
                          ),

                          //===============================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Navigate to forgot password screen
                                },
                                child: Text(
                                  'هل نسيت كلمة المرور؟',
                                  style: textTheme.bodySmall!.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: mainColor,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'ليس لديك حساب؟',
                                style: textTheme.bodySmall,
                              ),
                              SizedBox(width: 5.0),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HrNumber(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'انشاء حساب جديد!',
                                  style: textTheme.bodySmall!.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: mainColor,
                                    color: mainColor,
                                  ),
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

          );
        },
      ),
    );
  }
}
