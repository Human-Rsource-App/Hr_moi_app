import 'package:flutter/material.dart';

import '../../shared/style/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
     Size size =MediaQuery.of(context).size;
    return Scaffold(
appBar: AppBar(

actions: [
  IconButton(onPressed: (){}, icon: Icon(Icons.close))
],
),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: backGrColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
            ),
            width: size.width,
            height: size.height,
            child: Center(child: Text('الواجهة الرئيسيه'))));
  }
}
