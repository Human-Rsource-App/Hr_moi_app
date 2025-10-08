import 'package:flutter/material.dart';
import 'package:hr_moi/shared/style/color.dart';

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
