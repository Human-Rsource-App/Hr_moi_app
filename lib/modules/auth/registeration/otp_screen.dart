import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/style/color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  const PinCodeVerificationScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

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

  // snackBar Widget
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    String? message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message!), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgColor,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/icons/comments.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
                        text: "9647717190002+", //${widget.phoneNumber}
                        style: TextTheme.of(context).labelSmall,
                      ),
                    ],
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
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
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "تحقق من الرقم المرسل";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                    onCompleted: (v) {
                      debugPrint("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
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
                    color: Colors.black,
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
                    onPressed: () => snackBar("تم اعادة الارسال"),
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
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: defaultButton(
                  context: context,
                  onPressed: () {
                    formKey.currentState!.validate();
                    // conditions for validating
                    if (currentText.length != 6 || currentText != "123456") {
                      errorController!.add(
                        ErrorAnimationType.shake,
                      ); // Triggering error shake animation
                      setState(() => hasError = true);
                    } else {
                      setState(() {
                        hasError = false;
                        snackBar("تم التحقق !!");
                      });
                    }
                  },
                  lable: 'تحقق',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: TextButton(
                      child: const Text("مسح "),
                      onPressed: () {
                        textEditingController.clear();
                      },
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      child: const Text("لصق"),
                      onPressed: () {
                        setState(() {
                          textEditingController.text = "123456";
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
