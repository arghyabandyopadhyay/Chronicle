import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/idBlockedPage.dart';
import 'package:chronicle/Pages/myHomePage.dart';
import 'package:chronicle/customColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chronicle/Modules/database.dart';
import '../Modules/auth.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  Future<void> setToken(String token) async {
    GlobalClass.applicationToken = token;
    getUserDetails().then((value) => {
      value.token=token,
      updateUserDetails(value, value.id)
    });
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
          await Authentication.signInWithGoogle(context);

          setState(() {
            _isSigningIn = false;
          });

          if(user!=null){
            GlobalClass.user=user;
          registerUserDetail().then((value) => {
            if(value!=null)
            {
              FirebaseMessaging.instance.getToken().then(setToken),
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyHomePage(true)))
            }
            else{
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>IdBlockedPage()))
            }
          });}
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