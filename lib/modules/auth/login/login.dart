import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/modules/auth/login/biometric_service.dart';
import 'package:hr_moi/modules/auth/login/secure_storage.dart';
import 'package:hr_moi/modules/auth/registeration/hr_number.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/style/color.dart';
import '../../../generated/assets.dart';
import '../../home_screen/home_screen.dart';
import '../registeration/reset_pass/reset_pass.dart';

class Login extends StatefulWidget
{
    const Login({super.key});

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>
{
    bool _isPasswordVisible = true;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController empCode = TextEditingController();
    TextEditingController password = TextEditingController();
    TextDirection _textDirection = TextDirection.ltr;

    bool _isArabic(String text)
    {
        final arabicRegex = RegExp(r'[\u0600-\u06FF]');
        return arabicRegex.hasMatch(text);
    }
    @override
    void dispose()
    {
        empCode.dispose();
        password.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        final Size size = MediaQuery.of(context).size;
        final TextTheme textTheme = Theme.of(context).textTheme;

        return Directionality(
            textDirection: TextDirection.rtl,
            child: BlocConsumer<HrMoiCubit, HrMoiStates>(
                listener: (BuildContext context, HrMoiStates state)async
                {
                    if (state is LoginSuccState)
                    {
                        // save token here if not already saved
                        await SecureStorage.saveToken('state.token');

                        final  canBio = await BiometricService.canAuthenticate();

                        if (canBio)
                        {
                          if (context.mounted){
                            final enable = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('تفعيل تسجيل الدخول بالبصمة؟'),
                                content: const Text('هل ترغب باستخدام Face ID / Fingerprint لاحقاً؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(false),
                                    child: const Text('لا'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(true),
                                    child: const Text('نعم'),
                                  ),
                                ],
                              ),
                            );


                            if (enable == true)
                            {
                                await SecureStorage.enableBio();
                            }
                        }}
                    }
                },
                builder: (context, state)
                {
                    void navigateToHome()
                    {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                        );
                    }
                    final cubit = HrMoiCubit.get(context);
                    return Scaffold(
                        body: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: backGrColor,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter
                                )
                            ),
                            width: size.width,
                            height: size.height,
                            child: SafeArea(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                    ),
                                    child: SingleChildScrollView(

                                        child: Form(
                                            key: formKey,
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                    Image.asset(Assets.iconsMainLogo, fit: BoxFit.contain, width: 150.0, height: 150.0),
                                                    Text('مرحباً', style: textTheme.labelLarge),
                                                    Text(
                                                        'أدخل الرقم الإحصائي وكلمة المرور لتسجيل الدخول',
                                                        style: textTheme.bodySmall
                                                    ),
                                                    const SizedBox(height: 10.0),
                                                    defaultTextField(
                                                        lable: 'الرقم الاحصائي',
                                                        context: context,
                                                        controller: empCode,
                                                        keyboardType: TextInputType.number,
                                                        validator: (value)
                                                        {
                                                            if (value == null || value.isEmpty)
                                                            {
                                                                return 'يرجى ادخال الرقم الاحصائي';
                                                            }

                                                            final RegExp reg = RegExp(r'^[1-9]\d{0,11}$');
                                                            if (!reg.hasMatch(value))
                                                            {
                                                                return 'الرقم الاحصائي غير صالح';
                                                            }
                                                            return null;
                                                        }
                                                    ),
                                                    const SizedBox(height: 10),
                                                    defaultTextField(
                                                        controller: password,
                                                        obscureText: _isPasswordVisible,
                                                        keyboardType: TextInputType.visiblePassword,
                                                        textDirection: _textDirection,
                                                        textAlign: TextAlign.center,
                                                        onChanged: (String val)
                                                        {
                                                            setState(()
                                                                {
                                                                    _textDirection =
                                                                    _isArabic(val) ? TextDirection.rtl : TextDirection.ltr;
                                                                }
                                                            );
                                                        },
                                                        validator: (value)
                                                        {
                                                            if (value == null || value.isEmpty)
                                                            {
                                                                return 'يرجى ادخال كلمة المرور';
                                                            }
                                                            return null;
                                                        },
                                                        lable: 'كلمة المرور',
                                                        context: context,

                                                        suffixIcon: _isPasswordVisible
                                                            ? Icons.visibility_off
                                                            : Icons.visibility,
                                                        onSuffixIconPressed: ()
                                                        {
                                                            setState(()
                                                                {
                                                                    _isPasswordVisible = !_isPasswordVisible;
                                                                }
                                                            );
                                                        }
                                                    ),
                                                    const SizedBox(height: 20.0),
                                                    //login button
                                                    if (state is LoginLoadingState)
                                                    const CircularProgressIndicator()
                                                    else
                                                    defaultButton(
                                                        context: context,
                                                        onPressed: ()
                                                        {
                                                            if (formKey.currentState!.validate())
                                                            {
                                                                cubit.loginData(
                                                                    url: '$baseUrl$loginUrl',
                                                                    empCode: empCode.text.toString(),
                                                                    password: password.text.toString(),
                                                                    context: context
                                                                );
                                                            }
                                                        },
                                                        lable: 'تسجيل الدخول'
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
                                                                style: Theme.of(context).textTheme.bodySmall
                                                            ),
                                                            GestureDetector(
                                                                onTap: () async
                                                                {
                                                                    final token = await SecureStorage.getToken();
                                                                    final bioEnabled = await SecureStorage.isBioEnabled();

                                                                    if (token == null || !bioEnabled)
                                                                    {
                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                            const SnackBar(content: Text('لم يتم تفعيل الدخول بالبصمة سجل دخولك اولا ثم فعل البصمة لاحقا')),
                                                                        );
                                                                        return;
                                                                    }

                                                                    final success = await BiometricService.authenticate();

                                                                    if (success)
                                                                    {
                                                                      navigateToHome();
                                                                    }
                                                                },
                                                                child: Image.asset(
                                                                    Assets.iconsFaceId,
                                                                    width: 100.0,
                                                                    height: 100.0
                                                                )
                                                            ),
                                                            //===============================================================
                                                            //forget pass
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                    defaultTextBtn(
                                                                        label: 'هل نسيت كلمة المرور؟',
                                                                        onPressed: ()
                                                                        {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ResetPass()
                                                                                )
                                                                            );
                                                                        },
                                                                        textTheme: textTheme
                                                                    )
                                                                ]
                                                            ),
                                                            //=================================================
                                                            //u do not have an account
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                    Text(
                                                                        'ليس لديك حساب؟',
                                                                        style: textTheme.bodySmall
                                                                    ),
                                                                    defaultTextBtn(
                                                                        label: 'انشاء حساب جديد!',
                                                                        onPressed: ()
                                                                        {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => HrNumber()
                                                                                )
                                                                            );
                                                                        },
                                                                        textTheme: textTheme
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    );
                }
            )
        );
    }
}
