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
  bool obscureText = false,
  IconData? suffixIcon,
  VoidCallback? onSuffixIconPressed, //here modification
}) => TextFormField(
  controller: controller,
  validator: validator,
  onChanged: onChanged,
  obscureText: obscureText,
  keyboardType: keyboardType,

  decoration: InputDecoration(

    suffixIcon: IconButton(
      onPressed: onSuffixIconPressed,
      icon: Icon(suffixIcon),
    ),
    label: Text(lable, style: TextTheme.of(context).bodySmall),
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

//default snack bar message
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage({
  required String message,
  required BuildContext context,
  Color? backgroundColor,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor ?? Colors.red,
    ),
  );
}

//default pin code text field

Widget pinCodeField({
  required BuildContext appContext,
  String? Function(String?)? validator,
  StreamController<ErrorAnimationType>? errorAnimationController,
  TextEditingController? controller,
  void Function(String)? onCompleted,
  void Function(String)? onChanged,
  bool Function(String?)? beforeTextPaste,
}) => pinCodeTextField(
  appContext: appContext,

  validator: validator,
  errorAnimationController: errorAnimationController,
  controller: controller,
  onCompleted: onCompleted,
  onChanged: onChanged,
  beforeTextPaste: beforeTextPaste,
);

//default elevated button
Widget defaultElevatBtn({
  required BuildContext context,
  required void Function()? onPressed,
  required String label,
}) => ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: btnColor,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
  ),
  onPressed: onPressed,
  child: Text(label, style: TextTheme.of(context).labelMedium),
);

// Password requirement row widget..................................
Widget defaultPasswordTextField({
  required TextEditingController controller,
  required bool obscureText,
  required VoidCallback onSuffixIconPressed,
  required String labelText,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
      suffixIcon: IconButton(
        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: onSuffixIconPressed,
      ),
    ),
  );
}

Widget defaultArrowBack() {
  return const Icon(Icons.arrow_back_ios, color: Colors.black);
}
