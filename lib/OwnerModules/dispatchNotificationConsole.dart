import 'package:chronicle/Models/dataModel.dart';
import 'package:chronicle/Models/tokenModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/OwnerModules/chronicleUserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
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
  Future<void> sendNotificationsToAll(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,String messageString) async {
    DateTime nowTemp=DateTime.now();
    DateTime now=DateTime(nowTemp.year,nowTemp.month,nowTemp.day);
    try {
      setState(() {
        consoleTextController.text=consoleTextController.text+"\n"+"Downloading Client list...";
      });
      List<ChronicleUserModel> chronicleUsers=await getAllChronicleClients();
      setState(() {
        consoleTextController.text=consoleTextController.text+"\n"+"Downloading Client list Complete.";
      });
      await Future.forEach(chronicleUsers,(ChronicleUserModel chronicleUser) async{
        if(chronicleUser.isAppRegistered==1){
          DataModel data=await getAllData(chronicleUser.uid);
          await Future.forEach(data.registers,(registerElement) async {
            setState(() {
              consoleTextController.text=consoleTextController.text+"\n"+"Sending notifications for register ${registerElement.name}";
            });
            await Future.forEach(registerElement.clients,(clientElement) async{
              consoleTextController.text=consoleTextController.text+"\n"+"Processing ${chronicleUser.displayName} register ${registerElement.name}:${clientElement.name}";
              if(clientElement.due<=-1&&DateTime(clientElement.startDate.year,clientElement.startDate.month+1,clientElement.startDate.day)==now){
                clientElement.due=clientElement.due+1;
                clientElement.startDate=now;
                updateClient(clientElement, clientElement.id);
              }
              else if(clientElement.endDate!=null&&data.userDetails.first.tokens!=null){
                DateTime now=DateTime.now();
                DateTime today=DateTime(now.year,now.month,now.day);
                int a=clientElement.endDate.difference(today).inDays;
                if((a>=-1&&a<=2)&&clientElement.due>=0)
                {
                  await Future.forEach(data.userDetails.first.tokens, (TokenModel element) async{
                    await http.post(
                      Uri.parse('https://fcm.googleapis.com/fcm/send'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization':'key=$messageString'
                      },
                      body: constructFCMPayload(element.token,clientElement,registerElement.name),
                    );
                  });
                  consoleTextController.text=consoleTextController.text+"\n"+"Notification sent to ${chronicleUser.displayName} for client ${clientElement.name} of register ${registerElement.name}";
                }
              }
            });
          });
        }
      });
    } catch (e) {
      globalShowInSnackBar(scaffoldMessengerKey,e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(key: scaffoldMessengerKey,child: Scaffold(
      appBar: AppBar(
        title:Text("Dispatch Notifications"),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 10,bottom: 100,left: 10,right: 10),
          child: TextFormField(
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
        label: Text("Dispatch Notification",),
        onPressed: ()async {
          consoleTextController.clear();
          setState(() {
            sendNotificationsToAll(scaffoldMessengerKey,GlobalClass.userDetail.messageString).then((value) => consoleTextController.text=consoleTextController.text+"\n"+"All Notifications dispatched.");
          });
        },
      ),
    ));
  }
}