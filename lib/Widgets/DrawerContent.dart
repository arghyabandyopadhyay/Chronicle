import 'package:chronicle/Models/DrawerActionModel.dart';
import 'package:chronicle/customColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  DrawerContent({Key? key,this.drawerItems,this.user}) : super(key: key);
  final List<DrawerActionModel>? drawerItems;
  final User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(color:Colors.black,child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text(" Chronicle"),Text("Version 2021.1"),],)),
      appBar: AppBar(
        elevation: 0,
        title: Text(" Chronicle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>
          [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: user!.photoURL != null
                        ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          user!.photoURL!,
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
                  Text(user!.displayName!,style: TextStyle(fontSize: 15),),
                  Text(user!.email!,style: TextStyle(fontSize: 15,),),
                ],
              ),
              decoration: BoxDecoration(
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: drawerItems!.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return ListTile(
                    leading: Icon(drawerItems![index].iconData),
                    title: Text(drawerItems![index].title,),
                    onTap: drawerItems![index].onTap,
                  );
                }
            ),
          ]
      ),
    );
  }
}

