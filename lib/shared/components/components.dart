import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hr_moi/shared/style/color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

//default button
Widget defaultButton({
  required BuildContext context,
  required void Function()? onPressed,
  required String lable,
}) => Container(
  width: double.infinity,
  height: 52.0,

  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
  child: MaterialButton(
    onPressed: onPressed,
    disabledColor: disabledColor,
    color: btnColor,
    child: Text(lable, style: TextTheme.of(context).labelMedium),
  ),
);

//default Text Form Field

Widget defaultTextField({
  TextEditingController? controller,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  TextInputType? keyboardType,
  required String lable,
  required BuildContext context,
}) => TextFormField(
  controller: controller,
  validator: validator,
  onChanged: onChanged,

  keyboardType: keyboardType,

  decoration: InputDecoration(
    label: Text(lable, style: TextTheme.of(context).bodySmall),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  ),
);

// icon button
Widget defaultIconButton({
  required IconData icon,
  double? iconSize,
  Color? color,
}) => IconButton(
  onPressed: () {},
  icon: Icon(icon),
  iconSize: iconSize,
  color: color ?? mainColor,
);

//OTP pin cod

Widget pinCodeTextField({
  required BuildContext appContext,
  String? Function(String?)? validator,
  StreamController<ErrorAnimationType>? errorAnimationController,
  TextEditingController? controller,
  void Function(String)? onCompleted,
  void Function(String)? onChanged,
  bool Function(String?)? beforeTextPaste,
}) => PinCodeTextField(
  errorTextSpace: 30.0,

  appContext: appContext,
  pastedTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  length: 6,
  obscureText: true,
  obscuringCharacter: '*',
  blinkWhenObscuring: true,
  animationType: AnimationType.fade,
  validator: validator,
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 50,
    fieldWidth: 40,
    activeFillColor: Colors.white,
    errorBorderColor: Colors.red,
    activeColor: mainColor,
    selectedColor: Colors.black,
    inactiveColor: Colors.grey[500],
  ),
  cursorColor: Colors.black,

  animationDuration: const Duration(milliseconds: 300),
  enableActiveFill: false,
  errorAnimationController: errorAnimationController,
  controller: controller,
  keyboardType: TextInputType.number,
  boxShadows: const [
    BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10),
  ],
  onCompleted: onCompleted,
  // onTap: () {
  //   print("Pressed");
  // },
  onChanged: onChanged,
  beforeTextPaste: beforeTextPaste,
);

//default card
Widget defaultCard({required BuildContext context, required Widget child}) =>
    Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: child,
    );

// default CircleAvatar
Widget defaultCircleAvatar({
  required double radius,
  Color? backgroundColor,
  Widget? child,
}) => CircleAvatar(
  radius: radius,
  backgroundColor: backgroundColor ?? mainColor,
  child: child,
);
