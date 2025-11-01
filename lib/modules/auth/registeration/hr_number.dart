import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

class HrNumber extends StatelessWidget {
  const HrNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();

    return BlocConsumer<HrMoiCubit, HrMoiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HrMoiCubit.get(context);
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
                      Text(
                        'ادخل التفاصيل',
                        style: TextTheme.of(context).bodySmall,
                      ),
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
                          final url = Uri.encodeFull(hrUrl + controller.text);
                          if (formKey.currentState!.validate()) {
                            cubit.getHrNumber(
                              url: url,
                              hrFromTextField: controller.text,
                              context: context,
                            );
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
      },
    );
  }
}
