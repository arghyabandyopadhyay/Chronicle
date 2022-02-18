import 'package:chronicle/Modules/error_page.dart';
import 'package:chronicle/Modules/shared_preference_handler.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/Widgets/loader_widget.dart';
import 'package:chronicle/global_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  SettingsPage({Key key, this.user}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showNotifications = false;
  TextEditingController reminderMessageText = new TextEditingController();
  TextEditingController termsAndConditionsText = new TextEditingController();
  TextEditingController organizationAddressText = new TextEditingController();
  TextEditingController smsApiText = new TextEditingController();
  TextEditingController smsUserIdText = new TextEditingController();
  TextEditingController smsAccessTokenText = new TextEditingController();
  TextEditingController smsMobileNoText = new TextEditingController();
  TextEditingController organizationNameText = new TextEditingController();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  //Controller
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<bool> _loadSettings() async {
    reminderMessageText.text = GlobalClass.userDetail.reminderMessage != null &&
            GlobalClass.userDetail.reminderMessage != ""
        ? GlobalClass.userDetail.reminderMessage
        : "Your subscription has come to an end, please clear your dues for further continuation of services.";
    termsAndConditionsText.text =
        GlobalClass.userDetail.termsAndConditions != null &&
                GlobalClass.userDetail.termsAndConditions != ""
            ? GlobalClass.userDetail.termsAndConditions
            : "";
    organizationAddressText.text =
        GlobalClass.userDetail.organizationAddress != null
            ? GlobalClass.userDetail.organizationAddress
            : "";
    organizationNameText.text = GlobalClass.userDetail.organizationName != null
        ? GlobalClass.userDetail.organizationName
        : "";
    smsApiText.text = GlobalClass.userDetail.smsApiUrl != null
        ? GlobalClass.userDetail.smsApiUrl
        : "";
    smsUserIdText.text = GlobalClass.userDetail.smsUserId != null
        ? GlobalClass.userDetail.smsUserId
        : "";
    smsAccessTokenText.text = GlobalClass.userDetail.smsAccessToken != null
        ? GlobalClass.userDetail.smsAccessToken
        : "";
    smsMobileNoText.text = GlobalClass.userDetail.smsMobileNo != null
        ? GlobalClass.userDetail.smsMobileNo
        : "";
    showNotifications = await getShowNotificationValue();
    return true;
  }

  void handleSubmitted() {
    GlobalClass.userDetail.reminderMessage = reminderMessageText.text;
    GlobalClass.userDetail.termsAndConditions = termsAndConditionsText.text;
    GlobalClass.userDetail.smsApiUrl = smsApiText.text;
    GlobalClass.userDetail.smsUserId = smsUserIdText.text;
    GlobalClass.userDetail.smsAccessToken = smsAccessTokenText.text;
    GlobalClass.userDetail.smsMobileNo = smsMobileNoText.text;
    GlobalClass.userDetail.organizationName = organizationNameText.text;
    GlobalClass.userDetail.organizationAddress = organizationAddressText.text;
    if (reminderMessageText.text.isEmpty)
      GlobalClass.userDetail.reminderMessage =
          "Your subscription has come to an end, please clear your dues for further continuation of services.";
    GlobalClass.userDetail.update();
    changesSavedModule(context, scaffoldMessengerKey);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: FutureBuilder<bool>(
          future: _loadSettings(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              return ListView(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: organizationNameText,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Organization Name",
                      helperText:
                          "Name of your organization, that will appear in your invoices.",
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 150,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 200,
                        controller: organizationAddressText,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(),
                        expands: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Organization Address",
                          helperText:
                              "Address of your organization, that will appear in your invoices",
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
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
                          helperText:
                              "Type the message you want to be sent to your clients as a reminder",
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 200,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 300,
                        controller: termsAndConditionsText,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(),
                        expands: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Terms and Conditions",
                          helperText:
                              "Type the terms and conditions to be specified in invoices.",
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: smsApiText,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Sms Api",
                      helperText:
                          "Please type the Api url for your sms gateway.",
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: smsMobileNoText,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Sms Gateway MobileNo",
                      helperText:
                          "Please type the mobile no(along with the country code eg:+91) for your sms gateway.",
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "All the credentials are stored in an encrypted manner."),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: smsUserIdText,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Sms UserId",
                      helperText:
                          "Enter the Sms user id.\n*All the credentials are stored in an encrypted manner.",
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: smsAccessTokenText,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Sms Password",
                      helperText:
                          "Enter the password provided by your sms gateway service provider.\n*All the credentials are stored in an encrypted manner.",
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return ErrorHasOccurred();
            }
            // By default, show a loading spinner.
            return LoaderWidget();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "saveSettingsHeroTag",
          onPressed: handleSubmitted,
          label: Text("Save"),
          icon: Icon(
            Icons.save,
          ),
        ),
      ),
      key: scaffoldMessengerKey,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
