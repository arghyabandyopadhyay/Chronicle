import 'dart:convert';

import 'package:chronicle/OwnerModules/chronicleUserModel.dart';
import 'package:chronicle/Models/clientModel.dart';
import 'package:chronicle/Models/dataModel.dart';
import 'package:chronicle/Modules/universalModule.dart';
import 'package:chronicle/globalClass.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Modules/database.dart';

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
  DataSnapshot dataSnapshot = await databaseReference.child(uid+"/").once();
  DataModel data;
  data = DataModel.fromJson(jsonDecode(jsonEncode(dataSnapshot.value)),uid);
  data.setId(databaseReference.child(uid+"/"));
  return data;
}

Future<List<ChronicleUserModel>> getAllChronicleClients() async {
  DataSnapshot dataSnapshot = await databaseReference.child("${GlobalClass.userDetail.repo}/chronicleUsers/").once();
  List<ChronicleUserModel> data = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      ChronicleUserModel dataVal = ChronicleUserModel.fromJson(jsonDecode(jsonEncode(value)));
      dataVal.setId(databaseReference.child("${GlobalClass.userDetail.repo}/chronicleUsers/"+key));
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

List<ChronicleUserModel> sortChronicleUsersModule(String sortType,List<ChronicleUserModel> listToBeSorted){
  List<ChronicleUserModel> sortedList=[];
  if(sortType=="A-Z"){
    listToBeSorted.sort((a,b)=>a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    sortedList=listToBeSorted;
  }
  else if(sortType=="Z-A"){
    listToBeSorted.sort((a,b)=>b.displayName.toLowerCase().compareTo(a.displayName.toLowerCase()));
    sortedList=listToBeSorted;
  }
  return sortedList;
}