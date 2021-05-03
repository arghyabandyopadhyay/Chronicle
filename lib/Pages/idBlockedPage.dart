import 'package:chronicle/Pages/SignInScreen.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


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
          title: Text("Id Blocked"),
          actions: [IconButton(icon: Icon(Icons.account_circle_outlined,), onPressed: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen()));
          }),],
        ),
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
                Flexible(
                  child: Image.asset(
                    'assets/idBlocked.jpg',
                    // height: 400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Please contact System Administrator',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment:MainAxisAlignment.end,children: [
          FloatingActionButton.extended(
            heroTag:"contact_usButton",
            onPressed: ()async {
              String url = 'mailto:<chroniclebusinesssolutions@gmail.com>?subject=ID Blocked ${GlobalClass.userDetail!=null?GlobalClass.userDetail.email:""}';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            icon: Icon(Icons.contact_mail), label: Text("Contact Us"),
          ),
          SizedBox(width: 10,),
          FloatingActionButton.extended(heroTag:"refreshButton",
            onPressed: () {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>SignInScreen()));
            }, label: Text("Refresh"),
            icon: Icon(Icons.refresh),),],)
    );
  }
}
