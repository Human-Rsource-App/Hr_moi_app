import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_moi/shared/style/color.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
//default material button
Widget defaultButton({
    required BuildContext context,
    required void Function()? onPressed,
    double width = double.infinity,
    Color? color,
    Color fontColor = Colors.black,
    required String lable
}) => Container(
    width: width,
    height: 52.0,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(colors: btnColor)

    ),
    child: MaterialButton(
        onPressed: onPressed,
        disabledColor: disabledColor,
        color: color,
        child: Text(lable, style: TextTheme.of(context).labelMedium!.copyWith(color: fontColor))
    )
);
//==============================================================================
//default elevated button
Widget defaultElevationBtn({
    required BuildContext context,
    required void Function()? onPressed,

    required String label
}) => ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: elevBtnColor,
        disabledBackgroundColor: Colors.black26,

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
    ),
    onPressed: onPressed,

    child: Text(label, style: TextTheme.of(context).bodyMedium!.copyWith(color: Colors.black))
);
//==============================================================================
//default text button
Widget defaultTextBtn({required void Function() onPressed, required String label, required dynamic textTheme}) => TextButton(
    onPressed: onPressed,
    child: Text(
        label,
        style: textTheme.bodySmall!.copyWith(
            // decoration: TextDecoration.underline,
            // decorationColor: mainColor,
            color: textBtnColor
        )
    )
);
//==============================================================================
//default Text Form Field
Widget defaultTextField({
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    required String lable,
  TextAlign textAlign = TextAlign.start,
  TextDirection? textDirection,
    required BuildContext context,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed //here modification
}) => TextFormField(
    controller: controller,
    textAlign: textAlign,
    textDirection:textDirection,
    validator: validator,
    onChanged: onChanged,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: onSuffixIconPressed,
            icon: Icon(suffixIcon, color: Colors.white)
        ),
        label: Text(lable, style: TextTheme.of(context).bodySmall)
    )
);
//==============================================================================
//OTP pin cod
Widget pinCodeTextField({
    required BuildContext appContext,
    String? Function(String?)? validator,
    StreamController<ErrorAnimationType>? errorAnimationController,
    TextEditingController? controller,
    void Function(String)? onCompleted,
    void Function(String)? onChanged,
    bool Function(String?)? beforeTextPaste
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
        selectedColor: secondColor,
        inactiveColor: Colors.grey[500]
    ),
    cursorColor: secondColor,
    animationDuration: const Duration(milliseconds: 300),
    enableActiveFill: false,
    errorAnimationController: errorAnimationController,
    controller: controller,
    keyboardType: TextInputType.number,
    boxShadows: const[
        BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10)
    ],
    onCompleted: onCompleted,
    // onTap: () {
    //   print("Pressed");
    // },
    onChanged: onChanged,
    beforeTextPaste: beforeTextPaste
);
//==============================================================================
// default CircleAvatar
Widget defaultCircleAvatar({
    required double radius,
    Color? backgroundColor,
    Widget? child
}) => CircleAvatar(
    radius: radius,
    backgroundColor: backgroundColor ?? mainColor,
    child: child
);
//==============================================================================
//default snack bar message
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage({
    required String message,
    required BuildContext context,
    Color? backgroundColor
})
{
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                message,
                style: TextTheme.of(context).bodySmall
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: backgroundColor ?? Colors.red
        )
    );
}
//==============================================================================
//default pin code text field
Widget pinCodeField({
    required BuildContext appContext,
    String? Function(String?)? validator,
    StreamController<ErrorAnimationType>? errorAnimationController,
    TextEditingController? controller,
    void Function(String)? onCompleted,
    void Function(String)? onChanged,
    bool Function(String?)? beforeTextPaste
}) => pinCodeTextField(

    appContext: appContext,
    validator: validator,
    errorAnimationController: errorAnimationController,
    controller: controller,
    onCompleted: onCompleted,
    onChanged: onChanged,
    beforeTextPaste: beforeTextPaste
);
//==============================================================================
//default Text Container
Widget textContainer({
    required String image,
    required BuildContext context,
    required String label,
    required String data
}) => Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        border: Border.all(color: secondColor),
        borderRadius: BorderRadius.circular(20.0)

    ),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.0,
        children: [
            Image.asset(image, width: 16.0, height: 16.0),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5.0,
                    children: <Widget>[
                        Text(label, style: TextTheme.of(context).bodySmall!.copyWith(color: Colors.grey)),
                        Text(data, style: TextTheme.of(context).bodySmall)
                    ]
                )
            )
        ]
    )
);
//==============================================================================
//dialog window
void showErrorDialog({required BuildContext context})
{
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: secondColor, width: 2)
                ),
                child: Container(

                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: backGrColor)

                    ),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                        onTap: () => Navigator.of(context).pop(),
                                        child: defaultCircleAvatar(
                                            backgroundColor: Colors.red,
                                            radius: 20,
                                            child: Icon(Icons.close, color: Colors.white)
                                        )
                                    )
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    'يرجى تحديث معلوماتك في نظام ال HR ومن ثم اكمال عملية التسجيل',
                                    style: TextTheme.of(context).labelSmall,
                                    textAlign: TextAlign.center
                                ),
                                const SizedBox(height: 20),
                                defaultButton(
                                    context: context,
                                    lable: 'خروج',
                                    onPressed: ()
                                    {
                                        SystemNavigator.pop();
                                    }
                                )
                            ]
                        )
                    )
                )
            );
        }
    );
}
//==============================================================================
//default container
Widget defaultContainer({
    double width = 50,
    double height = 50,
  int color= 0xffFFFFFF,
  double opacity=0.2,
  double radius=10.0,
  double vertPadding = 1,
  double horiPadding = 1,
    required Widget child
}) => Container(
    width: width,
    height: height,
    padding: EdgeInsets.symmetric(vertical: vertPadding,horizontal: horiPadding),
    decoration: BoxDecoration(
        color: Color(color).withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: Color(0xffFFFFFF).withValues(alpha: 0.4),
            width: 1.6
        )
    ),
    child: child
);
//==============================================================================
// default divider

Widget defaultDivider(
{
  double width=1,
}
    )=> Container(
  width: 1,
  margin: const EdgeInsets.symmetric(vertical: 10),
  color: Colors.white.withValues(alpha: 0.35),
);
//==============================================================================
//items for home tasks
Widget item(
    {
      required BuildContext context,
      required String title,
      required String subTitle,
      Color subColor=Colors.white,
      Color titleColor=Colors.white,
      double subTitleSize=20,
      double titleSize=12,
    })=>Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(child: Text(title, style: TextTheme.of(context).bodySmall!.copyWith(fontSize: titleSize,color: titleColor),textAlign: TextAlign.center,)),
      Flexible(child: Text(subTitle, style:TextTheme.of(context).bodyMedium!.copyWith(color: subColor,fontSize: subTitleSize)))
    ]
);
//===============================================================================