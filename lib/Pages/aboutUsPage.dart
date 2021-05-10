import 'package:chronicle/Modules/universalModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globalClass.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key key,}) : super(key: key);
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutUsPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
      appBar: AppBar(
        title:Text("About Us"),

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
                children: <Widget>[
                  Flexible(
                    child: Image.asset(
                      'assets/firebase_logo.png',
                    ),
                  ),
                  // Image(
                  //   height: 160,
                  //   alignment: Alignment.center,
                  //   image: Image.asset(
                  //     'assets/firebase_logo.png',
                  //   ).image,
                  // ),
                  // Center(child: Text("Chronicle",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      dense: true,
                      title: Text("App Version"),
                      subtitle: Text("2021.1"),
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(5)),
                        border: Border.all(width: 0.2)
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                        dense: true,
                        title: Text("Powered By"),
                        subtitle: Text("Chronicle Business Solutions.")
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(5)),
                        border: Border.all(width: 0.2)
                    ),
                  )

                ],
              ))),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.contact_mail),
        label: Text("Contact Us",),
        onPressed: ()async {
          String url = 'mailto:<chroniclebusinesssolutions@gmail.com>?subject=Contacting Chronicle ${GlobalClass.userDetail!=null?GlobalClass.userDetail.email:""}';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            globalShowInSnackBar(scaffoldMessengerKey, 'Oops!! Something went wrong.');
          }
        },
      ),
    ));
  }
}