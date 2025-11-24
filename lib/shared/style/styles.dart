import 'package:flutter/material.dart';
ThemeData lightTheme = ThemeData(
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20.0, fontFamily: 'Cairo Medium',color:Colors.white),
    bodyMedium: TextStyle(fontSize: 18.0, fontFamily: 'Cairo Regular',color:Colors.white),
    bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Cairo Regular',color:Colors.white),
    titleSmall: TextStyle(fontSize: 10.0, fontFamily: 'Cairo Regular',color:Colors.white),
    labelLarge: TextStyle(fontSize: 25.0, fontFamily: 'Cairo SemiBold',color:Colors.white),
    labelMedium: TextStyle(fontSize: 20.0, fontFamily: 'Cairo SemiBold',color:Colors.white),
    labelSmall: TextStyle(fontSize: 18.0, fontFamily: 'Cairo SemiBold',color:Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
  ),
);
