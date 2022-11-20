import 'package:flutter/material.dart';

ThemeData appLightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.purple)),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //       backgroundColor: MaterialStateProperty.all(Colors.purple),
  //       shape: MaterialStateProperty.all(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
  //       padding:
  //           MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50)),
  //       elevation: MaterialStateProperty.all(5),
  //       animationDuration: Duration(seconds: 2)),
  // ),
  primarySwatch: Colors.blue,
);

ThemeData appDarkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    headline1: TextStyle(
        fontSize: 48, color: Colors.white, fontWeight: FontWeight.w900),
    headline2: TextStyle(
        fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),
    headline3: TextStyle(fontSize: 14, color: Colors.white),
    headline4: TextStyle(fontSize: 12, color: Colors.white),
    headline5: TextStyle(fontSize: 10, color: Colors.white),
  ),
  useMaterial3: true,
);
