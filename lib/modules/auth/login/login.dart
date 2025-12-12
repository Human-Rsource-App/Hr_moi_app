import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/modules/auth/registeration/hr_number.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/style/color.dart';

import '../../../generated/assets.dart';
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
    @override
    Widget build(BuildContext context)
    {
        final Size size = MediaQuery.of(context).size;
        final TextTheme textTheme = TextTheme.of(context);

        return Directionality(
            textDirection: TextDirection.rtl,
            child: BlocConsumer<HrMoiCubit, HrMoiStates>(
                listener: (context, state)
                {
                },
                builder: (context, state)
                {
                    final cubit = HrMoiCubit.get(context);
                    return Scaffold(
                        body: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: backGrColor,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter
                                )
                            ),
                            width: size.width,
                            height: size.height,
                            child: SafeArea(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    child: SingleChildScrollView(
                                        child: Form(
                                            key: formKey,
                                            child: Column(
                                                spacing: 8.0,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                    Image.asset(Assets.iconsLoginLogo, fit: BoxFit.contain,width: 200.0,height: 200.0,),
                                                    Text('مرحباً', style: textTheme.labelLarge),
                                                    Text(
                                                        'أدخل الرقم الإحصائي وكلمة المرور لتسجيل الدخول',
                                                        style: textTheme.bodySmall
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    defaultTextField(
                                                        lable: 'الرقم الاحصائي',
                                                        context: context,
                                                        controller: empCode,
                                                        keyboardType: TextInputType.numberWithOptions(),
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

                                                    defaultTextField(
                                                        controller: password,
                                                        obscureText: _isPasswordVisible,
                                                        keyboardType: TextInputType.visiblePassword,
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
                                                    const SizedBox(height: 5.0),
                                                    //login button
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

                                                    //===============================================
                                                    Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            //bio login
                                                            Text('او سجل الدخول من خلال بصمة الوجه', style: TextTheme.of(context).bodySmall),
                                                            Image.asset(Assets.iconsFaceId, width: 100.0, height: 100.0),
                                                            //===============================================================
                                                            //forget pass
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                    defaultTextBtn(label: 'هل نسيت كلمة المرور؟', onPressed: ()
                                                                        {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ResetPass()
                                                                                )
                                                                            );
                                                                        }, textTheme: textTheme)
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
                                                                    SizedBox(width: 5.0),
                                                                    defaultTextBtn(label: 'انشاء حساب جديد!', onPressed: ()
                                                                        {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => HrNumber()
                                                                                )
                                                                            );
                                                                        }, textTheme: textTheme)

                                                                ]
                                                            )

                                                        ])

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
