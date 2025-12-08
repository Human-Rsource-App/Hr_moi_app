import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

import '../../../../shared/style/color.dart';

class ResetPass extends StatelessWidget
{
  const ResetPass({super.key});

  @override
  Widget build(BuildContext context)
  {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();

    return BlocConsumer<HrMoiCubit, HrMoiStates>(
        listener: (BuildContext context, HrMoiStates state)
        {
        },
        builder: (BuildContext context, HrMoiStates state)
        {
          final Size size = MediaQuery.of(context).size;
          HrMoiCubit cubit = HrMoiCubit.get(context);
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                  resizeToAvoidBottomInset: true,

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
                                                //u should to edit this align
                                                Align(
                                                    alignment: AlignmentGeometry.topRight,
                                                    child: IconButton(
                                                        icon: const Icon(
                                                            Icons.arrow_back_ios_new_rounded,
                                                            color: Colors.white,
                                                            size: 20
                                                        ),
                                                        onPressed: ()
                                                        {
                                                          Navigator.pop(context);
                                                        }
                                                    )
                                                ),

                                                Text(
                                                    'تغير كلمة المرور',
                                                    style: TextTheme.of(context).labelLarge
                                                ),
                                                Text(
                                                    'أدخل الرقم الإحصائي للبدء',
                                                    style: TextTheme.of(
                                                        context
                                                    ).bodySmall!.copyWith(color: Colors.grey)
                                                ),
                                                SizedBox(height: 20),
                                                defaultTextField(
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
                                                    },
                                                    onChanged: (String val)
                                                    {
                                                    },
                                                    lable: 'الرقم الاحصائي',
                                                    context: context,
                                                    controller: controller
                                                ),
                                                const SizedBox(
                                                    height: 50.0
                                                ),
                                                defaultButton(
                                                    context: context,
                                                    onPressed: ()
                                                    {
                                                      if (formKey.currentState!.validate())
                                                      {
                                                        cubit.getEmpCode(
                                                            url: '$baseUrl$hrUrl${controller.text.toString()}',
                                                            context: context,
                                                            empCode: controller.text.toString()
                                                        );
                                                      }
                                                    },
                                                    lable: 'متابعة'
                                                )

                                              ]
                                          )
                                      )
                                  )
                              )
                          )
                      )
                  )
              )
          );
        }
    );
  }
}
