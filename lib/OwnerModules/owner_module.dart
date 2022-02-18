import 'dart:convert';

import 'package:chronicle/Models/token_model.dart';
import 'package:chronicle/OwnerModules/chronicle_user_model.dart';
import 'package:chronicle/Models/client_model.dart';
import 'package:chronicle/Models/data_model.dart';
import 'package:chronicle/Modules/universal_module.dart';
import 'package:chronicle/global_class.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Modules/database.dart';
import 'package:http/http.dart' as http;

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
  DataSnapshot dataSnapshot = await databaseReference.child(uid + "/").once();
  DataModel data;
  data = DataModel.fromJson(jsonDecode(jsonEncode(dataSnapshot.value)), uid);
  data.setId(databaseReference.child(uid + "/"));
  return data;
}

Future<List<ChronicleUserModel>> getAllChronicleClients() async {
  DataSnapshot dataSnapshot = await databaseReference
      .child("${GlobalClass.userDetail.repo}/chronicleUsers/")
      .once();
  List<ChronicleUserModel> data = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      ChronicleUserModel dataVal =
          ChronicleUserModel.fromJson(jsonDecode(jsonEncode(value)));
      dataVal.setId(databaseReference
          .child("${GlobalClass.userDetail.repo}/chronicleUsers/" + key));
      data.add(dataVal);
    });
  }
  return data;
}

int _messageCount = 0;
String constructFCMPayload(
    String token, ClientModel clientElement, String register) {
  _messageCount++;
  return jsonEncode({
    'to': token,
    'data': {
      'via': 'Chronicle',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': clientElement.name,
      'body':
          'Subscription of ${clientElement.name} of Register $register ends on ${(clientElement.endDate != null) ? (getMonth(clientElement.endDate.month) + clientElement.endDate.day.toString() + "," + clientElement.endDate.year.toString()) : ""}',
      // 'image':'https://i.ibb.co/c3rjd9r/ic-launcher.png'
    },
  });
}

List<ChronicleUserModel> sortChronicleUsersModule(
    String sortType, List<ChronicleUserModel> listToBeSorted) {
  List<ChronicleUserModel> sortedList = [];
  if (sortType == "A-Z") {
    listToBeSorted.sort((a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    sortedList = listToBeSorted;
  } else if (sortType == "Z-A") {
    listToBeSorted.sort((a, b) =>
        b.displayName.toLowerCase().compareTo(a.displayName.toLowerCase()));
    sortedList = listToBeSorted;
  }
  return sortedList;
}

Future<void> sendNotificationsToAll(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    String messageString,
    Function(String) update) async {
  DateTime nowTemp = DateTime.now();
  DateTime now = DateTime(nowTemp.year, nowTemp.month, nowTemp.day);
  try {
    update("Downloading Client list...");

    List<ChronicleUserModel> chronicleUsers = await getAllChronicleClients();
    update("Downloading Client list Complete.");
    await Future.forEach(chronicleUsers,
        (ChronicleUserModel chronicleUser) async {
      if (chronicleUser.isAppRegistered == 1) {
        DataModel data = await getAllData(chronicleUser.uid);
        await Future.forEach(data.registers, (registerElement) async {
          update("Sending notifications for register ${registerElement.name}");
          String updateBatch = "";
          await Future.forEach(registerElement.clients, (clientElement) async {
            updateBatch = updateBatch +
                "\n" +
                "Processing ${chronicleUser.displayName} register ${registerElement.name}:${clientElement.name}";
            if (clientElement.due <= -1 &&
                DateTime(
                        clientElement.startDate.year,
                        clientElement.startDate.month + 1,
                        clientElement.startDate.day) ==
                    now) {
              clientElement.due = clientElement.due + 1;
              clientElement.startDate = now;
              updateClient(clientElement, clientElement.id);
            } else if (clientElement.endDate != null &&
                data.userDetails.first.tokens != null) {
              DateTime now = DateTime.now();
              DateTime today = DateTime(now.year, now.month, now.day);
              int a = clientElement.endDate.difference(today).inDays;
              if ((a >= -1 && a <= 2) && clientElement.due >= 0) {
                await Future.forEach(data.userDetails.first.tokens,
                    (TokenModel element) async {
                  await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': 'key=$messageString'
                    },
                    body: constructFCMPayload(
                        element.token, clientElement, registerElement.name),
                  );
                });
                updateBatch = updateBatch +
                    "\n" +
                    "Notification sent to ${chronicleUser.displayName} for client ${clientElement.name} of register ${registerElement.name}";
              }
            }
          });
          update(updateBatch);
        });
      }
    });
  } catch (e) {
    globalShowInSnackBar(scaffoldMessengerKey, e);
  }
}
