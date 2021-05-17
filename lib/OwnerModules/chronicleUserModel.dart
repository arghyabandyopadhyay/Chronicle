import 'package:firebase_database/firebase_database.dart';

import 'ownerDatabaseModule.dart';

class ChronicleUserModel
{
  DatabaseReference id;
  String displayName;
  String email;
  String uid;
  int cloudStorageSize;
  int canAccess;
  ChronicleUserModel({this.displayName,this.email,this.uid,this.canAccess,this.cloudStorageSize});
  factory ChronicleUserModel.fromJson(Map<String, dynamic> json1) {
    return ChronicleUserModel(
        displayName: json1['DisplayName'],
        cloudStorageSize:json1['CloudStorageSize']!=null?json1['CloudStorageSize']:0,
        email: json1['Email'],
        uid: json1['UID'],
        canAccess: json1['CanAccess'],
    );
  }
  void setId(DatabaseReference id)
  {
    this.id=id;
  }
  void update(bool isForAccessChange)
  {
    updateChronicleUserDetails(this,this.id,isForAccessChange);
  }
  Map<String,dynamic> toJson() =>
      {
        "DisplayName":this.displayName,
        "Email":this.email,
        "UID":this.uid,
        "CanAccess":this.canAccess,
        "CloudStorageSize":this.cloudStorageSize!=null?this.cloudStorageSize:0
      };
}