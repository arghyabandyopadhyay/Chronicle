import 'dart:io';

import 'package:chronicle/Models/tokenModel.dart';
import 'package:chronicle/Pages/StudentPages/masterPage.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Pages/errorDisplayPage.dart';
import 'package:chronicle/Pages/TutorPages/registersPage.dart';
import 'package:chronicle/customColors.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import '../Modules/auth.dart';

class GoogleSignInButton extends StatefulWidget {

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  GoogleSignInButton({Key key,this.scaffoldMessengerKey}) : super(key: key);
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  // Future<void> setToken(String token) async {
  //   GlobalClass.applicationToken = token;
  //   getUserDetails().then((value) => {
  //     value.tokens=token,
  //     value.update()
  //   });
  // }
  Future<void> setToken(String token) async {
    bool foundDeviceHistory=false;
    if (Platform.isIOS) {
      // request permissions if we're on android
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      GlobalClass.applicationToken = token;
      if(GlobalClass.user!=null)getUserDetails().then((value) => {
        if(value.tokens==null){
          addToken(value, TokenModel(token: token,deviceId: iosInfo.identifierForVendor,deviceModel: iosInfo.model))
        }
        else{
          value.tokens.forEach((element) {
            if(element.deviceId==iosInfo.identifierForVendor) {
              element.token = token;
              foundDeviceHistory=true;
              updateToken(element);
            }
          }),
          if(!foundDeviceHistory)addToken(value,TokenModel(token: token,deviceId: iosInfo.identifierForVendor,deviceModel: iosInfo.model))
        },
      });
    }
    else if(Platform.isAndroid){
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      GlobalClass.applicationToken = token;
      if(GlobalClass.user!=null)getUserDetails().then((value) => {
        if(value.tokens==null){
          addToken(value, TokenModel(token: token,deviceId: androidInfo.androidId,deviceModel: androidInfo.model))
        }
        else{
          value.tokens.forEach((element) {
            if(element.deviceId==androidInfo.androidId) {
              element.token = token;
              foundDeviceHistory=true;
              updateToken(element);
            }
          }),
          if(!foundDeviceHistory)addToken(value,TokenModel(token: token,deviceId: androidInfo.androidId,deviceModel: androidInfo.model))
        },
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.firebaseYellow),
      )
          : OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });

          User user =
          await Authentication.signInWithGoogle(context,widget.scaffoldMessengerKey);

          setState(() {
            if(user!=null){
              // initiateDatabase();
              GlobalClass.user=user;
              addUserDetail().then((value) => {
              _isSigningIn = false,
                if(value!=null)
                  {
                    FirebaseMessaging.instance.getToken().then(setToken),
                    if(GlobalClass.userDetail!=null){
                      if(GlobalClass.userDetail.isAppRegistered==1)Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RegistersPage()))
                      else Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>MasterPage()))
                    }
                    else Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>ErrorDisplayPage(appBarText: "Id Blocked",asset: "idBlocked.jpg",message: 'Please contact System Administrator',)))

                  }
                else{
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>ErrorDisplayPage(appBarText: "Id Blocked",asset: "idBlocked.jpg",message: 'Please contact System Administrator',)))
                }
              });}
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google_logo.png"),
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}