import 'package:firebase_database/firebase_database.dart';

import 'ownerDatabaseModule.dart';

class ChronicleUserModel
{
  DatabaseReference id;
  String displayName;
  String email;
  String uid;
  int cloudStorageSize;
  int cloudStorageSizeLimit;
  int isAppRegistered;
  ChronicleUserModel({this.displayName,this.email,this.uid,this.isAppRegistered,this.cloudStorageSize,this.cloudStorageSizeLimit});
  factory ChronicleUserModel.fromJson(Map<String, dynamic> json1) {
    return ChronicleUserModel(
        displayName: json1['DisplayName'],
        cloudStorageSize:json1['CloudStorageSize']!=null?json1['CloudStorageSize']:0,
        cloudStorageSizeLimit:json1['CloudStorageSizeLimit']!=null?json1['CloudStorageSizeLimit']:10000000000,
        email: json1['Email'],
        uid: json1['UID'],
        isAppRegistered: json1['IsAppRegistered']!=null?json1['IsAppRegistered']:json1['CanAccess'],
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
        "IsAppRegistered":this.isAppRegistered,
        "CloudStorageSize":this.cloudStorageSize!=null?this.cloudStorageSize:0,
        "CloudStorageSizeLimit":this.cloudStorageSizeLimit!=null?this.cloudStorageSizeLimit:10000000000
      };
}