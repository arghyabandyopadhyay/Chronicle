import 'dart:convert';

import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/dataModel.dart';
import 'package:chronicle/Pages/globalClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'database.dart';
int _messageCount = 0;
int getNoOfDays(int i,int j)
{
  if(i==1||i==3||i==5||i==7||i==8||i==10||i==12)return 31;
  else if(i==2)return isLeapYear(j)?29:28;
  else return 30;
}

int getDuration(int i,int j,int k)
{
  int duration=0;
  for(int a=1;a<=k;a++)
    {
      int noOfDays=getNoOfDays(i,j);
      duration=duration+noOfDays;
      i++;
      if(i==1)j++;
    }
  return duration;
}
bool isLeapYear(int year){
  if(year%4==0)
  {
    if(year%100==0)
    {
      if(year%400==0)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    else
    {
      return true;
    }
  }
  else
  {
    return false;
  }
}
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
      'body': 'Subscription of ${clientElement.name} of Register ${register} ended on ${clientElement.endDate}',
      'image':'https://i.ibb.co/c3rjd9r/ic-launcher.png'
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

Future<void> sendNotifications(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  String serverKey="AAAADvz3IsE:APA91bETielvzPZu6Z1qzpWIOSaTErxvtuSiKzW_qBh_v0LIC5nczWOC0kGSp1HyI2PVpxLr477RZ8tR8SM4zFEPaIk-_Ndj81VUQEhvP3YDTkwXOrogwvQg_vbUTcH8YnFF7nhneaUT";
  if (GlobalClass.applicationToken == null) {
    globalShowInSnackBar(scaffoldMessengerKey,'Unable to send FCM message, no token exists.');
    return;
  }
  try {
    GlobalClass.registerList.forEach((registerElement)  {
      registerElement.clients.forEach((clientElement) async{
        if(clientElement.notificationCount<3)
        {
          int a=clientElement.endDate.difference(DateTime.now()).inDays;
          if((a>-3&&a<1)&&clientElement.due>=0)
          {
            await http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':'key=${serverKey}'
              },
              body: constructFCMPayload(GlobalClass.applicationToken,clientElement,registerElement.name),
            );
            clientElement.notificationCount++;
            updateClient(clientElement, clientElement.id);
          }
        }
      });
    });
  } catch (e) {
    globalShowInSnackBar(scaffoldMessengerKey,e);
  }
}


Future<void> sendNotificationsToAll(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
  String serverKey="AAAADvz3IsE:APA91bETielvzPZu6Z1qzpWIOSaTErxvtuSiKzW_qBh_v0LIC5nczWOC0kGSp1HyI2PVpxLr477RZ8tR8SM4zFEPaIk-_Ndj81VUQEhvP3YDTkwXOrogwvQg_vbUTcH8YnFF7nhneaUT";
  if (GlobalClass.applicationToken == null) {
    globalShowInSnackBar(scaffoldMessengerKey,'Unable to send FCM message, no token exists.');
    return;
  }
  try {
    List<DataModel> datas=await getAllData();
    datas.forEach((dataElement) {
      dataElement.registers.forEach((registerElement)  {
        registerElement.clients.forEach((clientElement) async{
          if(clientElement.endDate!=null&&dataElement.userDetails.first.token!=null){
            int a=clientElement.endDate.difference(DateTime.now()).inDays;
            if((a>-3&&a<1)&&clientElement.due>=0)
            {
              await http.post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization':'key=${serverKey}'
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
void updateClientUniversal(ClientModel client, DatabaseReference id) {
  id.update(client.toJson());
}