import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/OwnerModules/ownerModule.dart';
import 'package:chronicle/Pages/aboutUsPage.dart';
import 'package:chronicle/OwnerModules/clientAccessEditPage.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/customColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  DrawerContent({Key key,this.drawerItems,this.scaffoldMessengerKey}) : super(key: key);
  final List<DrawerActionModel> drawerItems;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.start,children: [Text("Chronicle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.start,),Text("      Version 2021.1",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.end,)],),
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
            if(GlobalClass.user!=null&&GlobalClass.userDetail!=null&&GlobalClass.userDetail.isOwner==1)ListTile(
              leading: Icon(Icons.send),
              title: Text("Dispatch Notification"),
              onTap: ()async{
                sendNotificationsToAll(scaffoldMessengerKey,GlobalClass.userDetail.messageString);
              },
            ),
            if(GlobalClass.user!=null&&GlobalClass.userDetail!=null&&GlobalClass.userDetail.isOwner==1)ListTile(
              leading: Icon(Icons.account_box),
              title: Text("Users Access"),
              onTap: ()async{
                Navigator.of(context).pop();
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ClientAccessEditPage()));
              },
            ),
          ]
      ),
    );
  }
}

