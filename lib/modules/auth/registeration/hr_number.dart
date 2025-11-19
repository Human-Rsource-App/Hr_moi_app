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
        final size = MediaQuery.of(context).size;
        var cubit = HrMoiCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: size.width,

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
                            onChanged: (String val) {},
                            lable: 'الرقم الإحصائي',
                            context: context,
                            controller: controller,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 40),
              child: defaultButton(
                context: context,
                onPressed: () {
                  final url = Uri.encodeFull(
                    baseUrl + hrUrl + controller.text.toString(),
                  );

                  if (formKey.currentState!.validate()) {
                    cubit.getEmpCode(
                      url: url,
                      context: context,
                      empCode: controller.text.toString(),
                    );
                  }
                },
                lable: 'استمرار',
              ),
            ),
          ),
        );
      },
    );
  }
}
