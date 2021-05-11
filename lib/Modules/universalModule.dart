import 'dart:convert';
import 'dart:typed_data';

import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:chronicle/Widgets/addQuantityDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'database.dart';

void globalShowInSnackBar(GlobalKey<ScaffoldMessengerState> messengerState,String content)
{
  messengerState.currentState.hideCurrentSnackBar();
  messengerState.currentState.showSnackBar(new SnackBar(content: Text(content)));
}
String encrypt(String password){
  String encryptedPassword = "";
  Uint8List encode = utf8.encode(password);
  encryptedPassword = base64Encode(encode);
  return encryptedPassword;
}
String getMonth(int month)
{
  String monthString;
  switch (month) {
    case 1:  monthString = "Jan ";
    break;
    case 2:  monthString = "Feb ";
    break;
    case 3:  monthString = "Mar ";
    break;
    case 4:  monthString = "Apr ";
    break;
    case 5:  monthString = "May ";
    break;
    case 6:  monthString = "Jun ";
    break;
    case 7:  monthString = "Jul ";
    break;
    case 8:  monthString = "Aug ";
    break;
    case 9:  monthString = "Sep ";
    break;
    case 10: monthString = "Oct ";
    break;
    case 11: monthString = "Nov ";
    break;
    case 12: monthString = "Dec ";
    break;
    default: monthString = "$month";
    break;
  }
  return monthString;
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
callModule(ClientModel clientData,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey)async{
  if(clientData.mobileNo!=null&&clientData.mobileNo!="")
  {
    var url = 'tel:<${clientData.mobileNo}>';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    globalShowInSnackBar(scaffoldMessengerKey, 'Oops!! Something went wrong.');
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
      globalShowInSnackBar(scaffoldMessengerKey, 'Oops!! Something went wrong.');
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
registerAppModule(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey)async{
  var url = "mailto:<chroniclebusinesssolutions@gmail.com>?subject=Register Chronicle ${GlobalClass.user.email}&body= Respected Sir, \nPlease register my account. My token is ${GlobalClass.user.uid}";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    globalShowInSnackBar(scaffoldMessengerKey,"Access Denied for sending email!!");
  }
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
String getFormattedMobileNo(String value)
{
  value=value.replaceAll(" ", "");
  RegExp mobileNoRegex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  if (value.length == 0) {
    return value;
  }
  else if (mobileNoRegex.hasMatch(value)) {
    if(value.length==10){
      return value.substring(0,5)+" "+value.substring(5);
    }
    else if(value.length==11){
      return value.substring(1,6)+" "+value.substring(6);
    }
    else if(value.length==12){
      return value.substring(2,7)+" "+value.substring(7);
    }
    else if(value.length==13){
      return value.substring(3,8)+" "+value.substring(8);
    }
    else return "";
  }
  else{
    return "";
  }
}
void changesSavedModule(BuildContext context,GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey)
{
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
  globalShowInSnackBar(scaffoldMessengerKey,"Changes have been saved");
}