import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/modules/auth/registeration/hr_number.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/style/color.dart';
import '../../../generated/assets.dart';
import '../biometric_activation_screen.dart';
import 'bio_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController empCode = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> _authenticateWithBiometrics() async {
    final credentials = await AuthService.getCredentials();
    if (credentials != null && mounted) {
      // Use the retrieved credentials to log the user in
      HrMoiCubit.get(context).loginData(
        url: '$baseUrl$loginUrl',
        empCode: credentials['empCode']!,
        password: credentials['password']!,
        context: context,
      );
    } else if (mounted) {
      showMessage(message: 'فشل المصادقة بالبصمة', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<HrMoiCubit, HrMoiStates>(
        listener: (context, state) {
          if (state is LoginSuccState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BiometricActivationScreen(
                  empCode: empCode.text,
                  password: password.text,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = HrMoiCubit.get(context);
          return Scaffold(
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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Assets.iconsModeLogo,fit: BoxFit.contain,width: 200.0,height: 200.0),
                          Text('مرحباً', style: textTheme.labelLarge),
                          Text(
                            'أدخل الرقم الإحصائي وكلمة المرور لتسجيل الدخول',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5.0),
                          defaultTextField(
                            lable: 'الرقم الاحصائي',
                            context: context,
                            controller: empCode,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى ادخال الرقم الاحصائي';
                              }

                              final RegExp reg = RegExp(r'^[1-9]\d{0,11}$');
                              if (!reg.hasMatch(value)) {
                                return 'الرقم الاحصائي غير صالح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 20.0),
                          //login button
                          if (state is LoginLoadingState)
                            const CircularProgressIndicator()
                          else
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
                          const SizedBox(height: 20.0),
                          //===============================================
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //bio login
                              Text(
                                'أوسجل دخولك عبر',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: _authenticateWithBiometrics,
                                child: Image.asset(
                                  Assets.iconsFaceId,
                                  width: 100.0,
                                  height: 100.0,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              //===============================================================
                              //forget pass
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  defaultTextBtn(
                                    label: 'هل نسيت كلمة المرور؟',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HrNumber(),
                                        ),
                                      );
                                    },
                                    textTheme: textTheme,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              //=================================================
                              //u do not have an account
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ليس لديك حساب؟',
                                    style: textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: 5.0),
                                  defaultTextBtn(
                                    label: 'انشاء حساب جديد!',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HrNumber(),
                                        ),
                                      );
                                    },
                                    textTheme: textTheme,
                                  ),
                                ],
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