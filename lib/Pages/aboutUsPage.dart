import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../customColors.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key key,}) : super(key: key);
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("About Us"),
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          SizedBox(height: 10,),
          Image(
            height: 100,
            alignment: Alignment.center,
            image: Image.asset(
              'assets/firebase_logo.png',
            ).image,
          ),
          Center(child: Text("Chronicle",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.centerLeft,
            child: ListTile(
              dense: true,
              title: Text("App Version"),
              subtitle: Text("2020.1.0"),
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
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.call),
        label: Text("Contact Us",),
        onPressed: ()async {
          const url = 'tel:<+917074014228>';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }
}