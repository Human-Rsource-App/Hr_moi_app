import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_moi/shared/components/components.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          defaultButton(context: context, onPressed: (){}, lable: 'تسجيل الخروج')
        ],
      ),
    );
  }
}
