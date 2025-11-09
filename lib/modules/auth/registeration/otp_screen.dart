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
        var cubit = HrMoiCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: backgColor,
            body: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'التحقق من رقم الهاتف',
                        textAlign: TextAlign.center,
                        style: TextTheme.of(context).labelLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 8,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "أدخل الرمز المرسل إلى: ",
                          children: [
                            TextSpan(
                              text: widget.phoneNumber,
                              style: TextTheme.of(context).labelSmall,
                            ),
                          ],
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 30,
                        ),
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
                        const Text(
                          "لم تستلم الرمز؟ ",
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () => showMessage(
                            message: 'تم أعادة الأرسال',
                            context: context,
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            "اعادة ارسال!",
                            style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                bottom: 40,
              ),
              child: defaultButton(
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
                lable: 'تحقق',
              ),
            ),
          ),
        );
      },
    );
  }
}
