import 'package:flutter/material.dart';

import '../../shared/components/constants.dart';

class PushNotification extends StatelessWidget {

  const PushNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('PUSH NOTIFICATION'),
        ),
        body: Container(child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(controller:TextEditingController(text: token),maxLines: 8,),
        )),),
      ),
    );
  }
}
