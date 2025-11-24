import 'package:flutter/material.dart';
ThemeData lightTheme = ThemeData(
  //configure text in all app
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20.0, fontFamily: 'Cairo Medium',color:Colors.white),
    bodyMedium: TextStyle(fontSize: 18.0, fontFamily: 'Cairo Regular',color:Colors.white),
    bodySmall: TextStyle(fontSize: 12.0, fontFamily: 'Cairo Regular',color:Colors.white),
    titleSmall: TextStyle(fontSize: 10.0, fontFamily: 'Cairo Regular',color:Colors.white),
    labelLarge: TextStyle(fontSize: 25.0, fontFamily: 'Cairo SemiBold',color:Colors.white),
    labelMedium: TextStyle(fontSize: 20.0, fontFamily: 'Cairo SemiBold',color:Colors.white),
    labelSmall: TextStyle(fontSize: 18.0, fontFamily: 'Cairo SemiBold',color:Colors.white),
  ),
    //configure text form field style
    inputDecorationTheme: InputDecorationTheme(
      // Define the default border for all states
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      // Define the border when the TextField is enabled but not focused
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),

),);
