import 'package:chronicle/Models/user_model.dart';
import 'package:chronicle/Modules/error_page.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/OwnerModules/chronicle_user_model.dart';
import 'package:chronicle/OwnerModules/owner_database_module.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/global_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ChronicleUserDetailsPage extends StatefulWidget {
  final ChronicleUserModel user;
  ChronicleUserDetailsPage({Key key, this.user}) : super(key: key);
  @override
  _ChronicleUserDetailsPageState createState() =>
      _ChronicleUserDetailsPageState();
}

class _ChronicleUserDetailsPageState extends State<ChronicleUserDetailsPage> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.user.displayName),
          ),
          body: FutureBuilder<UserModel>(
            future: getChronicleUserDetails(widget.user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel userDetail = snapshot.data;
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(width: 0.2)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.centerLeft,
                              child: ListTile(
                                  dense: true,
                                  title: Text("Email"),
                                  subtitle: Text(userDetail.email)),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(width: 0.2)),
                            ),
                            if (userDetail.phoneNumber != null)
                              SizedBox(
                                height: 20,
                              ),
                            if (userDetail.phoneNumber != null)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.centerLeft,
                                child: ListTile(
                                    dense: true,
                                    title: Text("Phone No."),
                                    subtitle: Text(userDetail.phoneNumber)),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(width: 0.2)),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.centerLeft,
                              child: ListTile(
                                  dense: true,
                                  title: Text("Can Access"),
                                  subtitle: Text(
                                      (userDetail.canAccess == 1).toString())),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(width: 0.2)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.centerLeft,
                              child: ListTile(
                                dense: true,
                                title: Text("Storage Occupied"),
                                subtitle: Text(
                                    classifySize(userDetail.cloudStorageSize)),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(width: 0.2)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.centerLeft,
                              child: ListTile(
                                  dense: true,
                                  title: Text("Is App Registered"),
                                  subtitle: Text(
                                      (userDetail.isAppRegistered == 1)
                                          .toString())),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(width: 0.2)),
                            ),
                            if (userDetail.reminderMessage != null)
                              SizedBox(
                                height: 20,
                              ),
                            if (userDetail.reminderMessage != null)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.centerLeft,
                                child: ListTile(
                                    dense: true,
                                    title: Text("Reminder Message"),
                                    subtitle: Text(
                                        userDetail.reminderMessage.toString())),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(width: 0.2)),
                              )
                          ],
                        )));
              } else if (snapshot.hasError) {
                return ErrorHasOccurred();
              }
              return LoaderWidget();
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Row(
            children: [
              FloatingActionButton.extended(
                heroTag: "sendReminderHeroTag",
                icon: Icon(Icons.contact_mail),
                label: Text(
                  "Send Reminder",
                ),
                onPressed: () async {
                  String url =
                      'mailto:<${widget.user.email}>?subject=Subscription for the account ${widget.user.email} at Chronicle &body= Dear ${widget.user.displayName}, \n${GlobalClass.userDetail.reminderMessage != null && GlobalClass.userDetail.reminderMessage != "" ? GlobalClass.userDetail.reminderMessage : "Your subscription has come to an end"
                          ", please clear your dues for further continuation of services.\n With Regards,\n Chronicle"}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    globalShowInSnackBar(
                        scaffoldMessengerKey, 'Oops!! Something went wrong.');
                  }
                },
              ),
              FloatingActionButton.extended(
                heroTag: "saveChronicleUserDetailsHeroTag",
                icon: Icon(Icons.save_outlined),
                label: Text(
                  "Save",
                ),
                onPressed: () {},
              )
            ],
          ),
        ));
  }
}
