import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

import '../../../../shared/style/color.dart';


class CreateNewpass extends StatefulWidget
{
  const CreateNewpass({super.key});

  @override
  State<CreateNewpass> createState() => _CreateNewpass();
}

class _CreateNewpass extends State<CreateNewpass>
{
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Password validation flags
  bool _has8to32Chars = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState()
  {
    super.initState();
    _passwordController.addListener(()
    {
      _validatePassword();
      if (_passwordController.text.isEmpty)
      {
        _confirmPasswordController.clear();
        setState(()
        {
        }
        );
      }
    }
    );
    _confirmPasswordController.addListener(()
    {
      setState(()
      {
      }
      );
    }
    );
  }

  @override
  void dispose()
  {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword()
  {
    final password = _passwordController.text;
    setState(()
    {
      _has8to32Chars = password.length >= 8 && password.length <= 32;
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    }
    );
  }

  @override
  Widget build(BuildContext context)
  {
    final isPasswordValid = _has8to32Chars && _hasNumber && _hasSpecialChar;
    final doPasswordsMatch =
        _passwordController.text == _confirmPasswordController.text &&
            _passwordController.text.isNotEmpty;
    Size size = MediaQuery.of(context).size;
    TextTheme font = TextTheme.of(context);

    return BlocConsumer<HrMoiCubit, HrMoiStates>(
        listener: (context, state)
        {
        },
        builder: (context, state)
        {
          HrMoiCubit cubit = HrMoiCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                body: Form(
                    child: Container(
                        width: size.width,
                        height: size.height,

                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: backGrColor
                            )

                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                            child: SingleChildScrollView(
                                child: SafeArea(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Text('إنشاء كلمة المرور', style: font.bodyLarge),
                                          Column(

                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 30.0),
                                                defaultTextField(context: context,
                                                    lable: 'كلمة المرور',
                                                    controller: _passwordController,
                                                    obscureText: !_isPasswordVisible,
                                                    onSuffixIconPressed: ()
                                                    {
                                                      setState(()
                                                      {
                                                        _isPasswordVisible = !_isPasswordVisible;
                                                      }
                                                      );
                                                    },
                                                    suffixIcon: _isPasswordVisible ? Icons.visibility_off : Icons.visibility
                                                ),
                                                if (isPasswordValid) ...[

                                                  const SizedBox(height: 16),
                                                  defaultTextField(lable: 'تأكيد كلمة المرور', context: context,
                                                      controller: _confirmPasswordController,
                                                      obscureText: !_isConfirmPasswordVisible,
                                                      suffixIcon: _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,

                                                      onSuffixIconPressed: ()
                                                      {
                                                        setState(()
                                                        {
                                                          _isConfirmPasswordVisible =
                                                          !_isConfirmPasswordVisible;
                                                        }
                                                        );
                                                      }
                                                  )

                                                ],
                                                if (_passwordController.text.isNotEmpty)...[
                                                  const SizedBox(height: 50),
                                                  Text(
                                                      'قوة كلمة المرور: ${isPasswordValid ? "كلمة مرور قوية" : "ضعيفة جدا"}'
                                                      , style: font.bodySmall!.copyWith(color: isPasswordValid ? Colors.green : Colors.red)),
                                                  const SizedBox(height: 10),
                                                  LinearProgressIndicator(
                                                      value: (isPasswordValid
                                                          ? 1.0
                                                          : (_has8to32Chars ? 0.33 : 0) +
                                                          (_hasNumber ? 0.33 : 0) +
                                                          (_hasSpecialChar ? 0.33 : 0)),
                                                      backgroundColor: Colors.grey[300],
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                          isPasswordValid ? Colors.green : Colors.red
                                                      )
                                                  ),
                                                  const SizedBox(height: 50.0),
                                                  Text('يجب ان تحتوي كلمة المرور على:', style: font.bodySmall),
                                                  const SizedBox(height: 8),
                                                  _buildRequirementRow('8-32 حرف', _has8to32Chars, font.bodySmall!),
                                                  const SizedBox(height: 8),
                                                  _buildRequirementRow('رقم واحد', _hasNumber, font.bodySmall!),
                                                  const SizedBox(height: 8),
                                                  _buildRequirementRow(
                                                      'رمز خاص واحد مثال: !@#\$%',
                                                      _hasSpecialChar
                                                      , font.bodySmall!)]
                                              ]
                                          )
                                        ]
                                    )
                                )
                            )
                        )
                    )
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
                        onPressed: isPasswordValid && doPasswordsMatch
                            ? ()
                        {
                          cubit.createNewPass(
                              url: '$baseUrl$createNewPass',
                              otp: '123456',
                              empCode: hrNum.toString(),
                              password: _passwordController.text.toString(),
                              context: context
                          );
                        }
                            : null,
                        lable: 'متابعة'
                    )
                )
            ),
          );
        }
    );
  }

  Widget _buildRequirementRow(String text, bool met, TextStyle font)
  {
    return Row(
        children: [
          Icon(
              met ? Icons.check_circle : Icons.cancel,
              color: met ? Colors.green : Colors.red
          ),
          const SizedBox(width: 5),
          Text(text, style: font.copyWith(color: met ? Colors.green : Colors.red))
        ]
    );
  }
}
