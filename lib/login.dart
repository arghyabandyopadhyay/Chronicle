import 'package:Chronicle/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Chronicle/Pages/myHomePage.dart';
import 'auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Chronicle')), body: Body());
  }
}
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User user;
  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }
  void click() {
    var id;
    signInWithGoogle().then((user) => {
          this.user = user,
          registerUserDetail(user).then((value) => {
            if(value!=null)Navigator.push(context,
                CupertinoPageRoute(builder: (context) => MyHomePage(user)))
            else{
            }
          }),
        });
  }
  Widget googleLoginButton() {
    return OutlinedButton(
        onPressed: this.click,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/google_logo.png'), height: 35),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Sign in with Google',
                        style: TextStyle(color: Colors.grey, fontSize: 25)))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: googleLoginButton());
  }
}
