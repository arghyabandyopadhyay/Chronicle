import 'package:chronicle/Pages/SignInScreen.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IdBlockedPage extends StatefulWidget {
  final User user;
  IdBlockedPage({Key key,this.user}):super(key: key);

  @override
  _IdBlockedPageState createState() => _IdBlockedPageState();
}

class _IdBlockedPageState extends State<IdBlockedPage> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Id Blocked"),
        actions: [IconButton(icon: Icon(Icons.account_circle_outlined,), onPressed: (){
          Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen()));
        }),],
      ),
      body: Center(
        child: Image.asset(
          'assets/firebase_logo.png',
          height: 160,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>SignInScreen()));
      },
        child: Icon(Icons.refresh),),
    );
  }
}
