import 'dart:convert';

import 'package:chronicle/Models/registerModel.dart';
import 'package:chronicle/Models/userModel.dart';
import 'package:chronicle/Modules/database.dart';
import 'package:firebase_database/firebase_database.dart';


class DataModel {
  final List<RegisterModel> registers;
  final List<UserModel> userDetails;
  DatabaseReference id;

  DataModel({this.registers, this.userDetails});

  factory DataModel.fromJson(Map<String, dynamic> json1,String idKey) {
    List<RegisterModel> getRegisters(Map<String, dynamic> jsonList){
      List<RegisterModel> registerList = [];
      if (jsonList!= null) {
        jsonList.keys.forEach((key) {
          RegisterModel register = RegisterModel.fromJson(jsonDecode(jsonEncode(jsonList[key])),key);
          register.setId(databaseReference.child('$idKey/registers/' + key));
          registerList.add(register);
        });
      }
      return registerList;
    }
    List<UserModel> getUserDetailsList(Map<String, dynamic> jsonList){
      List<UserModel> registerList = [];
      if (jsonList!= null) {
        jsonList.keys.forEach((key) {
          UserModel register = UserModel.fromJson(jsonDecode(jsonEncode(jsonList[key])));
          register.setId(databaseReference.child('$idKey/userDetails/' + key));
          registerList.add(register);
        });
      }
      return registerList;
    }
    return DataModel(
      registers: getRegisters(jsonDecode(jsonEncode(json1['registers']))),
      userDetails: getUserDetailsList(jsonDecode(jsonEncode(json1['userDetails']))),
    );
  }

  void setId(DatabaseReference id)
  {
    this.id=id;
  }
}


// "$uid": {
// ".read": "$uid === auth.uid || auth.uid === '8daK26SfAmTAguFwBdNBAzTstuK2'",
// ".write": "$uid === auth.uid || auth.uid === '8daK26SfAmTAguFwBdNBAzTstuK2'"
// }