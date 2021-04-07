import 'package:chronicle/Widgets/googleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../customColors.dart';
import '../database.dart';
import 'idBlockedPage.dart';
import 'myHomePage.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/firebase_logo.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Chronicles',
                      style: TextStyle(
                        color: CustomColors.firebaseYellow,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Authentication',
                      style: TextStyle(
                        color: CustomColors.firebaseOrange,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    User? user = FirebaseAuth.instance.currentUser;
                    if(user!=null){
                      registerUserDetail(user).then((value) => {
                        if(value!=null)Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => MyHomePage(user)))
                        else{
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>IdBlockedPage(user: user,)))
                        }
                      });
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange,
                        ),
                      );
                    }
                    else return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.firebaseOrange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}