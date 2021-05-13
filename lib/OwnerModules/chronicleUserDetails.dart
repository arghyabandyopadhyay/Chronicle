import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/errorPage.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/OwnerModules/chronicleUserModel.dart';
import 'package:chronicle/OwnerModules/ownerDatabaseModule.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ChronicleUserDetailsPage extends StatefulWidget {
  final ChronicleUserModel user;
  ChronicleUserDetailsPage({Key key,this.user}) : super(key: key);
  @override
  _ChronicleUserDetailsPageState createState() => _ChronicleUserDetailsPageState();
}

class _ChronicleUserDetailsPageState extends State<ChronicleUserDetailsPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
      appBar: AppBar(
        title:Text(widget.user.displayName),
      ),
      body: FutureBuilder<UserModel>(
        future: getChronicleUserDetails(widget.user.uid),
        builder: (context,snapshot){
          if(snapshot.hasData){
            UserModel userDetail=snapshot.data;
            return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                            dense: true,
                            title: Text("Name"),
                            subtitle: Text(userDetail.displayName),
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
                              title: Text("Email"),
                              subtitle: Text(userDetail.email)
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(5)),
                              border: Border.all(width: 0.2)
                          ),
                        ),
                        if(userDetail.phoneNumber!=null)SizedBox(height: 20,),
                        if(userDetail.phoneNumber!=null)Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                              dense: true,
                              title: Text("Phone No."),
                              subtitle: Text(userDetail.phoneNumber)
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(5)),
                              border: Border.all(width: 0.2)
                          ),
                        ),
                        if(userDetail.token!=null)SizedBox(height: 20,),
                        if(userDetail.token!=null)Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                              dense: true,
                              title: Text("Device Token"),
                              subtitle: Text(userDetail.token)
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
                              title: Text("Can Access"),
                              subtitle: Text((userDetail.canAccess==1).toString())
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
                              title: Text("Is App Registered"),
                              subtitle: Text((userDetail.isAppRegistered==1).toString())
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(5)),
                              border: Border.all(width: 0.2)
                          ),
                        ),
                        if(userDetail.reminderMessage!=null)SizedBox(height: 20,),
                        if(userDetail.reminderMessage!=null)Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                              dense: true,
                              title: Text("Reminder Message"),
                              subtitle: Text(userDetail.reminderMessage.toString())
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(5)),
                              border: Border.all(width: 0.2)
                          ),
                        )
                      ],
                    )));
          }
          else if(snapshot.hasError){
            return ErrorHasOccurred();
          }
          return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.withOpacity(0.5),
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
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.contact_mail),
        label: Text("Send Reminder",),
        onPressed: ()async {
          String url = 'mailto:<${widget.user.email}>?subject=Subscription for the account ${widget.user.email} at Chronicle &body= Dear ${widget.user.displayName}, \n${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
              ", please clear your dues for further continuation of services.\n With Regards,\n Chronicle"}';
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