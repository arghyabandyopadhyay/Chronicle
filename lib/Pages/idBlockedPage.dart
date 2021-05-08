import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/SignInScreen.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/DrawerContent.dart';
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
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=new GlobalKey();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
        appBar: AppBar(
          title: Text("Id Blocked"),
          actions: [IconButton(icon: Icon(Icons.payment,), onPressed: (){
            globalShowInSnackBar(scaffoldMessengerKey, "New feature coming soon!!");
          }),],
        ),
        drawer: Drawer(
          child: DrawerContent(
            drawerItems: [
              if(!(GlobalClass.userDetail!=null&&GlobalClass.userDetail.isAppRegistered==1))DrawerActionModel(Icons.notifications, "Register App", ()async{
                registerAppModule(scaffoldMessengerKey);
              }),
              DrawerActionModel(Icons.account_circle, "Profile", ()async{
                Navigator.pop(context);
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen()));
              }),
              DrawerActionModel(Icons.logout, "Log out", ()async{
                await Authentication.signOut(context: context);
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(-1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween =
                    Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ));
              }),
            ],
          ),
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
    ),key: scaffoldMessengerKey,);
  }
}
