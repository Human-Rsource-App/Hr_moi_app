import 'package:flutter/material.dart';
import 'package:hr_moi/modules/auth/registeration/otp_screen.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/network/remote/dio_helper.dart';

class HrNumber extends StatelessWidget {
  const HrNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                spacing: 10.0,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text('ادخل التفاصيل', style: TextTheme.of(context).bodySmall),
                  Text(
                    'أدخل رقمك الإحصائي للبدء',
                    style: TextTheme.of(
                      context,
                    ).bodySmall!.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  defaultTextField(
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
                    onChanged: (String val) {},
                    lable: ' الرقم الإحصائي',
                    context: context,
                    controller: controller,
                  ),

                  Spacer(),
                  defaultButton(
                    context: context,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final url = Uri.encodeFull(hrUrl + controller.text);

                        DioHelper.getData(path: url)
                            .then((val) {
                              if (val.data != null) {
                                if (val.data['data']['data']['empCode'] ==
                                    controller.text) {
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PinCodeVerificationScreen(),
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'الرقم الاحصائي غير موجود تحقق منه مرة ثانية',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('لا توجد بيانات')),
                                  );
                                }
                              }
                            })
                            .catchError((err) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'خطأ في لاتصال تاكد من اتصالك بالشبكة',
                                    ),
                                  ),
                                );
                              }
                            });
                      }
                    },
                    lable: 'استمرار',
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
