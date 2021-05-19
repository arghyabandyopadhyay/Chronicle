import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarVariables
{
  static final  List<Widget> aboutBoxChildren = <Widget>[
    const SizedBox(height: 24),
    Text('Chronicle is an easy to go Register maintaining application. '
        'It is capable of managing your registers and maintaining '
        'the fee records of your clients. '),
  ];

  static Widget appBarLeading(appBarLeading)=>Container( child: Row(children: [GestureDetector(
      onTap: (){
        showAboutDialog(
          context: appBarLeading,
          applicationIcon: Image.asset("assets/icon.png",width: 40,height: 40,),
          applicationName: 'Chronicle',
          applicationVersion: 'Version 2021.2',
          applicationLegalese: '\u{a9} 2021 Chronicle Business Solutions',
          children: AppBarVariables.aboutBoxChildren,
        );
      },child:Image.asset("assets/icon.png",height: 25, width: 25,)),Text(" Chronicle")],),);
}