import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/globalClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shimmer/shimmer.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  SettingsPage({ Key key,this.user}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showNotifications=false;
  TextEditingController reminderMessageText=new TextEditingController();
  TextEditingController smsApiText=new TextEditingController();
  TextEditingController smsUserIdText=new TextEditingController();
  TextEditingController smsAccessTokenText=new TextEditingController();
  TextEditingController smsMobileNoText=new TextEditingController();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  //Controller
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  Future<bool> _loadSettings() async {
    reminderMessageText.text=GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end, please clear your dues for further continuation of services.";
    smsApiText.text=GlobalClass.userDetail.smsApiUrl!=null?GlobalClass.userDetail.smsApiUrl:"";
    smsUserIdText.text=GlobalClass.userDetail.smsUserId!=null?GlobalClass.userDetail.smsUserId:"";
    smsAccessTokenText.text=GlobalClass.userDetail.smsAccessToken!=null?GlobalClass.userDetail.smsAccessToken:"";
    smsMobileNoText.text=GlobalClass.userDetail.smsMobileNo!=null?GlobalClass.userDetail.smsMobileNo:"";
    showNotifications=await getShowNotificationValue();
    return true;
  }
  void handleSubmitted(){
    GlobalClass.userDetail.reminderMessage=reminderMessageText.text;
    GlobalClass.userDetail.smsApiUrl=smsApiText.text;
    GlobalClass.userDetail.smsUserId=smsUserIdText.text;
    GlobalClass.userDetail.smsAccessToken=smsAccessTokenText.text;
    GlobalClass.userDetail.smsMobileNo=smsMobileNoText.text;
    if(reminderMessageText.text.isNotEmpty)updateUserDetails(GlobalClass.userDetail, GlobalClass.userDetail.id);
    changesSavedModule(context,scaffoldMessengerKey);
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Scaffold(
      appBar:AppBar(
          title: Text("Settings")
      ),
      body: FutureBuilder<bool>(
        future: _loadSettings(),
        builder: (context,snapshot){
          if(!snapshot.hasError)
          {
            return ListView(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              children: [
                Container(
                    height: 150,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      maxLength: 200,
                      controller: reminderMessageText,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(),
                      expands: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Reminder Message",
                        helperText: "Type the message you want to be sent to your clients as a reminder",
                        contentPadding:
                        EdgeInsets.all(10.0),
                      ),
                    )),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: smsApiText,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Sms Api",
                    helperText: "Please type the Api url for your sms gateway.",
                    contentPadding:
                    EdgeInsets.all(10.0),
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: smsMobileNoText,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Sms Gateway MobileNo",
                    helperText: "Please type the mobile no(along with the country code eg:+91) for your sms gateway.",
                    contentPadding:
                    EdgeInsets.all(10.0),
                  ),
                ),
                SizedBox(height: 10,),
                Text("All the credentials are stored in an encrypted manner."),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: smsUserIdText,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Sms UserId",
                    helperText: "Enter the Sms user id.\n*All the credentials are stored in an encrypted manner.",
                    contentPadding:
                    EdgeInsets.all(10.0),
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: smsAccessTokenText,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Sms Password",
                    helperText: "Enter the password provided by your sms gateway service provider.\n*All the credentials are stored in an encrypted manner.",
                    contentPadding:
                    EdgeInsets.all(10.0),
                  ),
                ),
              ],
            );
          }
          else if (snapshot.hasError) {
            return ErrorHasOccurred();
          }
          // By default, show a loading spinner.
          return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 4,
                        )
                    ),
                  ),
                ],
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:handleSubmitted, label: Text("Save"),icon: Icon(Icons.save,),),
    ),key: scaffoldMessengerKey,);
  }

  @override
  void dispose() {
    super.dispose();
  }
}