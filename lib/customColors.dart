import 'package:flutter/material.dart';

class CustomColors{
  static const Color firebaseBlue = Color(0XFF039BE5);
  static const Color firebaseCoral = Color(0XFFFF8A65);
  static const Color firebaseGrey = Color(0XFFECEFF1);
  static const Color firebaseYellow = Color(0XFFFFCA28);
  static const Color firebaseOrange = Color(0XFFF57C00);
  static const Color primaryColor = Color(0XFF00203f);
  static const Color whatsAppGreen = Color(0XFF4FCE5D);
  static const Color editIconColor = Colors.orange;
  static const Color sortIconColor = Colors.blue;
  static const Color refreshIconColor = Colors.green;
  static const Color infoIconColor = Colors.blue;
  static const Color callIconColor = Colors.orangeAccent;
  static const Color addToContactIconColor = Colors.blue;
  static const Color sendIconColor = Colors.blueGrey;
  static const Color addDueIconColor = Colors.red;
  static const Color addPaymentIconColor = Colors.green;
  static const Color deleteIconColor = Colors.deepOrange;
  static const Color uploadIconColor = Colors.blue;
  static const Color downloadIconColor = Colors.indigo;




  static const Color lastMonthTextColor = Colors.orangeAccent;
  static const Color paidTextColor = Colors.green;
  static const Color dueTextColor = Colors.red;
  static const Color loadingBottomStrapColor = Colors.black87;
  static const Color loadingBottomStrapTextColor = Colors.white;
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
    canvasColor: Colors.white,
    primaryColorDark: CustomColors.primaryColor,
    primaryColorLight: Colors.white,
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
    canvasColor: CustomColors.primaryColor,
    primaryColorDark: CustomColors.primaryColor,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: CustomColors.primaryColor,
    dialogBackgroundColor: CustomColors.primaryColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: CustomColors.primaryColor
    )
);