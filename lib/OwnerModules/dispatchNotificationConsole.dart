import 'package:chronicle/Modules/universalModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../globalClass.dart';
import 'ownerModule.dart';

class DispatchNotificationConsole extends StatefulWidget {
  DispatchNotificationConsole({Key key}) : super(key: key);
  @override
  _DispatchNotificationConsoleState createState() => _DispatchNotificationConsoleState();
}

class _DispatchNotificationConsoleState extends State<DispatchNotificationConsole> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey=GlobalKey();
  TextEditingController consoleTextController=new TextEditingController();
  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
      appBar: AppBar(
        title:Text("Dispatch Notifications"),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10,bottom: 100,left: 10,right: 10),
          child: TextField(
            scrollController: scrollController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: consoleTextController,
            textInputAction: TextInputAction.newline,
            style: TextStyle(),
            expands: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Console",
              contentPadding:
              EdgeInsets.all(10.0),
            ),
          )),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "dispatchNotificationHeroTag",
        icon: Icon(Icons.send),
        label: Text("Dispatch Notification"),
        onPressed: ()async {
          consoleTextController.clear();
          setState(() {
            sendNotificationsToAll(scaffoldMessengerKey,GlobalClass.userDetail.messageString,(String updateText){
              setState(() {
                consoleTextController.text=consoleTextController.text+"\n"+updateText;
              });
            }).then((value) async =>{
              consoleTextController.text=consoleTextController.text+"\n"+"All Notifications dispatched.",
              globalShowInSnackBar(scaffoldMessengerKey,"All notifications have been dispatched."),
              await scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              ),
              await scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              )
            });
          });

        },
      ),
    ));
  }
}