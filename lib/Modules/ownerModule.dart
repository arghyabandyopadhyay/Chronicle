import 'dart:convert';

import 'package:chronicle/Models/chronicleUserModel.dart';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/dataModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

// Future<List<DataModel>> getAllData() async {
//   DataSnapshot dataSnapshot = await databaseReference.child(databaseReference.root().path).once();
//   List<DataModel> datas = [];
//   if (dataSnapshot.value != null) {
//     dataSnapshot.value.forEach((key, value) {
//       DataModel data = DataModel.fromJson(jsonDecode(jsonEncode(value)),key);
//       data.setId(databaseReference.child(databaseReference.root().path+key));
//       datas.add(data);
//     });
//   }
//   return datas;
// }

Future<DataModel> getAllData(String uid) async {
  DataSnapshot dataSnapshot = await databaseReference.child(uid).once();
  DataModel data;
  data = DataModel.fromJson(jsonDecode(jsonEncode(dataSnapshot.value)),uid);
  data.setId(databaseReference.child(uid));
  return data;
}

Future<List<ChronicleUserModel>> getAllChronicleClients() async {
  DataSnapshot dataSnapshot = await databaseReference.child("Ge7TkACCKwcGHm4IAldBHalY41a2/chronicleUsers/").once();
  List<ChronicleUserModel> data = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      ChronicleUserModel dataVal = ChronicleUserModel.fromJson(jsonDecode(jsonEncode(value)));
      dataVal.setId(databaseReference.child("Ge7TkACCKwcGHm4IAldBHalY41a2/chronicleUsers/"+key));
      data.add(dataVal);
    });
  }
  return data;
}

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
      'body': 'Subscription of ${clientElement.name} of Register $register ends on ${(clientElement.endDate!=null)?(getMonth(clientElement.endDate.month)+clientElement.endDate.day.toString()+","+clientElement.endDate.year.toString()):""}',
      // 'image':'https://i.ibb.co/c3rjd9r/ic-launcher.png'
    },
  }) ;
}

Future<void> sendNotificationsToAll(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,String messageString) async {
  DateTime nowTemp=DateTime.now();
  DateTime now=DateTime(nowTemp.year,nowTemp.month,nowTemp.day);
  try {
    List<ChronicleUserModel> chronicleUsers=await getAllChronicleClients();
    chronicleUsers.forEach((chronicleUser) async{
      if(chronicleUser.canAccess==1){
        DataModel data=await getAllData(chronicleUser.uid);
        data.registers.forEach((registerElement)  {
          registerElement.clients.forEach((clientElement) async{
            if(clientElement.due<=-1&&DateTime(clientElement.startDate.year,clientElement.startDate.month+1,clientElement.startDate.day)==now){
              clientElement.due=clientElement.due+1;
              clientElement.startDate=now;
              updateClient(clientElement, clientElement.id);
            }
            else if(clientElement.endDate!=null&&data.userDetails.first.token!=null){
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
                  body: constructFCMPayload(data.userDetails.first.token,clientElement,registerElement.name),
                );
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