import 'package:flutter/material.dart';

ThemeData appLightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.purple)
  ),
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
