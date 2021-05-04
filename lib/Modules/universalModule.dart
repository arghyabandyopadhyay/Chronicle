import 'dart:convert';

import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/dataModel.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/addQuantityDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms/sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database.dart';
int _messageCount = 0;
String constructFCMPayload(String token, ClientModel clientElement,String register) {
  _messageCount++;
  return jsonEncode({
    'to': token,
    'data': {
      'via': 'Chronicle',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': clientElement.name,
      'body': 'Subscription of ${clientElement.name} of Register $register ends on ${clientElement.endDate.day}',
      // 'image':'https://i.ibb.co/c3rjd9r/ic-launcher.png'
    },
  }) ;
}

void globalShowInSnackBar(GlobalKey<ScaffoldMessengerState> messengerState,String content)
{
  messengerState.currentState.hideCurrentSnackBar();
  messengerState.currentState.showSnackBar(new SnackBar(content: Text(content)));
}


Future<List<DataModel>> getAllData() async {
  DataSnapshot dataSnapshot = await databaseReference.child(databaseReference.root().path).once();
  List<DataModel> datas = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      DataModel data = DataModel.fromJson(jsonDecode(jsonEncode(value)),key);
      data.setId(databaseReference.child(databaseReference.root().path+key));
      datas.add(data);
    });
  }
  return datas;
}

// Future<void> sendNotifications(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,String messageString) async {
//   if (GlobalClass.applicationToken == null) {
//     globalShowInSnackBar(scaffoldMessengerKey,'Unable to send FCM message, no token exists.');
//     return;
//   }
//   try {
//     GlobalClass.registerList.forEach((registerElement)  {
//       registerElement.clients.forEach((clientElement) async{
//         if(clientElement.notificationCount<3)
//         {
//           int a=clientElement.endDate.difference(DateTime.now()).inDays;
//           if((a>-3&&a<1)&&clientElement.due>=0)
//           {
//             await http.post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'Authorization':'key=${messageString}'
//               },
//               body: constructFCMPayload(GlobalClass.applicationToken,clientElement,registerElement.name),
//             );
//             clientElement.notificationCount++;
//             updateClient(clientElement, clientElement.id);
//           }
//         }
//       });
//     });
//   } catch (e) {
//     globalShowInSnackBar(scaffoldMessengerKey,e);
//   }
// }


Future<void> sendNotificationsToAll(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,String messageString) async {
  DateTime nowTemp=DateTime.now();
  DateTime now=DateTime(nowTemp.year,nowTemp.month,nowTemp.day);
  try {
    List<DataModel> datas=await getAllData();
    datas.forEach((dataElement) {
      dataElement.registers.forEach((registerElement)  {
        registerElement.clients.forEach((clientElement) async{
          if(clientElement.due<=-1&&DateTime(clientElement.startDate.year,clientElement.startDate.month+1,clientElement.startDate.day)==now){
            clientElement.due=clientElement.due+1;
            clientElement.startDate=now;
            updateClient(clientElement, clientElement.id);
          }
          else if(clientElement.endDate!=null&&dataElement.userDetails.first.token!=null){
            DateTime now=DateTime.now();
            DateTime today=DateTime(now.year,now.month,now.day);
            int a=clientElement.endDate.difference(today).inDays;
            if((a>=-1&&a<=2)&&clientElement.due>=0)
            {
              await http.post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization':'key=$messageString'
                },
                body: constructFCMPayload(dataElement.userDetails.first.token,clientElement,registerElement.name),
              );
            }
          }
        });
      });
    });
  } catch (e) {
    globalShowInSnackBar(scaffoldMessengerKey,e);
  }
}
addDueModule(ClientModel clientData, state){
  state.setState(() {
    clientData.due=clientData.due+1;
    if(clientData.due<=1){
      clientData.startDate=DateTime(clientData.startDate.year,clientData.startDate.month+1,clientData.startDate.day);
    }
    if(clientData.due>=1)
    {
      clientData.endDate=DateTime(clientData.endDate.year,clientData.endDate.month+1,clientData.endDate.day);
    }
    updateClient(clientData, clientData.id);
  });
}
callModule(ClientModel clientData)async{
  if(clientData.mobileNo!=null&&clientData.mobileNo!="")
  {
    var url = 'tel:<${clientData.mobileNo}>';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }
}
whatsAppModule(ClientModel clientData,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey)async{
  if(clientData.mobileNo!=null&&clientData.mobileNo!="")
  {
    var url = "https://wa.me/+91${clientData.mobileNo}?text=${clientData.name}, ${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
        ", please clear your dues for further continuation of services."}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  else globalShowInSnackBar(scaffoldMessengerKey,"Please Enter Mobile No");
}
smsModule(ClientModel clientData,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey)async{
  if(clientData.mobileNo!=null&&clientData.mobileNo!="")
  {
    SmsSender sender = new SmsSender();
    String address = clientData.mobileNo;
    String message = "${clientData.name}, ${GlobalClass.userDetail.reminderMessage!=null&&GlobalClass.userDetail.reminderMessage!=""?GlobalClass.userDetail.reminderMessage:"Your subscription has come to an end"
        ", please clear your dues for further continuation of services."}";
    if(address!=null&&address!="") {
      sender.sendSms(new SmsMessage(address, message)).then((value) => globalShowInSnackBar(scaffoldMessengerKey,"Message has been sent to ${clientData.name}!!"));
    }
  }
  else globalShowInSnackBar(scaffoldMessengerKey,"No Mobile no present!!");
}
deleteModule(ClientModel clientData,BuildContext context,state)async{
  showDialog(context: context, builder: (_)=>new AlertDialog(
    title: Text("Confirm Delete"),
    content: Text("Are you sure?"),
    actions: [
      ActionChip(label: Text("Yes"), onPressed: (){
        state.setState(() {
          deleteDatabaseNode(clientData.id);
          Navigator.of(_).pop();
          Navigator.of(context).pop();
        });
      }),
      ActionChip(label: Text("No"), onPressed: (){
        state.setState(() {
          Navigator.of(_).pop();
        });
      })
    ],
  ));
}
addPaymentModule(ClientModel clientData,BuildContext context,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey, state,){
  showDialog(context: context, builder: (_) =>new AddQuantityDialog()
  ).then((value) {
    try
    {
      int intVal=int.parse(value.toString());
      state.setState(() {
        if(clientData.due>intVal) {
          clientData.startDate=DateTime(clientData.startDate.year,clientData.startDate.month+intVal,clientData.startDate.day);
        }
        else{
          if(clientData.due<0){
            clientData.endDate=DateTime(clientData.endDate.year,clientData.endDate.month+intVal,clientData.endDate.day);
          }
          else{
            clientData.startDate=DateTime(clientData.endDate.year,clientData.endDate.month-1,clientData.endDate.day);
            clientData.endDate=DateTime(clientData.endDate.year,clientData.endDate.month+(intVal-clientData.due),clientData.endDate.day);
          }
        }
        clientData.due=clientData.due-intVal;
        updateClient(clientData, clientData.id);
      });
    }
    catch(E){
      globalShowInSnackBar(scaffoldMessengerKey, "Invalid Quantity!!");
    }
  });
}
void changesSavedModule(BuildContext context,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey)
{
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
  globalShowInSnackBar(scaffoldMessengerKey,"Changes have been saved");
}