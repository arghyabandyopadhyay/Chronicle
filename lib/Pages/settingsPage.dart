import 'dart:io';
import 'package:chronicle/Modules/sharedPreferenceHandler.dart';
import 'package:chronicle/Pages/idBlockedPage.dart';
import 'package:chronicle/Pages/myHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:shimmer/shimmer.dart';

import '../customColors.dart';

class SettingsPage extends StatefulWidget {
  User? user;
  SettingsPage({ Key? key,this.user}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showNotifications=false;

  //Controller
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  Future<bool> _loadSettings() async {
    showNotifications=await getShowNotificationValue();
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          elevation: 0,
          title: Text("Settings")
        ),
        body: FutureBuilder<bool>(
          future: _loadSettings(),
          builder: (context,snapshot){
            if(!snapshot.hasError)
            {
              return Column(
                children: [
                  Expanded(child:SettingsList(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    sections: [
                      SettingsSection(
                        tiles: [
                          SettingsTile.switchTile(
                            title: 'Show Notifications',
                            leading: Icon(Icons.notifications_active),
                            switchValue: showNotifications,
                            subtitle: "beta",
                            onToggle: (bool value) {
                              setState(() {
                                showNotifications=value;
                                setShowNotificationValue(value);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
                ],
              );
            }
            else if (snapshot.hasError) {
              return IdBlockedPage();
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
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}