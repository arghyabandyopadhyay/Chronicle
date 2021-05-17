import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Modules/auth.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/routingPage.dart';
import 'package:chronicle/globalClass.dart';
import 'package:chronicle/Pages/userInfoScreen.dart';
import 'package:chronicle/Widgets/drawerContent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ErrorDisplayPage extends StatefulWidget {
  final String asset;
  final String message;
  final String appBarText;
  ErrorDisplayPage({Key key,this.asset,this.message,this.appBarText}):super(key: key);

  @override
  _ErrorDisplayPageState createState() => _ErrorDisplayPageState();
}

class _ErrorDisplayPageState extends State<ErrorDisplayPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=new GlobalKey();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarText),
        ),
        drawer: Drawer(
          child: DrawerContent(
            drawerItems: [
              DrawerActionModel(Icons.account_circle, "Profile", ()async{
                Navigator.pop(context);
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>UserInfoScreen()));
              }),
              DrawerActionModel(Icons.logout, "Log out", ()async{
                await Authentication.signOut(context: context);
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => RoutingPage(),
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
        body: Center(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/${widget.asset}'),
            SizedBox(height: 10,),
            Text(widget.message, textAlign: TextAlign.center,textScaleFactor: 1,style: TextStyle(fontSize: 25),)
          ],
        ) ),
        floatingActionButton: Row(
          mainAxisAlignment:MainAxisAlignment.end,children: [
          if(widget.appBarText=="Id Blocked")FloatingActionButton.extended(
            heroTag:"contact_usButton",
            onPressed: ()async {
              String url = 'mailto:<chroniclebusinesssolutions@gmail.com>?subject=ID Blocked ${GlobalClass.userDetail!=null?GlobalClass.userDetail.email:""}';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                globalShowInSnackBar(scaffoldMessengerKey, 'Oops!! Something went wrong.');
              }
            },
            icon: Icon(Icons.contact_mail), label: Text("Contact Us"),
          ),
          SizedBox(width: 10,),
          FloatingActionButton.extended(heroTag:"refreshButton",
            onPressed: () {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>RoutingPage()));
            }, label: Text("Refresh"),
            icon: Icon(Icons.refresh),),],)
    ),key: scaffoldMessengerKey,);
  }
}
