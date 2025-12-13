import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:hr_moi/shared/style/color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String empCode;
  const PinCodeVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.empCode,
  });

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HrMoiCubit, HrMoiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        Size size = MediaQuery.of(context).size;
        var cubit = HrMoiCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: backGrColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: size.height,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Column(
                        spacing: 10.0,
                        children: <Widget>[
                          Text(
                            'أدخل رمز التحقق',
                            textAlign: TextAlign.center,
                            style: TextTheme.of(context).labelLarge,
                          ),
                          Text(
                            'تم إرسال رمز التحقق من 6 أرقام إلى',
                            textAlign: TextAlign.center,
                            style: TextTheme.of(context).bodySmall,
                          ),
                          Text(
                            'XXXX-XX${widget.phoneNumber.substring(7)}',
                            textAlign: TextAlign.center,
                            style: TextTheme.of(context).bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: formKey,
                        child: pinCodeField(
                          appContext: context,

                          validator: (v) {
                            if (v!.length < 3) {
                              return "تحقق من الرقم المرسل";
                            } else {
                              return null;
                            }
                          },
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          onCompleted: (v) {
                            debugPrint("اكتمل");
                          },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("السماح للصق$text");
                            return true;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          hasError ? "يرجى ملء جميع الخلايا بشكل صحيح" : "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "لم تستلم الرمز ؟ ",
                            style: TextTheme.of(
                              context,
                            ).bodyMedium!.copyWith(fontSize: 14.0),
                          ),
                          TextButton(
                            onPressed: () => showMessage(
                              message: 'تم اعادة ارسال الرمز تحقق من الرسائل',
                              context: context,
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
                              "اعادة ارسال!",
                              style: TextTheme.of(context).bodyMedium!.copyWith(
                                color: secondColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      defaultButton(
                        context: context,
                        onPressed: () {
                          formKey.currentState!.validate();
                          // conditions for validating
                          if (currentText.length != 6) {
                            errorController!.add(
                              ErrorAnimationType.shake,
                            ); // Triggering error shake animation
                            setState(() => hasError = true);
                          } else {
                            setState(() {
                              hasError = false;
                              cubit.getOtp(
                                url:
                                    '$baseUrl$otpUrl${widget.empCode}/${widget.phoneNumber}',
                                currentText: currentText.toString(),
                                context: context,
                              );
                            });
                          }
                        },
                        lable: 'متابعة',
                      ),
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
