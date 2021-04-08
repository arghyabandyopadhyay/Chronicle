import 'package:flutter/material.dart';

class CustomColors{
  static const Color firebaseBlue = Color(0XFF039BE5);
  static const Color firebaseCoral = Color(0XFFFF8A65);
  static const Color firebaseGrey = Color(0XFFECEFF1);
  static const Color firebaseYellow = Color(0XFFFFCA28);
  static const Color firebaseOrange = Color(0XFFF57C00);

}

var lightThemeData=ThemeData(
    accentColor: Colors.black,
    primaryColor:Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Color(0XFF2C384A),
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white
    )
);
var darkThemeData=ThemeData(
    accentColor: Colors.black,
    primaryColor:Color(0XFF2C384A),
    brightness: Brightness.dark,
    primaryColorDark: Color(0XFF2C384A),
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: Color(0XFF2C384A),
    dialogBackgroundColor: Color(0XFF2C384A),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white
    )
);