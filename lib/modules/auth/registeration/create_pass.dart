import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/modules/auth/registeration/registration_success.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Password validation flags
  bool _has8to32Chars = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _has8to32Chars = password.length >= 8 && password.length <= 32;
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordValid = _has8to32Chars && _hasNumber && _hasSpecialChar;
    final doPasswordsMatch =
        _passwordController.text == _confirmPasswordController.text &&
        _passwordController.text.isNotEmpty;

    return BlocConsumer<HrMoiCubit, HrMoiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HrMoiCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('انشاء كلمة المرور'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: defaultArrowBack(),
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          defaultPasswordTextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            onSuffixIconPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            labelText: 'ادخل كلمة المرور',
                          ),

                          if (isPasswordValid) ...[
                            const SizedBox(height: 16),
                            defaultPasswordTextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              onSuffixIconPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              labelText: 'تأكيد كلمة المرور',
                            ),
                          ],
                          const SizedBox(height: 10),
                          Text(
                            'قوة كلمة المرور: ${isPasswordValid ? "كلمة مرور قوية" : "ضعيفة جدا"}',
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (isPasswordValid
                                ? 1.0
                                : (_has8to32Chars ? 0.33 : 0) +
                                      (_hasNumber ? 0.33 : 0) +
                                      (_hasSpecialChar ? 0.33 : 0)),
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isPasswordValid ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('يجب ان تحتوي كلمة المرور على:'),
                          const SizedBox(height: 8),
                          _buildRequirementRow('8-32 حرف', _has8to32Chars),
                          const SizedBox(height: 8),
                          _buildRequirementRow('رقم واحد', _hasNumber),
                          const SizedBox(height: 8),
                          _buildRequirementRow(
                            'رمز خاص واحد مثال: !@#\$%',
                            _hasSpecialChar,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              bottom: 40.0,
            ),
            child: defaultButton(
              context: context,
              onPressed: isPasswordValid && doPasswordsMatch
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegistrationSuccessScreen(),
                        ),
                      );
                    }
                  : null,
              lable: 'استمرار',
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequirementRow(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel,
          color: met ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: met ? Colors.green : Colors.red)),
      ],
    );
  }
}
