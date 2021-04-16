import 'package:flutter/material.dart';

class CustomColors{
  static const Color firebaseBlue = Color(0XFF039BE5);
  static const Color firebaseCoral = Color(0XFFFF8A65);
  static const Color firebaseGrey = Color(0XFFECEFF1);
  static const Color firebaseYellow = Color(0XFFFFCA28);
  static const Color firebaseOrange = Color(0XFFF57C00);
  static const Color primaryColor = Color(0XFF00203f);
}

var lightThemeData=ThemeData(
    accentColor: CustomColors.primaryColor,
    primaryColor:CustomColors.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(color: CustomColors.primaryColor,fontSize: 20,fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(
          color: CustomColors.primaryColor
      ),
    ),
    brightness: Brightness.light,
    textTheme: TextTheme(
      headline6: TextStyle(color: CustomColors.primaryColor,fontSize: 20,fontWeight: FontWeight.bold),
      headline5: TextStyle(color: CustomColors.primaryColor,),
      headline4: TextStyle(color: CustomColors.primaryColor,),
      headline3: TextStyle(color: CustomColors.primaryColor,),
      headline2: TextStyle(color: CustomColors.primaryColor,),
      headline1: TextStyle(color: CustomColors.primaryColor,),
      bodyText1: TextStyle(color: CustomColors.primaryColor),
      bodyText2: TextStyle(color: CustomColors.primaryColor),
      subtitle2: TextStyle(color: CustomColors.primaryColor),
      subtitle1: TextStyle(color: CustomColors.primaryColor),
      caption: TextStyle(color: CustomColors.primaryColor),
    ),
    primaryColorDark: Colors.white,
    primaryColorLight: CustomColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColors.primaryColor,
        foregroundColor: Colors.white
    )
);
var darkThemeData=ThemeData(
    accentColor: Colors.white,
    primaryColor:Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
        backgroundColor: CustomColors.primaryColor,
        textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
        ),
      iconTheme: IconThemeData(
        color: Colors.white
      ),
    ),
    brightness: Brightness.dark,
    primaryColorDark: CustomColors.primaryColor,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: CustomColors.primaryColor,
    dialogBackgroundColor: CustomColors.primaryColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: CustomColors.primaryColor
    )
);
// var darkThemeData=ThemeData(
//     accentColor: Colors.black,
//     primaryColor:Color(0XFF2C384A),
//     brightness: Brightness.dark,
//     primaryColorDark: Color(0XFF2C384A),
//     primaryColorLight: Colors.white,
//     scaffoldBackgroundColor: Color(0XFF2C384A),
//     dialogBackgroundColor: Color(0XFF2C384A),
//     floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white
//     )
// );