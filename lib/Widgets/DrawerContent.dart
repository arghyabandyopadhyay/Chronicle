import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/Pages/aboutUsPage.dart';
import 'package:chronicle/Pages/clientAccessEditPage.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Pages/settingsPage.dart';
import 'package:chronicle/customColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  DrawerContent({Key key,this.drawerItems}) : super(key: key);
  final List<DrawerActionModel> drawerItems;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.start,children: [Text("Chronicle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.start,),Text("      Version 2020.1",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.end,)],),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>
          [
            if(GlobalClass.user!=null)DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: GlobalClass.user.photoURL != null
                        ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          GlobalClass.user.photoURL,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                        : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(GlobalClass.user.displayName,style: TextStyle(fontSize: 15),),
                  Text(GlobalClass.user.email,style: TextStyle(fontSize: 15,),),
                ],
              ),
              decoration: BoxDecoration(
              ),
            ),
            if(GlobalClass.user!=null)ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: drawerItems.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return ListTile(
                    leading: Icon(drawerItems[index].iconData),
                    title: Text(drawerItems[index].title,),
                    onTap: drawerItems[index].onTap,
                  );
                }
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
              onTap: ()async{
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AboutUsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: ()async{
                Navigator.pop(context);
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>SettingsPage()));
              },
            ),
            // if(GlobalClass.user.uid=="8daK26SfAmTAguFwBdNBAzTstuK2"||GlobalClass.user.uid=="G9xL84Y5bHM0XsdF3PUdVgU7UeX2"||GlobalClass.user.uid=="dXNxq289Z1hBhYBJ4JnaTGW9lKD3"||GlobalClass.user.uid=="TxJ48XQnEQN9Dph4xsHlmHCvjb82")ListTile(
            if(GlobalClass.user!=null&&GlobalClass.userDetail!=null&&GlobalClass.userDetail.isOwner==1)ListTile(
              leading: Icon(Icons.send),
              title: Text("Dispatch Notification"),
              onTap: ()async{
                sendNotificationsToAll();
              },
            ),
            if(GlobalClass.user!=null&&GlobalClass.userDetail!=null&&GlobalClass.userDetail.isOwner==1)ListTile(
              leading: Icon(Icons.pending_actions),
              title: Text("Users Access"),
              onTap: ()async{
                Navigator.of(context).pop();
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientAccessEditPage()));
              },
            )
          ]
      ),
    );
  }
}

